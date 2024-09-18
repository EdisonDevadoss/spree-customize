class Seller::RegistrationsController < Spree::StoreController
  layout 'spree_application'

  def new
    @seller = Spree::Seller.new
  end

  def create
    @seller = Spree::Seller.new(user_params)
    if @seller.save
      sign_in(:spree_user, @seller)
      flash[:notice] = 'Seller signed up successfully. Please complete the onboarding process.'
      # redirect_to new_seller_onboarding_path
      render json: { message: 'Seller signed up successfully.', redirect_url: new_seller_onboarding_path }, status: :ok
    else
      # flash.now[:error] = @seller.errors.full_messages.join(", ")
      render json: { errors: @seller.errors.full_messages }, status: :unprocessable_entity
      # render :new
      # redirect_to new_seller_registration_path
    end
  end

  private

  def user_params
    params.require(:seller).permit(:email, :password, :password_confirmation)
  end
end
