product = Product.find_or_create_by_name!(
  name: 'Dock',
  summary: %Q{Harsh wet environments do not scare the Dock Whirlpool Table. The aluminum frame and stainless steel fasteners will never rust or decay from moisture. The table top and seats are fabricated from plastic designed specifically for the marine industry. The Dock truly lives up to it's name.},
  description: %Q{
    # Whirlpool Compatibility

    - 20″ and 24″ width available
    - 31″ and 34″ height available

    # Aluminum and steel construction

    - Incredibly strong
    - Will not rust
    - Will not rot or absorb moisture like wood
    - Durable powder-coated finish
    - Integrated step

    # Durable work surface

    - Will not tear like vinyl
    - Will not soak up fluid like foam or wood

    # Storage

    - Integrated towel shelf
  }
)

[20, 24].each do |tub_width|
  price = (tub_width == 20) ? 1595.00 : 1794.00
  [31, 34].each do |seat_height|
    product.variants.find_or_create_by_configuration!(
      item_code: "dock-#{tub_width}T-#{seat_height}S",
      default: (tub_width == 20 && seat_height == 31),
      product_color_ids: ProductColor.pluck(:id),
      configuration: %|Tub Width #{tub_width}", Seat Height #{seat_height}"|,
      configuration_notes: '',
      price: price,
      custom_graphic_price: nil
    )
  end
end

product.variants.each do |variant|
  variant.color_options.each do |color_option|
    image = File.open(Rails.root.join('db', 'seeds', '004_products', 'images', "impact-athletic-product-dock-#{color_option.product_color.name.parameterize}.png")) rescue nil
    if image
      puts "uploading #{File.basename(image)}"
      color_option.update_attributes(image: image)

      variant.update_attributes(image: image) if color_option.name == "Impact Red"
    end
  end
end

puts "added #{product.name} with #{product.variants.size} variants"
