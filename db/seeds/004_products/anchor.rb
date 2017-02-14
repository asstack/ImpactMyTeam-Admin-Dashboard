product = Product.find_or_create_by_name!(
  name: 'Anchor',
  summary: %Q{The Anchor table is the stable base for the training room. Size, adjustability, and supply storage options create flexible solutions for cross sport training. The Anchor's robust construction allows it to withstand any abuse you throw at it. Be equipped with the Anchor, the heart of the training facility.},
  description: %Q{
    # Load rating

    - 500 lb capacity

    # Aluminum and steel construction

    - Incredibly strong
    - Will not rust
    - Will not rot or absorb moisture like wood
    - Durable powder-coated finish

    # Durable work surface

    - Will not tear like vinyl
    - Will not soak up fluid like foam

    # Storage

    - Available storage drawers
    - Integrated tape shelf
  }
)

product.variants.find_or_create_by_item_code!(
  item_code: 'anchor',
  default: true,
  product_color_ids: ProductColor.pluck(:id),
  configuration: 'No Storage',
  configuration_notes: '',
  price: 1295.00,
  custom_graphic_price: 269.00
)

product.variants.find_or_create_by_item_code!(
  item_code: 'anchor-storage',
  default: false,
  product_color_ids: ProductColor.pluck(:id),
  configuration: 'Storage Drawers',
  configuration_notes: '',
  price: 1664.00,
  custom_graphic_price: 269.00
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
