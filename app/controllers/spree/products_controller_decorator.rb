module Spree::ProductsControllerDecorator
    def self.prepended(base)
      base.include Spree::RecentlyViewedProductsHelper
      base.helper_method [:cached_recently_viewed_products, :cached_recently_viewed_products_ids]
      base.before_action :set_current_order, except: :recently_viewed
      base.after_action :save_recently_viewed, only: :recently_viewed
    end
  
    def recently_viewed
      render 'spree/products/recently_viewed', layout: false
    end
  
    private
  
    def save_recently_viewed
      id = params[:product_id]
      return unless id.present?
  
      rvp = (cookies['recently_viewed_products'] || '').split(', ')
      rvp.delete(id)
      rvp << id unless rvp.include?(id.to_s)
      rvp_max_count = Spree::RecentlyViewed::Config.preferred_recently_viewed_products_max_count
      rvp.delete_at(0) if rvp.size > rvp_max_count.to_i

      cookies['recently_viewed_products'] = rvp.join(', ')
    end
  end
  
  Spree::ProductsController.prepend Spree::ProductsControllerDecorator
  