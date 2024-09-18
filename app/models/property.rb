class Property < ApplicationRecord
    self.table_name = 'spree_properties'
    has_many :property_values
end