ActiveAdmin.register Product do
  menu priority: 6

  index do
    selectable_column
    id_column
    column(:name, sortable: :name) { |p| auto_link p }
    column(:accessory) { |p| p.primaries.blank? ? "No" : "Yes" }
    column(:show_in_catalog)
    column(:variants) { |p| link_to "View #{p.variants.size}", admin_product_variants_path(p) }
    column :created_at
    column :updated_at

    default_actions
  end

  show do |product|
    attributes_table do
      rows :id, :name, :summary, :description, :show_in_catalog
      rows :created_at, :updated_at
    end

    panel "Variants" do
      div class: 'right small' do
        span link_to('Add Variant', [:new, :admin, product, :variant], class: 'button')
      end

      table_for product.variants do
        column :configuration
        column :item_code
        column :default
        column(:price) { |v| number_to_currency(v.price) }
        column(:custom_graphic_price) { |v| number_to_currency(v.custom_graphic_price) }
        column(:colors) do |v|
          v.color_options.each do |co|
            span '', class: 'color-swatch', style: "background-color: ##{co.product_color.hex};"
          end
        end
        column(:actions) do |v|
          span link_to('View', admin_product_variant_path(product, v))
          span link_to('Edit', edit_admin_product_variant_path(product, v))
        end
      end
    end

    active_admin_comments
  end
end
