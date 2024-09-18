class Seller::DashboardController < Spree::StoreController
  include ApplicationHelper
  before_action :authenticate_spree_user!
  before_action :auth_seller
  layout 'shop'

  def index
    @user = spree_current_user
    current_step = SellerOnBoarding.find_by(user_id: @user.id)
    @shop = Shop.find_by(user_id: @user.id)

    if current_step.status == 'completed'
      render "seller/dashboard/index"
    else
      redirect_to seller_navigate_onboarding_path
    end
  end
end
