class Seller::BillingInfoController < Spree::StoreController
    include ApplicationHelper
    before_action :authenticate_spree_user!
    before_action :auth_seller
    layout 'shop'
  
    def index
      @user = spree_current_user
      @shop_info = ShopInfo.find_by(user_id: @user.id)

      if @shop_info
        @shop_billing_info = ShopBillingInfo.find_or_initialize_by(shop_info_id: @shop_info.id)
        @shop_billing_info.build_shop_billing_address unless @shop_billing_info.shop_billing_address
      end

      @shop_info.build_shop_bank_detail unless @shop_info.shop_bank_detail
      @shop_info.build_seller_business_info unless @shop_info.seller_business_info

      if @shop_info.born_on
        @birth_day = @shop_info.born_on.day
        @birth_month = @shop_info.born_on.strftime("%B")
        @birth_year = @shop_info.born_on.year
      end
    end
  end
  