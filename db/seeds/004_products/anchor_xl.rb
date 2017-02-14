product = Product.find_or_create_by_name!(
  name: 'Anchor XL',
  summary: %Q{The Anchor XL table is the stable base for the training room. Size, adjustability, and supply storage options create flexible solutions for cross sport training. The Anchor XL's robust construction allows it to withstand any abuse you throw at it. Be equipped with the Anchor XL, the heart of the training facility.},
  description: %Q{
    # Load rating

    - 750 lb capacity

    # Aluminum and steel construction

    - Incredibly strong
    - Will not rust
    - Will not rot or absorb moisture like wood
    - Durable powder-coated finish

    # Durable work surface

    - Soft vinyl work surface
    - Will not soak up fluid like foam
    - Cleans up easily

    # Storage

    - Available storage drawers
    - Integrated tape shelf
  }
)

product.variants.find_or_create_by_item_code!(
  item_code: 'anchor-xl',
  default: true,
  product_color_ids: ProductColor.pluck(:id),
  configuration: 'No Storage',
  configuration_notes: '',
  price: 1895.00,
  custom_graphic_price: nil
)

product.variants.find_or_create_by_item_code!(
  item_code: 'anchor-xl-storage',
  default: false,
  product_color_ids: ProductColor.pluck(:id),
  configuration: 'Storage Drawers',
  configuration_notes: '',
  price: 2264.00,
  custom_graphic_price: nil
)

product.variants.each do |variant|
  variant.color_options.each do |color_option|
    image = File.open(Rails.root.join('db', 'seeds', '004_products', 'images', "impact-athletic-product-#{variant.item_code}-#{color_option.product_color.name.parameterize}.png")) rescue nil
    if image
      puts "uploading #{File.basename(image)}"
      color_option.update_attributes(image: image)

      variant.update_attributes(image: image) if color_option.name == "Impact Red"
    end
  end
end

puts "added #{product.name} with #{product.variants.size} variants"
