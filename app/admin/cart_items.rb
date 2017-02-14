ActiveAdmin.register CartItem do
  belongs_to :campaign

  index do
    selectable_column
    id_column
    column(:image) { |item| auto_link(item, image_tag(item.image.thumb)) if item.image? }
    row(:custom_graphic) { |item| link_to('Download', item.custom_graphic.url) if item.custom_graphic? }
    column(:name)
    column(:quantity)
    column(:subtotal, sortable: :subtotal) { |item| number_to_currency(item.subtotal) }
    column(:created_at)
    column(:updated_at)
    default_actions
  end

  show do |cart_item|
    attributes_table do
      row(:image) { image_tag(cart_item.image) }
      rows :id, :campaign, :product_variant, :product_color
      row(:custom_graphic) { link_to('Download Custom Graphic Image', cart_item.custom_graphic.url) }
      row(:subtotal) { number_to_currency(cart_item.subtotal) }
      rows :quantity, :created_at, :updated_at
    end

    active_admin_comments
  end

  form do |f|
    f.inputs "Details" do
      f.input :product_variant, input_html: { disabled: true }
      unless f.object.color_options.empty?
        f.input :product_color, collection: f.object.color_options.collect(&:product_color)
      end
      f.input :subtotal, input_html: { min: 0.00, step: 0.01 }
      f.input :quantity, input_html: { min: 0, step: 1 }
    end

    f.inputs "Custom Graphic/Logo" do

      f.input :remove_custom_graphic, as: :boolean if f.object.custom_graphic?
      f.input :custom_graphic, hint: f.object.custom_graphic? ? f.template.link_to('Download Custom Graphic Image', f.object.custom_graphic.url) : 'Custom graphic or logo to be printed on the product.'
      f.input :custom_graphic_cache, as: :hidden
    end

    f.inputs "Custom Product Image" do
      f.input :remove_custom_product_image, as: :boolean if f.object.custom_product_image?
      f.input :custom_product_image, hint: f.object.custom_product_image.blank? ? 'Upload a custom image if there is a custom color or graphic for this product.' : f.template.image_tag(f.object.custom_product_image.figure)
      f.input :custom_product_image_cache, as: :hidden
    end

    f.actions
  end
end
