class Seller::StockLocationsController < Spree::StoreController
  layout 'shop'

  def new
    @shop = Shop.find_by(user_id: spree_current_user.id)
    @stock_location = Spree::StockLocation.find_or_initialize_by(shop_id: @shop.id)
    @countries = Spree::Country.all
    @states = Spree::State.all

    puts @stock_location.inspect
  end

  def create
    attrs = stock_location_parmas

    @user = spree_current_user
    @shop = Shop.find_by(user_id: @user.id)

    attrs[:shop_id] = @shop.id
    attrs[:active] = true

    @stock_location = Spree::StockLocation.find_or_initialize_by(shop_id: @shop.id)
    @stock_location.assign_attributes(attrs)

    if @stock_location.save
      flash[:notice] = 'Stock Location was successfully saved.'
      redirect_to seller_stock_locations_path
    else
      puts "Error saving shop: #{@stock_location.errors.full_messages.join(", ")}"
      flash[:error] = @stock_location.errors.full_messages.join("\n")
      redirect_to seller_stock_locations_path
    end
  end

  private

  def stock_location_parmas
    params.require(:stock_location).permit(:name, :address1, :city, :zipcode, :phone, :address2, :city, :country_id,
                                           :state_id)
  end
end
