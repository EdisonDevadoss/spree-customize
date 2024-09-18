class Seller::SettingController < Spree::StoreController
    include ApplicationHelper
    before_action :authenticate_spree_user!
    before_action :auth_seller
    layout 'shop'
  
    def index
      @user = spree_current_user
      @shipping_method = Spree::ShippingMethod.find_by(user_id: @user.id)
    end
  end
  