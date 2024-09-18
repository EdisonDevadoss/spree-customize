module Spree
  class ProductsTaxon < ActiveRecord::Base
    self.table_name = 'spree_products_taxons'

    # If needed, you can add associations here
    belongs_to :product, class_name: 'Spree::Product'
    belongs_to :taxon, class_name: 'Spree::Taxon'
  end
end
