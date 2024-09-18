module Spree
    module RecentlyViewedProductsHelper
      def cached_recently_viewed_products_ids
        (cookies['recently_viewed_products'] || '').split(', ')
      end
  
      def cached_recently_viewed_products
        ids = cached_recently_viewed_products_ids 
        Spree::Product.where(id: ids)
      end
    end
  end
  