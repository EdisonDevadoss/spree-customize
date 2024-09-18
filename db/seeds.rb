# Load Spree seeds
Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

# Define a method to create or update properties and associated values
def create_or_update_property_with_values(name, presentation, filterable, filter_param, values = [])
  # Find or initialize a property by name
  property = Property.find_or_initialize_by(name: name)

  # Only update the property if attributes have changed
  if property.new_record? || property.presentation != presentation || property.filterable != filterable || property.filter_param != filter_param
    property.update!(
      presentation: presentation,
      filterable: filterable,
      filter_param: filter_param
    )
  end

  # Iterate over the provided values
  values.each do |value|
    # Find or initialize the property value by name and property_id
    property_value = PropertyValue.find_or_initialize_by(name: value, property_id: property.id)

    # Save the property value if it's new or has changes
    property_value.save! if property_value.new_record? || property_value.changed?
  end

  property
end

# Create or update properties and property values
create_or_update_property_with_values(
  "PrimaryColor",
  "Primary Color",
  true,
  "PrimaryColor",
  ["Black", "White", "Blue", "Green", "Yellow", "Red"]
)

create_or_update_property_with_values(
  "SecondaryColor",
  "Secondary Color",
  true,
  "SecondaryColor",
  ["Red", "Orange", "Silver", "Golden"]
)

create_or_update_property_with_values(
  "GemType",
  "Gem Type",
  true,
  "GemType",
  ["Amethyst", "Ametrine", "Aquamarine", "Coral"]
)

create_or_update_property_with_values("CaratWeight", "Carat Weight", true, "CaratWeight")
create_or_update_property_with_values("Height", "Height", true, "Height")
create_or_update_property_with_values("Width", "Width", true, "Width")
create_or_update_property_with_values("Length", "Length", true, "Length")

create_or_update_property_with_values(
  "Origin",
  "Origin",
  true,
  "Origin",
  ["Burma", "Sri lanka", "Madagascar", "Nigeria", "India", "Pakistan", "Thailand", "Usa", "Colombia", "Russia", "Congo", "Tanzania", "Brazil", "Afghanistan", "Others"]
)

create_or_update_property_with_values("CustomOrigin", "Custom Origin", true, "CustomOrigin")

create_or_update_property_with_values(
  "Material",
  "Material",
  true,
  "Material",
  ["Bamboo", "Ceramic", "Fabric", "Glass", "Metal", "Paper", "Plastic", "Porcelain", "Stone", "Wood", "Wicker", "Shell"]
)

create_or_update_property_with_values(
  "JewelleryShape",
  "Jewellery Shape",
  true,
  "JewelleryShape",
  ["Circle", "Heart", "Oval", "Rectangle", "Square"]
)

create_or_update_property_with_values(
  "JewelleryType",
  "Jewellery Type",
  true,
  "JewelleryType",
  ["Ring", "Necklace", "Bracelet", "Earrings", "Brooch", "Pin", "Cuff links", "Tie clip", "Watch",]
)

create_or_update_property_with_values(
  "Celebration",
  "Celebration",
  true,
  "Celebration",
  ["Christmas", "Easter", "Halloween", "Mother's Day", "Valentine's Day"]
)

create_or_update_property_with_values(
  "Recipient",
  "Recipient",
  true,
  "Recipient",
  ["Women", "Men", "Boys", "Girls", "Unisex adults", "Unisex kids"]
)

create_or_update_property_with_values(
  "Theme",
  "Theme",
  true,
  "Theme",
  ["Animals", "Beach & tropical", "Fantasy & Sci Fi", "Food & drink", "Letters & words", "Love & friendship", "Music",
   "Nautical", "Patriotic & flags", "People"]
)

create_or_update_property_with_values(
  "Shape",
  "Shape",
  true,
  "Shape",
  ["Round", "Oval", "Pear", "Emerald", "L Radiant", "Princess", "Sq Emerald", "Heart", "Marquise", "Cushion", "Cu Plasma",
   "Triangular", "Baguette", "Sq Baguette", "T Baguette", "Cu-b", "Hexagonal", "Sq Hexagonal", "Half Moon", "Trapezoid",
   "Emerald Modified", "Triangular Modified", "Oval Modified", "Pear Modified", "Heart Modified", "Marquise Modified",
   "Cushion Modified", "L Radiant Modified", "Princess Modified", "Sq Eme Modified", "Round Modified", "Sq Radiant",
   "Other"]
)

# Output the result
puts "Created or updated #{PropertyValue.count} Property Values"
