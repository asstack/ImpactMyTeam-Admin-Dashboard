# Storage options available for all anchor 2x products

storage = Product.find_or_create_by_name!(
  name: 'Anchor 2X Storage',
  summary: '',
  show_in_catalog: false,
  description: '*Storage drawer option terminates the ability to connect additional units together.'
)

storage.variants.find_or_create_by_item_code!(
  item_code: 'anchor-2x-storage-drawer-left',
  default: false,
  product_color_ids: nil,
  configuration: 'Left Storage Drawer',
  configuration_notes: '',
  price: 240.00,
  custom_graphic_price: nil
)

storage.variants.find_or_create_by_item_code!(
  item_code: 'anchor-2x-storage-drawer-right',
  default: false,
  product_color_ids: nil,
  configuration: 'Right Storage Drawer',
  configuration_notes: '',
  price: 240.00,
  custom_graphic_price: nil
)

storage.variants.each do |variant|
  image = File.open(Rails.root.join('db', 'seeds', '004_products', 'images', "impact-athletic-product-#{variant.item_code}.png")) rescue nil
  if image
    puts "uploading #{image.path}"
    variant.update_attributes(image: image)
  end
end

product = Product.find_or_create_by_name!(
  name: 'Anchor 2X',
  summary: %Q{The Anchor 2X is the stable base for the training room. Size, adjustability, and supply storage options create flexible solutions for cross sport training. The Anchor 2X's robust construction allows it to withstand any abuse you throw at it. Be equipped with the Anchor 2X, the heart of the training facility.},
  description: %Q{
    # Load rating

    - 500 lb capacity per table

    # Aluminum and steel construction

    - Incredibly strong
    - Will not rust
    - Will not rot or absorb moisture like wood
    - Durable powder-coated finish

    # Durable work surface

    - Will not tear like vinyl
    - Will not soak up fluid like foam

    # Storage

    - Available end drawers
    - Integrated tape shelf
  }
)

multi_storage = []
single_storage = []

multi_storage << product.variants.find_or_create_by_item_code!(
  item_code: 'anchor-2x-L42R36',
  default: true,
  product_color_ids: ProductColor.pluck(:id),
  configuration: %|42" left x 36" right|,
  configuration_notes: '',
  price: 1945.00,
  custom_graphic_price: 269.00
)

multi_storage << product.variants.find_or_create_by_item_code!(
  item_code: 'anchor-2x-L36R42',
  default: false,
  product_color_ids: ProductColor.pluck(:id),
  configuration: %|36" left x 42" right|,
  configuration_notes: '',
  price: 1945.00,
  custom_graphic_price: 269.00
) # NOTE: Has two accessory products: right drawer, left drawer

multi_storage << product.variants.find_or_create_by_item_code!(
  item_code: 'anchor-2x-L42R42',
  default: false,
  product_color_ids: ProductColor.pluck(:id),
  configuration: %|42" left x 42" right|,
  configuration_notes: '',
  price: 1995.00,
  custom_graphic_price: 269.00
) # NOTE: Has two accessory products: right drawer, left drawer

multi_storage << product.variants.find_or_create_by_item_code!(
  item_code: 'anchor-2x-L36R36',
  default: false,
  product_color_ids: ProductColor.pluck(:id),
  configuration: %|36" left x 36" right|,
  configuration_notes: '',
  price: 1895.00,
  custom_graphic_price: 269.00
) # NOTE: Has two accessory products: right drawer, left drawer

single_storage << product.variants.find_or_create_by_item_code!(
  item_code: 'anchor-2x-36',
  default: false,
  product_color_ids: ProductColor.pluck(:id),
  configuration: %|36" table|,
  configuration_notes: '',
  price: 895.00,
  custom_graphic_price: 169.00
) # NOTE: Has two accessory products: right drawer, left drawer

single_storage << product.variants.find_or_create_by_item_code!(
  item_code: 'anchor-2x-42',
  default: false,
  product_color_ids: ProductColor.pluck(:id),
  configuration: %|42" table|,
  configuration_notes: '',
  price: 995.00,
  custom_graphic_price: 169.00
) # NOTE: Has two accessory products: right drawer, left drawer

product.variants.find_or_create_by_item_code!(
  item_code: 'anchor-custom',
  default: false,
  product_color_ids: ProductColor.pluck(:id),
  configuration: "Custom",
  configuration_notes: 'We can custom configure your Anchor 2X to your specific training room. Contact us for more information and pricing.',
  price: 0.00,
  custom_graphic_price: nil
)

multi_storage.each { |v| v.accessories << storage }

single_storage.each do |v|
  v.accessory_options.find_or_create_by_accessory_id!(
    accessory_id: storage.id,
    exclusive: true
  )
end

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
