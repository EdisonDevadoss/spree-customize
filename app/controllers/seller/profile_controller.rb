class Seller::ProfileController < Spree::StoreController
  include ApplicationHelper
 
  layout 'shop'

  def index

    @shop = Shop.find(params[:shop_id])
    @products = Spree::Product.includes(:variants).where(shop_id: params[:shop_id]).order("created_at DESC")

    @products = if params[:query].present?
      @products.where("name ILIKE :query", query: "%#{params[:query]}%")
    else
      @products.all
    end
    
    @products = @products.page(params[:page]).per(10)

    @product_details = @products.map do |product|
      variant = product.variants.first
      @images = product.master.images.first
      price = variant.present? ? Spree::Price.where(variant_id: variant.id).first : nil
      {
        product: product,
        variant: variant,
        price: price,
        image: @images
      }
    end
  end

  def edit
    @shop = Shop.find_by(user_id: spree_current_user.id)
  end
  
  def update
    @shop = Shop.find_by(user_id: spree_current_user.id)

    handle_image_removals
  
    if params[:shop][:banner].present?
      @shop.banner.attach(params[:shop][:banner]) if params[:shop][:banner].is_a?(ActionDispatch::Http::UploadedFile)
    end
  
    if params[:shop][:logo].present?
      @shop.logo.attach(params[:shop][:logo]) if params[:shop][:logo].is_a?(ActionDispatch::Http::UploadedFile)
    end
    
    if @shop.update(update_shop_params)
      flash[:success] = "Shop updated successfully."
      redirect_to edit_seller_profile_path(spree_current_user)
    else
      flash[:error] = @shop.errors.full_messages.join("\n")
      render :edit, status: :unprocessable_entity
    end
  end
  private

  def update_shop_params
    params.require(:shop).permit(:name, :language, :country, :currency, :banner, :logo, :about_us)
  end

  def handle_image_removals
    if params[:shop][:remove_banner] == '1'
      @shop.banner.purge if @shop.banner.attached?
    end
  
    if params[:shop][:remove_logo] == '1'
      @shop.logo.purge if @shop.logo.attached?
    end
  end
end