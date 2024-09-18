class Seller::ListingController < Spree::StoreController
  include ApplicationHelper
  before_action :authenticate_spree_user!
  before_action :auth_seller
  layout 'shop'

  def index
    @user = spree_current_user
    @shop = Shop.find_by(user_id: @user.id)

    puts @shop.inspect

    @products = Spree::Product.includes(:variants).where(shop_id: @shop.id).order("created_at DESC")

    @products = if params[:query].present?
                  @products.joins(variants: [:prices])
                           .where("name ILIKE :query OR description ILIKE :query OR spree_prices.amount::text ILIKE :query", query: "%#{params[:query]}%").distinct
                else
                  @products.all
                end

    if params[:status].present?
      @products = @products.where(status: params[:status])
    end

    if params[:price_option] == 'custom'
      min_price = params[:min_price].to_f
      max_price = params[:max_price].to_f
      @products = @products.joins(variants: :prices).where('spree_prices.amount >= ? AND spree_prices.amount <= ?',
                                                           min_price, max_price)
    end

    @products = @products.page(params[:page]).per(10)

    @product_details = @products.map do |product|
      variant = product.variants.first

      puts '-----------------------PRODUCT INSPECT--------------------------------------'
      puts product.inspect
      if product.certificate.present?
        puts '---------------INSID if is called----------------------------'
        puts product.certificate
      end
      puts '------------------------PRODUCT INSPECT----------------------------------------------------'

      puts '-------------------IMAGES------------------------'
      puts product.master.images

      @images = product.master.images.first

      puts 'images---------------------'

      puts @images

      price = variant.present? ? Spree::Price.where(variant_id: variant.id).first : nil

      puts price.inspect
      {
        product: product,
        variant: variant,
        price: price,
        image: @images
      }
    end
  end

  def new
    @product = Spree::Product.new

    @PrimaryColorLabel = Spree::Property.find_by(name: "PrimaryColor")
    @SecondaryColorLabel = Spree::Property.find_by(name: "SecondaryColor")
    @GemTypeLabel = Spree::Property.find_by(name: "GemType")
    @CaratWeightLabel = Spree::Property.find_by(name: "CaratWeight")
    @OriginProperty = Spree::Property.find_by(name: "Origin")
    @CustomOriginProperty = Spree::Property.find_by(name: "CustomOrigin")

    @MaterialProperty = Spree::Property.find_by(name: "Material")
    @JewelleryShapeProperty = Spree::Property.find_by(name: "JewelleryShape")
    @JewelleryTypeProperty = Spree::Property.find_by(name: "JewelleryType")
    @CelebrationProperty = Spree::Property.find_by(name: "Celebration")
    @RecipientProperty = Spree::Property.find_by(name: "Recipient")
    @ThemeProperty = Spree::Property.find_by(name: "Theme")
    @ShapeProperty = Spree::Property.find_by(name: "Shape")

    @Taxon = Spree::Taxon.where.not(name: "Category")

    @PrimaryColorPropertyValue = PropertyValue.where(property_id: @PrimaryColorLabel.id)
    @SecondaryColorPropertyValue = PropertyValue.where(property_id: @SecondaryColorLabel.id)
    @GemTypePropertyValue = PropertyValue.where(property_id: @GemTypeLabel.id)
    @MaterialPropertyValue = PropertyValue.where(property_id: @MaterialProperty.id)
    @JewelleryShapePropertyValue = PropertyValue.where(property_id: @JewelleryShapeProperty.id)
    @JewelleryTypePropertyValue = PropertyValue.where(property_id: @JewelleryTypeProperty.id)
    @CelebrationPropertyValue = PropertyValue.where(property_id: @CelebrationProperty.id)
    @RecipientPropertyValue = PropertyValue.where(property_id: @RecipientProperty.id)
    @ThemePropertyValue = PropertyValue.where(property_id: @ThemeProperty.id)
    @OriginPropertyValue = PropertyValue.where(property_id: @OriginProperty.id)
    @ShapePropertyValue = PropertyValue.where(property_id: @ShapeProperty.id)

    puts "ThemePropertyValue========================"
    puts @ThemePropertyValue.inspect
  end

  def getSpreeProperty(propertyValueId)
    property_value = PropertyValue.where(id: propertyValueId)
    property_value_instance = property_value.first
    property = Spree::Property.find_by(id: property_value_instance.property_id)
    return { property_value: property_value_instance, property: property }
  end

  def findPropertyIdByName(name)
    return Spree::Property.where(name: name).first
  end

  def createProductProperty(propertyName, productId, propertyId)
    @ProductProperties = Spree::ProductProperty.create(value: propertyName,
                                                       product_id: productId,
                                                       property_id: propertyId)
  end

  def create
    puts "product_info_params---------**************************8"
    # puts product_info_params
    # puts product_params
    puts params[:product_id].present?

    store = Spree::Store.first # Adjust this to find the correct store
    shipping_category = Spree::ShippingCategory.first
    price = product_info_params[:price]
    status = product_info_params[:status]
    quantity = product_info_params[:quantity]

    @user = spree_current_user
    @shop = Shop.find_by(user_id: @user.id)

    stock_location = Spree::StockLocation.find_by(shop_id: @shop.id)

    if stock_location.nil?
      raise ActiveRecord::RecordNotFound, "Stock Location is not found for #{@shop.name}."
    end

    ActiveRecord::Base.transaction do
      @product = Spree::Product.new(
        name: product_params[:name],
        description: product_params[:description],
        certificate: product_params[:certificate],
        video: product_params[:video],
        shop_id: @shop.id,
        currency: @shop.currency,
        shipping_category: shipping_category,
        price: price,
        stores: [store],
        status: status
      )

      if @product.save
        if property_params[:primary_color].present?
          primary_property = getSpreeProperty(property_params[:primary_color])
          createProductProperty(primary_property[:property_value].name, @product.id, primary_property[:property].id)
        end

        if property_params[:carat_weight].present?
          property = findPropertyIdByName('CaratWeight')
          createProductProperty(property_params[:carat_weight], @product.id, property.id)
        end

        if property_params[:secondary_color] && !property_params[:secondary_color].empty?
          secondaryProperty = getSpreeProperty(property_params[:secondary_color])
          createProductProperty(secondaryProperty[:property_value].name, @product.id, secondaryProperty[:property].id)
        end

        if property_params[:gem_type] && !property_params[:gem_type].empty?
          gemTypeProperty = getSpreeProperty(property_params[:gem_type])
          createProductProperty(gemTypeProperty[:property_value].name, @product.id, gemTypeProperty[:property].id)
        end

        if property_params[:height] && !property_params[:height].empty?
          property = findPropertyIdByName('Height')
          createProductProperty(property_params[:height], @product.id, property.id)
        end

        if property_params[:width] && !property_params[:width].empty?
          property = findPropertyIdByName('Width')
          createProductProperty(property_params[:width], @product.id, property.id)
        end

        if property_params[:length] && !property_params[:length].empty?
          property = findPropertyIdByName('Length')
          createProductProperty(property_params[:length], @product.id, property.id)
        end

        if property_params[:origin] && !property_params[:origin].empty?
          origin_property = getSpreeProperty(property_params[:origin])
          puts origin_property.inspect
          createProductProperty(origin_property[:property_value].name, @product.id, origin_property[:property].id)

          if origin_property[:property_value].name == 'Others'
            custom_origin_property = findPropertyIdByName('CustomOrigin')
            createProductProperty(property_params[:custom_origin], @product.id, custom_origin_property.id)
          end

        end

        if property_params[:material] && !property_params[:material].empty?
          materialProperty = getSpreeProperty(property_params[:material])
          createProductProperty(materialProperty[:property_value].name, @product.id, materialProperty[:property].id)
        end

        if property_params[:jewellery_shape] && !property_params[:jewellery_shape].empty?
          jewelleryShapeProperty = getSpreeProperty(property_params[:jewellery_shape])
          createProductProperty(jewelleryShapeProperty[:property_value].name, @product.id,
                                jewelleryShapeProperty[:property].id)
        end

        if property_params[:jewellery_type] && !property_params[:jewellery_type].empty?
          jewelleryTypeProperty = getSpreeProperty(property_params[:jewellery_type])
          createProductProperty(jewelleryTypeProperty[:property_value].name, @product.id,
                                jewelleryTypeProperty[:property].id)
        end

        if property_params[:celebration] && !property_params[:celebration].empty?
          celebrationProperty = getSpreeProperty(property_params[:celebration])
          createProductProperty(celebrationProperty[:property_value].name, @product.id,
                                celebrationProperty[:property].id)
        end

        if property_params[:recipient] && !property_params[:recipient].empty?
          recipientProperty = getSpreeProperty(property_params[:recipient])
          createProductProperty(recipientProperty[:property_value].name, @product.id, recipientProperty[:property].id)
        end

        if property_params[:theme] && !property_params[:theme].empty?
          themeProperty = getSpreeProperty(property_params[:theme])
          createProductProperty(themeProperty[:property_value].name, @product.id, themeProperty[:property].id)
        end

        if property_params[:shape] && !property_params[:shape].empty?
          shapeProperty = getSpreeProperty(property_params[:shape])
          createProductProperty(shapeProperty[:property_value].name, @product.id, shapeProperty[:property].id)
        end

        productTaxon = Spree::ProductsTaxon.where(taxon_id: product_info_params[:taxon]).last
        if productTaxon.present?
          new_position = productTaxon.position + 1;
        else
          new_position = 1
        end
        Spree::ProductsTaxon.create(product_id: @product.id, taxon_id: product_info_params[:taxon],
                                    position: new_position)

        images = product_image_params[:images]

        if images
          images.first(10).each do |image_file|
            if image_file.is_a?(ActionDispatch::Http::UploadedFile)
              unique_filename = "#{SecureRandom.uuid}_#{image_file.original_filename}"
              temp_path = Rails.root.join('tmp', unique_filename)

              FileUtils.mkdir_p(File.dirname(temp_path))

              File.open(temp_path, 'wb') do |file|
                file.write(image_file.read)
              end

              Spree::Image.create(:attachment => File.open(temp_path), :viewable => @product.master)

              File.delete(temp_path) if File.exist?(temp_path)
            end
          end
        end

        if params[:product_id].present?
          puts "EXITSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS====================================="
          existing_product = Spree::Product.find(params[:product_id])

          if params[:remove_images].present?
            # Convert remove_images to an array of integers for easy comparison
            remove_image_ids = params[:remove_images].map(&:to_i)
            puts "------------------remove_image_ids"
            puts remove_image_ids
          else
            remove_image_ids = []
          end

          existing_product.master.images.each do |image|
            # Step 3: Create a new Spree::Image instance for the new product's master
            unless remove_image_ids.include?(image.id)
              new_image = Spree::Image.new(viewable: @product.master)

              # Step 4: Associate the existing image blob with the new Spree::Image
              new_image.attachment.attach(image.attachment.blob)

              # Save the new image
              new_image.save!
            end
          end
        end
        # Add stock to the product's variant (master variant)

        stock_item = Spree::StockItem.find_or_create_by(variant: @product.master, stock_location: stock_location)
        stock_item.set_count_on_hand(quantity)

        redirect_to seller_listing_index_path
      else
        raise ActiveRecord::Rollback, "Error saving product"
      end
    end
  rescue => e
    puts "Error during transaction: #{e.message}"
    flash[:alert] = 'There was an error creating the product.'
    if params[:product_id].present?
      redirect_to seller_listing_index_path
    else
      redirect_to new_seller_listing_path
    end
  end

  def clone
    @product = Spree::Product.find(params[:product_id])

    user = spree_current_user
    shop = Shop.find_by(user_id: user.id)

    if @product.shop != shop
      redirect_to seller_listing_index_path, alert: 'You are not authorized to edit this product.'
      return
    end

    variant = Spree::Variant.find_by(product_id: @product.id)
    @price = Spree::Price.find_by(variant_id: variant.id)

    @PrimaryColorLabel = Spree::Property.find_by(name: "PrimaryColor")
    @SecondaryColorLabel = Spree::Property.find_by(name: "SecondaryColor")
    @GemTypeLabel = Spree::Property.find_by(name: "GemType")
    @CaratWeightLabel = Spree::Property.find_by(name: "CaratWeight")
    @DimensionLengthLabel = Spree::Property.find_by(name: "Length")
    @DimensionWidthLabel = Spree::Property.find_by(name: "Width")
    @DimensionHeightLabel = Spree::Property.find_by(name: "Height")
    @OriginProperty = Spree::Property.find_by(name: "Origin")
    @CustomOriginProperty = Spree::Property.find_by(name: "CustomOrigin")

    @MaterialProperty = Spree::Property.find_by(name: "Material")
    @JewelleryShapeProperty = Spree::Property.find_by(name: "JewelleryShape")
    @JewelleryTypeProperty = Spree::Property.find_by(name: "JewelleryType")
    @CelebrationProperty = Spree::Property.find_by(name: "Celebration")
    @RecipientProperty = Spree::Property.find_by(name: "Recipient")
    @ThemeProperty = Spree::Property.find_by(name: "Theme")
    @ShapeProperty = Spree::Property.find_by(name: "Shape")

    @PrimaryColorPropertyValue = PropertyValue.where(property_id: @PrimaryColorLabel.id)
    @SecondaryColorPropertyValue = PropertyValue.where(property_id: @SecondaryColorLabel.id)
    @GemTypePropertyValue = PropertyValue.where(property_id: @GemTypeLabel.id)
    @MaterialPropertyValue = PropertyValue.where(property_id: @MaterialProperty.id)
    @JewelleryShapePropertyValue = PropertyValue.where(property_id: @JewelleryShapeProperty.id)
    @JewelleryTypePropertyValue = PropertyValue.where(property_id: @JewelleryTypeProperty.id)
    @CelebrationPropertyValue = PropertyValue.where(property_id: @CelebrationProperty.id)
    @RecipientPropertyValue = PropertyValue.where(property_id: @RecipientProperty.id)
    @ThemePropertyValue = PropertyValue.where(property_id: @ThemeProperty.id)
    @OriginPropertyValue = PropertyValue.where(property_id: @OriginProperty.id)
    @ShapePropertyValue = PropertyValue.where(property_id: @ShapeProperty.id)

    puts "=====================ShapePropertyValue"
    puts @ShapePropertyValue.inspect

    @CaratWeightPropertyValue = @product.product_properties.where(property_id: @CaratWeightLabel.id)
    @DimensionLengthPropertyValue = @product.product_properties.where(property_id: @DimensionLengthLabel.id)
    @DimensionWidthPropertyValue = @product.product_properties.where(property_id: @DimensionWidthLabel.id)
    @DimensionHeightPropertyValue = @product.product_properties.where(property_id: @DimensionHeightLabel.id)
    @primary_color = @product.product_properties.where(property_id: @PrimaryColorLabel.id);
    @secondary_color = @product.product_properties.where(property_id: @SecondaryColorLabel.id);
    @gem_type = @product.product_properties.where(property_id: @GemTypeLabel.id);
    @material = @product.product_properties.where(property_id: @MaterialProperty.id);
    @jewellery_shape = @product.product_properties.where(property_id: @JewelleryShapeProperty.id);
    @jewellery_type = @product.product_properties.where(property_id: @JewelleryTypeProperty.id);
    @celebration = @product.product_properties.where(property_id: @CelebrationProperty.id);
    @recipient = @product.product_properties.where(property_id: @RecipientProperty.id);
    @theme = @product.product_properties.where(property_id: @ThemeProperty.id);
    @shape = @product.product_properties.where(product_id: @product.id, property_id: @ShapeProperty.id);

    puts "===============================@shape============="
    puts @shape.inspect

    @quantity = get_stock_quantity(@product)
    @Taxon = Spree::Taxon.where.not(name: "Category")
    @origin = @product.product_properties.where(property_id: @OriginProperty.id)
    @custom_origin = @product.product_properties.where(property_id: @CustomOriginProperty.id)
  end

  def edit
    @product = Spree::Product.find(params[:id])

    user = spree_current_user
    shop = Shop.find_by(user_id: user.id)

    if @product.shop != shop
      redirect_to seller_listing_index_path, alert: 'You are not authorized to edit this product.'
      return
    end

    variant = Spree::Variant.find_by(product_id: @product.id)
    @price = Spree::Price.find_by(variant_id: variant.id)

    @PrimaryColorLabel = Spree::Property.find_by(name: "PrimaryColor")
    @SecondaryColorLabel = Spree::Property.find_by(name: "SecondaryColor")
    @GemTypeLabel = Spree::Property.find_by(name: "GemType")
    @CaratWeightLabel = Spree::Property.find_by(name: "CaratWeight")
    @DimensionLengthLabel = Spree::Property.find_by(name: "Length")
    @DimensionWidthLabel = Spree::Property.find_by(name: "Width")
    @DimensionHeightLabel = Spree::Property.find_by(name: "Height")
    @OriginProperty = Spree::Property.find_by(name: "Origin")
    @CustomOriginProperty = Spree::Property.find_by(name: "CustomOrigin")

    @MaterialProperty = Spree::Property.find_by(name: "Material")
    @JewelleryShapeProperty = Spree::Property.find_by(name: "JewelleryShape")
    @JewelleryTypeProperty = Spree::Property.find_by(name: "JewelleryType")
    @CelebrationProperty = Spree::Property.find_by(name: "Celebration")
    @RecipientProperty = Spree::Property.find_by(name: "Recipient")
    @ThemeProperty = Spree::Property.find_by(name: "Theme")
    @ShapeProperty = Spree::Property.find_by(name: "Shape")

    @PrimaryColorPropertyValue = PropertyValue.where(property_id: @PrimaryColorLabel.id)
    @SecondaryColorPropertyValue = PropertyValue.where(property_id: @SecondaryColorLabel.id)
    @GemTypePropertyValue = PropertyValue.where(property_id: @GemTypeLabel.id)
    @MaterialPropertyValue = PropertyValue.where(property_id: @MaterialProperty.id)
    @JewelleryShapePropertyValue = PropertyValue.where(property_id: @JewelleryShapeProperty.id)
    @JewelleryTypePropertyValue = PropertyValue.where(property_id: @JewelleryTypeProperty.id)
    @CelebrationPropertyValue = PropertyValue.where(property_id: @CelebrationProperty.id)
    @RecipientPropertyValue = PropertyValue.where(property_id: @RecipientProperty.id)
    @ThemePropertyValue = PropertyValue.where(property_id: @ThemeProperty.id)
    @OriginPropertyValue = PropertyValue.where(property_id: @OriginProperty.id)
    @ShapePropertyValue = PropertyValue.where(property_id: @ShapeProperty.id)

    puts "=====================ShapePropertyValue"
    puts @ShapePropertyValue.inspect

    @CaratWeightPropertyValue = @product.product_properties.where(property_id: @CaratWeightLabel.id)
    @DimensionLengthPropertyValue = @product.product_properties.where(property_id: @DimensionLengthLabel.id)
    @DimensionWidthPropertyValue = @product.product_properties.where(property_id: @DimensionWidthLabel.id)
    @DimensionHeightPropertyValue = @product.product_properties.where(property_id: @DimensionHeightLabel.id)
    @primary_color = @product.product_properties.where(property_id: @PrimaryColorLabel.id);
    @secondary_color = @product.product_properties.where(property_id: @SecondaryColorLabel.id);
    @gem_type = @product.product_properties.where(property_id: @GemTypeLabel.id);
    @material = @product.product_properties.where(property_id: @MaterialProperty.id);
    @jewellery_shape = @product.product_properties.where(property_id: @JewelleryShapeProperty.id);
    @jewellery_type = @product.product_properties.where(property_id: @JewelleryTypeProperty.id);
    @celebration = @product.product_properties.where(property_id: @CelebrationProperty.id);
    @recipient = @product.product_properties.where(property_id: @RecipientProperty.id);
    @theme = @product.product_properties.where(property_id: @ThemeProperty.id);
    @shape = @product.product_properties.where(product_id: @product.id, property_id: @ShapeProperty.id);

    puts "===============================@shape============="
    puts @shape.inspect

    @quantity = get_stock_quantity(@product)
    @Taxon = Spree::Taxon.all
    @origin = @product.product_properties.where(property_id: @OriginProperty.id)
    @custom_origin = @product.product_properties.where(property_id: @CustomOriginProperty.id)
  end

  def update
    @product = Spree::Product.find(params[:product_id])

    stock_location = Spree::StockLocation.find_by(shop_id: @product.shop_id)

    if stock_location.nil?
      raise ActiveRecord::RecordNotFound, "Stock Location is not found for #{@shop.name}."
    end

    if params[:remove_video] == "true"
      @product.video.purge
    end

    if params[:remove_certificate] == "true"
      @product.certificate.purge
    end

    if @product.update(product_params)

      if product_info_params[:taxon].present?
        existing_product_taxon = Spree::ProductsTaxon.find_by(product_id: @product.id)

        if existing_product_taxon.present?
          existing_product_taxon.update(taxon_id: product_info_params[:taxon])
        end
      end

      additional_params = {
        status: product_info_params[:status],
      }

      # Check if there are any additional parameters to update
      if additional_params.present?
        @product.update(additional_params)
      end

      if product_info_params[:quantity].present?
        stock_item = Spree::StockItem.find_by(variant: @product.master, stock_location: stock_location)

        if stock_item
          stock_item.set_count_on_hand(product_info_params[:quantity])
        end
      end

      if property_params[:primary_color].present?
        primaryProperty = getSpreeProperty(property_params[:primary_color])
        update_product_properties(primaryProperty[:property_value].name, @product.id, primaryProperty[:property].id)
      end

      if property_params[:carat_weight].present?
        property = findPropertyIdByName('CaratWeight')
        update_product_properties(property_params[:carat_weight], @product.id, property.id)
      end

      if property_params[:secondary_color] && !property_params[:secondary_color].empty?
        secondaryProperty = getSpreeProperty(property_params[:secondary_color])
        update_product_properties(secondaryProperty[:property_value].name, @product.id, secondaryProperty[:property].id)
      end

      if property_params[:gem_type] && !property_params[:gem_type].empty?
        gemTypeProperty = getSpreeProperty(property_params[:gem_type])
        update_product_properties(gemTypeProperty[:property_value].name, @product.id, gemTypeProperty[:property].id)
      end

      if property_params[:height] && !property_params[:height].empty?
        property = findPropertyIdByName('Height')
        update_product_properties(property_params[:height], @product.id, property.id)
      end
      if property_params[:width] && !property_params[:width].empty?
        property = findPropertyIdByName('Width')
        update_product_properties(property_params[:width], @product.id, property.id)
      end
      if property_params[:length] && !property_params[:length].empty?
        property = findPropertyIdByName('Length')
        update_product_properties(property_params[:length], @product.id, property.id)
      end

      if property_params[:origin] && !property_params[:origin].empty?
        origin_property = getSpreeProperty(property_params[:origin])
        puts origin_property.inspect
        update_product_properties(origin_property[:property_value].name, @product.id, origin_property[:property].id)

        custom_origin_property = findPropertyIdByName('CustomOrigin')

        if origin_property[:property_value].name == 'Others'
          update_product_properties(property_params[:custom_origin], @product.id, custom_origin_property.id)
        else
          custom_origin = Spree::ProductProperty.where(
            product_id: @product.id,
            property_id: custom_origin_property.id
          ).first
          custom_origin&.destroy
        end

      end

      if property_params[:material] && !property_params[:material].empty?
        materialProperty = getSpreeProperty(property_params[:material])
        update_product_properties(materialProperty[:property_value].name, @product.id, materialProperty[:property].id)
      end

      if property_params[:jewellery_shape] && !property_params[:jewellery_shape].empty?
        jewelleryShapeProperty = getSpreeProperty(property_params[:jewellery_shape])
        update_product_properties(jewelleryShapeProperty[:property_value].name, @product.id,
                                  jewelleryShapeProperty[:property].id)
      end

      if property_params[:jewellery_type] && !property_params[:jewellery_type].empty?
        jewelleryTypeProperty = getSpreeProperty(property_params[:jewellery_type])
        update_product_properties(jewelleryTypeProperty[:property_value].name, @product.id,
                                  jewelleryTypeProperty[:property].id)
      end

      if property_params[:celebration] && !property_params[:celebration].empty?
        celebrationProperty = getSpreeProperty(property_params[:celebration])
        update_product_properties(celebrationProperty[:property_value].name, @product.id,
                                  celebrationProperty[:property].id)
      end

      if property_params[:recipient] && !property_params[:recipient].empty?
        recipientProperty = getSpreeProperty(property_params[:recipient])
        update_product_properties(recipientProperty[:property_value].name, @product.id, recipientProperty[:property].id)
      end

      if property_params[:theme] && !property_params[:theme].empty?
        themeProperty = getSpreeProperty(property_params[:theme])
        update_product_properties(themeProperty[:property_value].name, @product.id, themeProperty[:property].id)
      end

      if property_params[:shape] && !property_params[:shape].empty?
        shapeProperty = getSpreeProperty(property_params[:shape])
        update_product_properties(shapeProperty[:property_value].name, @product.id, shapeProperty[:property].id)
      end

      handle_images(@product, params)
      redirect_to seller_listing_index_path, notice: 'Product updated successfully.'
    else
      redirect_to seller_listing_index_path, alert: 'Something went wrong, please try again.'
    end
  end

  def destroy
    @product = Spree::Product.find(params[:id])
    puts '-----products----------------------'

    puts @product

    if @product.update_column(:deleted_at, Time.current)
      flash[:notice] = 'Product was successfully deleted.'
      redirect_to seller_listing_index_path
    else
      puts @product.errors.full_messages.join(", ")
      flash[:alert] = 'There was an error deleting the product.'
      redirect_to seller_listing_index_path
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :certificate, :video)
  end

  def product_image_params
    params.require(:product).permit(images: [])
  end

  def product_info_params
    params.require(:product).permit(:price, :quantity, :status, :taxon)
  end

  def property_params
    params.require(:product).permit(:primary_color, :secondary_color, :gem_type, :carat_weight, :height, :width,
                                    :length, :material, :jewellery_shape, :jewellery_type, :celebration, :recipient,
                                    :theme, :origin, :custom_origin, :shape)
  end

  def update_product_properties(propertyName, productId, propertyId)
    @ProductProperties = Spree::ProductProperty.update(value: propertyName,
                                                       product_id: productId,
                                                       property_id: propertyId)
  end

  def get_stock_quantity(product)
    stock_location = Spree::StockLocation.find_by(shop_id: product.shop_id)
    stock_item = Spree::StockItem.find_by(variant: product.master, stock_location: stock_location)
    stock_item ? stock_item.count_on_hand : 0
  end

  def handle_images(product, params)
    # Remove images marked for deletion
    if params[:remove_images].present?
      params[:remove_images].each do |image_id|
        image = Spree::Image.find(image_id)
        image.destroy if image.present?
      end
    end

    # Add new images
    images = params[:product][:images]

    if images
      images.first(10).each do |image_file|
        if image_file.is_a?(ActionDispatch::Http::UploadedFile)
          unique_filename = "#{SecureRandom.uuid}_#{image_file.original_filename}"
          temp_path = Rails.root.join('tmp', unique_filename)

          FileUtils.mkdir_p(File.dirname(temp_path))

          File.open(temp_path, 'wb') do |file|
            file.write(image_file.read)
          end

          # Create Spree::Image and attach it to the product master
          Spree::Image.create(attachment: File.open(temp_path), viewable: product.master)

          File.delete(temp_path) if File.exist?(temp_path)
        end
      end
    end
  end
end
