class Seller::OnboardingController < Spree::StoreController
  include ApplicationHelper
  before_action :authenticate_spree_user!
  before_action :auth_seller
  layout 'seller_onboarding'

  def new
    @user = spree_current_user
    current_step = SellerOnBoarding.find_by(user_id: @user.id)
    @shop = Shop.find_or_initialize_by(user_id: @user.id)
    @shop_info = ShopInfo.find_or_initialize_by(shop_id: @shop.id)

    if @shop_info
      @shop_billing_info = ShopBillingInfo.find_or_initialize_by(shop_info_id: @shop_info.id)
      @shop_billing_info.build_shop_billing_address unless @shop_billing_info.shop_billing_address

    end

    if @shop_info.born_on
      @birth_day = @shop_info.born_on.day
      @birth_month = @shop_info.born_on.strftime("%B")
      @birth_year = @shop_info.born_on.year
    end

    @shop_info.build_shop_bank_detail unless @shop_info.shop_bank_detail
    @shop_info.build_seller_business_info unless @shop_info.seller_business_info

    @step = current_step.step

    @navigate_step = @step

    render frame_render_view(@step)
  end

  def navigate
    @user = spree_current_user
    @navigate_step = params[:step].to_i

    current_step = SellerOnBoarding.find_by(user_id: @user.id)
    @step = current_step.step

    @shop = Shop.find_or_initialize_by(user_id: @user.id)
    @shop_info = ShopInfo.find_or_initialize_by(shop_id: @shop.id)

    if @shop_info
      @shop_billing_info = ShopBillingInfo.find_or_initialize_by(shop_info_id: @shop_info.id)
      @shop_billing_info.build_shop_billing_address unless @shop_billing_info.shop_billing_address
    end

    if @shop_info.born_on
      @birth_day = @shop_info.born_on.day
      @birth_month = @shop_info.born_on.strftime("%B")
      @birth_year = @shop_info.born_on.year
    end

    @shop_info.build_shop_bank_detail unless @shop_info.shop_bank_detail
    @shop_info.build_seller_business_info unless @shop_info.seller_business_info

    if @navigate_step <= 0
      @navigate_step = @step
    end

    if @navigate_step <= @step
      render frame_render_view(@navigate_step)
    else
      render frame_render_view(@step)
    end
  end

  private

  def frame_render_view(step)
    case step
    when 1
      "seller/onboarding/shop_preferences"
    when 2
      "seller/onboarding/get_paid"
    when 3
      "seller/onboarding/share_billing_info"
    end
  end
end
