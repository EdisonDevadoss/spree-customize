class ApplicationController < ActionController::Base
  helper_method :authenticate_spree_seller, :auth_seller

  def authenticate_spree_seller
    authenticate_spree_user!
    role_user = spree_current_user.role_users.find_by(user_id: spree_current_user.id);
    role = role_user&.role
    if role.nil?
      return false
    else
     @shop = Shop.find_by(user_id: spree_current_user.id)
     role.name == 'seller'
    end
  end

  def auth_seller
    unless authenticate_spree_seller
      redirect_to spree.root_path, alert: "You are not authorized to access this page."
    end
  end
end
