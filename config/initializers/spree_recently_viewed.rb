module Spree
    class RecentlyViewedSetting < Preferences::Configuration
      preference :recently_viewed_products_max_count, :integer, default: 5
    end
    module RecentlyViewed
    end
  end
  


  Spree::RecentlyViewed::Config = Spree::RecentlyViewedSetting.new
