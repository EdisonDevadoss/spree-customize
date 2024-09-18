class Seller::ShopBillingInfosController < Spree::StoreController
  include ApplicationHelper
  before_action :authenticate_spree_user!
  before_action :auth_seller
  layout 'seller_onboarding'
  

  def create
    @user = spree_current_user

    shop_info = ShopInfo.find_by(user_id: @user.id)
    shop_billing_info = ShopBillingInfo.find_or_initialize_by(shop_info_id: shop_info.id)

    shop_billing_info.assign_attributes(shop_billing_info_params.merge(user_id: @user.id))

    if shop_billing_info.save
      shop_billing_address = ShopBillingAddress.find_or_initialize_by(shop_billing_info_id: shop_billing_info.id)
      shop_billing_address.assign_attributes(shop_billing_address_params.merge(user_id: @user.id))
      shop_billing_address.save

      @current_step = SellerOnBoarding.find_by(user_id: @user.id)
      @current_step.step = @current_step.step > 3 ? @current_step.step : 3;
      @current_step.status = 'completed'
      @current_step.save
      puts "Shop was successfully saved."
      flash[:success] = 'Seller onboarding successfully updated'
      redirect_to seller_dashboard_index_path
    else
      # Handle the error
      puts "Error saving shop: #{shop_billing_info.errors.full_messages.join(", ")}"
      flash[:error] = shop_billing_info.errors.full_messages.join("\n")
      redirect_to seller_navigate_onboarding_path
    end
  end

  def edit
    @user = spree_current_user
    shop_info = ShopInfo.find_by(user_id: @user.id)

    if @shop_info
      @shop_billing_info = ShopBillingInfo.find_or_initialize_by(shop_info_id: @shop_info.id)
      @shop_billing_info.build_shop_billing_address unless @shop_billing_info.shop_billing_address
    end
  end
  
  def update
    @user = spree_current_user
    shop_info = ShopInfo.find_by(user_id: @user.id)
    @shop_billing_info = ShopBillingInfo.find_by(shop_info_id: shop_info.id)
  
    if @shop_billing_info.present?
      @shop_billing_info.assign_attributes(shop_billing_info_params.merge(user_id: @user.id))
  
      if @shop_billing_info.save
        shop_billing_address = @shop_billing_info.shop_billing_address || @shop_billing_info.build_shop_billing_address
        shop_billing_address.assign_attributes(shop_billing_address_params.merge(user_id: @user.id))
        shop_billing_address.save

  
        flash[:success] = 'Billing information successfully updated'
        redirect_to seller_billing_info_index_path(tab: 'billing-info')
      else
        flash[:error] = @shop_billing_info.errors.full_messages.join("\n")
        redirect_to seller_billing_info_index_path(tab: 'billing-info')
      end
    else
      flash[:error] = 'Shop billing information not found'
      redirect_to seller_settings_index_path
    end
  end
  

  private

  def shop_billing_info_params
    params.require(:shop_billing_info).permit(:card_number, :exp_month, :exp_year, :ccv, :name_on_card)
  end

  def shop_billing_address_params
    params.require(:shop_billing_address).permit(:country, :street_name, :area, :zip_code, :city, :state)
  end

  def update_onboarding_step(user, step)
    onboarding = SellerOnBoarding.find_or_initialize_by(user_id: user.id)
    onboarding.step = [onboarding.step, step].max
    onboarding.status = 'completed'
    onboarding.save
  end
end
