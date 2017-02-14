ActiveAdmin.register ProductVariant, as: 'Variant' do
  belongs_to :product

  index do
    selectable_column

    column :id, sortable: :id do |v|
      link_to v.id, admin_product_variant_path(v.product, v)
    end

    column :image do |v|
      link_to image_tag(v.image.thumb), admin_product_variant_path(v.product, v)
    end

    column :configuration, sortable: :configuration do |v|
      link_to v.configuration, admin_product_variant_path(v.product, v)
    end

    column :item_code

    column :price, sortable: :price do |v|
      number_to_currency(v.price)
    end

    column 'Logo Price', sortable: :custom_graphic_price do |v|
      number_to_currency(v.custom_graphic_price)
    end

    column :default, sortable: :default do |v|
      v.default? ? "Yes" : "No"
    end

    column :created_at
    column :updated_at

    default_actions
  end

  form do |f|
    f.inputs "Image" do
      f.input :remove_image, as: :boolean if f.object.image?
      f.input :image, hint: f.object.image.blank? ? 'No Image.' : f.template.image_tag(f.object.image)
      f.input :image_cache, as: :hidden
    end

    f.inputs "#{f.object.product.name} Variant Details" do
      f.input :item_code, hint: 'Catalog Number'
      f.input :configuration, hint: %|Details that make this unique, i.e. 'Tub Width 30", Seat Height 24"'|
      f.input :configuration_notes, hint: 'Details that differ from the primary product description.'
      f.input :price, input_html: { min: 0.00, step: 0.01 }
      f.input :custom_graphic_price, input_html: { min: 0.00, step: 0.01 }
      f.input :default, hint: 'Check if this should be the display model for this product type.'
    end

    f.inputs "Product Colors" do
      f.input :product_colors,  as: :check_boxes,
                                collection: ProductColor.all,
                                label: 'Available Colors',
                                member_label: proc { |c| (content_tag(:span, '', class: 'color-swatch', style: "background-color: ##{c.hex};") + c.name).html_safe }
    end

    f.inputs "Accessory Options" do
      f.has_many :accessory_options, allow_destroy: true, heading: false do |ao|
        ao.input :accessory,
                  hint: 'Product whose variants can be added'
        ao.input :exclusive,
                  hint: 'Check if only one of the variants can be chosen.'
      end
    end

    f.actions
  end

  show do |variant|
    attributes_table do
      row(:image) { |v| image_tag(v.image) }
      rows :id, :product, :configuration, :configuration_notes, :item_code, :price
      rows :custom_graphic_price, :default, :created_at, :updated_at
    end

    panel "Available Colors" do
      table_for variant.color_options do
        column(:color) do |co|
          span '', class: 'color-swatch', style: "background-color: ##{co.product_color.hex};"
        end
        column(:image) { |co| image_tag(co.image.thumb) }
        column(:name) { |co| span co.product_color.name }
        column :actions do |co|
          span link_to('Update Image', edit_admin_color_option_path(co))
          # span link_to('Delete', admin_color_option, method: :delete)
        end
      end
    end

    panel "Accessories" do
      table_for variant.accessory_options do
        column "Product" do |op|
          link_to op.accessory.name, admin_product_path(op.accessory)
        end

        column "Options" do |op|
          ul do
            op.accessory.variants.each do |v|
              li link_to("#{v.configuration} - #{number_to_currency(v.price)}", admin_product_variant_path(v.product, v))
            end
          end
        end
        column :exclusive
      end
    end

    active_admin_comments
  end
end
