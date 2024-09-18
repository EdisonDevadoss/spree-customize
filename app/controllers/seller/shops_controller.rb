class Seller::ShopsController < Spree::StoreController
  include ApplicationHelper
  before_action :authenticate_spree_user!
  before_action :auth_seller
  layout 'seller_onboarding'

  def create
    @user = spree_current_user
    shop = Shop.find_or_initialize_by(user_id: @user.id)
    shop.assign_attributes(shop_params)

    if shop.save
      puts "Shop was successfully saved."
      @current_step = SellerOnBoarding.find_by(user_id: @user.id)
      @current_step.step = @current_step.step > 2 ? @current_step.step : 2;
      @current_step.save
      redirect_to seller_navigate_onboarding_path
    else
      # Handle the error
      puts "Error saving shop: #{shop.errors.full_messages.join(", ")}"
      flash[:error] = shop.errors.full_messages.join("\n")
      redirect_to seller_navigate_onboarding_path(step: 1)
    end
  end

  private

  def shop_params
    params.require(:shop).permit(:name, :language, :country, :currency)
  end
end
