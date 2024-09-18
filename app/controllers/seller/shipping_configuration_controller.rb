class Seller::ShippingConfigurationController < Spree::StoreController
  include ApplicationHelper
  before_action :authenticate_spree_user!
  before_action :auth_seller
  layout 'shop'

  before_action :set_form_dependencies, only: [:new, :create, :edit, :update]

  def new
    @shipping_method = Spree::ShippingMethod.new
    @zones = Spree::Zone.includes(:zone_members).all
  end

  def create
    @user = spree_current_user
    @shop = Shop.find_by(user_id: @user.id)
    ship_cat = Spree::ShippingCategory.where(id: 1)

    @shipping_method = Spree::ShippingMethod.find_or_initialize_by(user_id: @user.id, shop_id: @shop.id)

    @shipping_method.assign_attributes(
      name: shipping_method_params[:name],
      display_on: 'both',
      code: shipping_method_params[:code],
      shipping_categories: ship_cat,
      calculator_type: shipping_method_params[:calculator_type],
      zone_ids: shipping_method_params[:zone_ids],
    )

    if @shipping_method.save
      if shipping_method_params[:calculator_attributes].present?
       @calculator = Spree::Calculator.find_by(id: shipping_method_params[:calculator_attributes][:id])
       if @calculator
         @calculator.preferred_amount = shipping_method_params[:calculator_attributes][:preferred_amount]
         @calculator.preferred_currency = @shop.currency
         @calculator.save
       end
      end

      handle_zones
      redirect_to seller_setting_index_path, notice: 'Shipping method saved successfully.'
    else
      puts @shipping_method.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = spree_current_user
    @shipping_method = Spree::ShippingMethod.find_by(user_id: @user.id)
    @shop = Shop.find_by(user_id: @user.id)
    @shipping_method.calculator.preferred_currency = @shop.currency
    puts "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
    puts @user.inspect

  end

  private

  def shipping_method_params
    params.require(:shipping_method).permit(
      :name, :display_on, :admin_name, :code, :tax_category_id, :calculator_type,
      shipping_category_ids: [], zone_ids: [],
      calculator_attributes: [:preferred_amount, :preferred_currency, :id]
    ).tap do |whitelisted|
      whitelisted[:tax_category_id] = whitelisted[:tax_category_id].to_i if whitelisted[:tax_category_id].present?

      if whitelisted[:calculator_attributes]
        whitelisted[:calculator_attributes][:preferred_amount] = whitelisted[:calculator_attributes][:preferred_amount].to_d
        whitelisted[:calculator_attributes][:id] = whitelisted[:calculator_attributes][:id].to_i
      end
    end  
  end

  def handle_shipping_categories
    return unless params[:shipping_method][:shipping_category_ids].present?

    @shipping_method.shipping_categories = Spree::ShippingCategory.where(id: params[:shipping_method][:shipping_category_ids])
  end

  def handle_zones
    return true if params['shipping_method'][:zones].blank?

    @shipping_method.zones = Spree::Zone.where(id: params['shipping_method'][:zones])
    @shipping_method.save
    params[:shipping_method].delete(:zones)
  end

  def set_form_dependencies
    @tax_categories = Spree::TaxCategory.all
    @calculators = Spree::ShippingMethod.calculators.sort_by(&:name)
    @zones = Spree::Zone.all
    @shipping_categories = Spree::ShippingCategory.all
  end
end
