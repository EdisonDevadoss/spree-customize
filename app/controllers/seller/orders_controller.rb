module Seller
  class OrdersController < Spree::StoreController
    include ApplicationHelper
    before_action :authenticate_spree_user!
    before_action :auth_seller
    layout 'shop'

    def index
      @orders = Spree::Order.for_shop(@shop)
      
      @query = params[:query]

      @orders = if @query.present?
        @orders.where('number LIKE ?', "%#{@query}%")
      else
        @orders.all
      end

      @orders = @orders.page(params[:page]).per(10)
    end

    def show
      @order = Spree::Order.for_shop(@shop).find_by(number: params[:id])
      @shop_line_items = @order.line_items.where(shop_id: @shop.id)
    end

    def update_line_item
      line_item = Spree::LineItem.find(params[:line_item_id])
      if line_item.approved? || params[:shipment_state].blank?
        if line_item.update(line_item_params)
          flash[:notice] = 'Line item updated successfully'
        else
          flash[:alert] = 'Error updating line item'
        end
      else
        flash[:alert] = 'Line item must be approved before updating shipment state'
      end
      redirect_to seller_order_path(line_item.order)
    end

    def approve_line_item
      line_item = Spree::LineItem.find(params[:line_item_id])
      if line_item.approve!(current_spree_user)
        flash[:notice] = 'Line item approved successfully'
      else
        flash[:alert] = 'Error approving line item'
      end
      redirect_to seller_order_path(line_item.order)
    end

    def cancel_line_item
      line_item = Spree::LineItem.find(params[:line_item_id])
      puts "madddd"
      puts line_item.inspect
      puts "ca"
      if line_item.cancel!(current_spree_user)
        flash[:notice] = 'Line item canceled successfully'
      else
        flash[:alert] = 'Error canceling line item'
      end
      redirect_to seller_order_path(line_item.order)
    end

    private

    def line_item_params
      params.permit(:shipment_state)
    end

  end
end
