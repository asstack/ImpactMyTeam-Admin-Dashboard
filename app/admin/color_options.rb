ActiveAdmin.register ColorOption do
  menu false

  # This form is only used for changing/uploading a product photo
  # or color price
  form do |f|
    f.inputs "Image for #{f.object.product_color.name} #{f.object.product_variant.product.name} - #{f.object.product_variant.configuration}" do
      f.input :remove_image, as: :boolean if f.object.image?
      f.input :image, hint: f.object.image.blank? ? 'No Image.' : f.template.image_tag(f.object.image.figure)
      f.input :image_cache, as: :hidden
    end
    f.actions
  end
end
