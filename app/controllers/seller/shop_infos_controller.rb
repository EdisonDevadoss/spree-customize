class Seller::ShopInfosController < Spree::StoreController
  include ApplicationHelper
  before_action :authenticate_spree_user!
  before_action :auth_seller
  layout 'seller_onboarding'

  def create
    combined_birth_date = combine_date(params[:shop_info].delete(:birth_day), params[:shop_info].delete(:birth_month),
                                       params[:shop_info].delete(:birth_year))

    account_number = shop_bank_detail_params[:account_number]
    confirm_account_number = confirm_account_number_params[:confirm_account_number]

    if account_number != confirm_account_number
      flash[:error] = "Account number and Confirm account number is mismatched"
      redirect_to seller_navigate_onboarding_path(step: 2)
    elsif combined_birth_date.nil?
      flash[:error] = "Invalid birth date selected."
      redirect_to seller_navigate_onboarding_path(step: 2)
    else
      @user = spree_current_user
      shop = Shop.find_by(user_id: @user.id)

      shop_info = ShopInfo.find_or_initialize_by(shop_id: shop.id)
      shop_info.assign_attributes(shop_info_params.merge(born_on: combined_birth_date, user_id: @user.id))

      if shop_info.save
        puts "Shop was successfully saved."

        shop_detail_info = ShopBankDetail.find_or_initialize_by(shop_info_id: shop_info.id)
        shop_detail_info.assign_attributes(shop_bank_detail_params.merge(user_id: @user.id))
        shop_detail_info.save

        seller_business_info = SellerBusinessInfo.find_or_initialize_by(shop_info_id: shop_info.id)

        if shop_info.tax_payer_type == 'individual'
          seller_business_info.destroy
        else
          seller_business_info.assign_attributes(seller_business_info_params.merge(user_id: @user.id))
          seller_business_info.save
        end

        @current_step = SellerOnBoarding.find_by(user_id: @user.id)
        @current_step.step = @current_step.step > 3 ? @current_step.step : 3;
        @current_step.save
        redirect_to seller_navigate_onboarding_path
      else
        # Handle the error
        puts "Error saving shop: #{shop_info.errors.full_messages.join(", ")}"
        flash[:error] = shop_info.errors.full_messages.join(", ")
        redirect_to seller_navigate_onboarding_path(step: 2)
      end
    end
  end

  def edit
    @shop_info = ShopInfo.find_by(shop_id: current_shop.id)

    @shop_info.build_shop_bank_detail unless @shop_info.shop_bank_detail
    @shop_info.build_seller_business_info unless @shop_info.seller_business_info

    if @shop_info.born_on
      @birth_day = @shop_info.born_on.day
      @birth_month = @shop_info.born_on.strftime("%B")
      @birth_year = @shop_info.born_on.year
    end
  end

  def update
    @shop_info = ShopInfo.find_by(shop_id: current_shop.id)

    combined_birth_date = combine_date(params[:shop_info].delete(:birth_day), params[:shop_info].delete(:birth_month),
                                       params[:shop_info].delete(:birth_year))

    account_number = shop_bank_detail_params[:account_number]
    confirm_account_number = confirm_account_number_params[:confirm_account_number]

    if account_number != confirm_account_number
      flash[:error] = "Account number and Confirm account number is mismatched"
      redirect_to seller_billing_info_index_path(tab: 'payment-info') and return
    elsif combined_birth_date.nil?
      flash[:error] = "Invalid birth date selected."
      redirect_to seller_billing_info_index_path(tab: 'payment-info') and return
    else
      @shop_info.assign_attributes(shop_info_params.merge(born_on: combined_birth_date))

      if @shop_info.save
        shop_detail_info = ShopBankDetail.find_or_initialize_by(shop_info_id: @shop_info.id)
        shop_detail_info.assign_attributes(shop_bank_detail_params.merge(user_id: spree_current_user.id))
        shop_detail_info.save

        seller_business_info = SellerBusinessInfo.find_or_initialize_by(shop_info_id: @shop_info.id)

        if @shop_info.tax_payer_type == 'individual'
          seller_business_info.destroy
        else
          seller_business_info.assign_attributes(seller_business_info_params.merge(user_id: spree_current_user.id))
          seller_business_info.save
        end

        flash[:success] = 'Information successfully updated'
        redirect_to seller_billing_info_index_path(tab: 'payment-info')
      else
        flash[:error] = @shop_info.errors.full_messages.join(", ")
        redirect_to seller_billing_info_index_path(tab: 'payment-info')
      end
    end
  end

  private

  def current_shop
    @current_shop ||= Shop.find_by(user_id: spree_current_user.id)
  end

  def shop_info_params
    params.require(:shop_info).permit(:country, :first_name, :last_name, :street_name, :area,
                                      :post_code, :city, :state, :phone_number, :tax_payer_type)
  end

  def shop_bank_detail_params
    params.require(:shop_bank_detail).permit(:account_holder_name, :bank_name, :sort_code, :account_number)
  end

  def seller_business_info_params
    params.require(:seller_business_info).permit(:country, :street_address, :area, :city, :pincode, :state,
                                                 :phone_number, :business_type, :legal_entity, :gstin)
  end

  def confirm_account_number_params
    params.require(:shop_bank_detail).permit(:confirm_account_number)
  end

  def combine_date(day, month, year)
    begin
      month_number = Date::MONTHNAMES.index(month.capitalize) || Date::ABBR_MONTHNAMES.index(month.capitalize)
      Date.new(year.to_i, month_number.to_i, day.to_i)
    rescue ArgumentError
      nil
    end
  end
end
