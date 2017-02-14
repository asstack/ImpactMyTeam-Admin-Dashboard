product = Product.find_or_create_by_name!(
  name: 'Medic XL',
  summary: %Q{With onboard storage and all-terrain wheels, the MEDIC XL quickly and easily brings your workstation to the sideline. Heavy duty construction ensures the MEDIC XL will stand up to the most demanding environments. Get off the dirt, away from the bench, and out of the locker room. The MEDIC XL is on field Athletic Training equipment to keep you in the game. At home or on the road, intimidate the competition when you come prepared with the MEDIC XL.},
  description: %Q{
    # Load rating

    - 750 lb capacity

    # Aluminum construction

    - Lightweight yet incredibly strong
    - Weight = 80 lbs
    - Will not rust
    - Will not rot or absorb moisture like wood
    - Durable powder-coated finish
    - Can be power-washed

    # Durable work surface

    - Will not tear like vinyl
    - Will not soak up fluid like foam

    # Large field feet

    - Will not sink into turf
    - Safe for indoor and outdoor use

    # Mobility

    - Table folds up & wheels fold out
    - Small footprint makes it easy to store

    # Storage

    - Secure locking cabinet
    - Access from both sides
    - Two bungee cords included
    - Attach supplies for transportation
  }
)

product.variants.find_or_create_by_item_code!(
  item_code: 'medic-xl',
  default: true,
  product_color_ids: ProductColor.pluck(:id),
  configuration: 'Medic XL',
  configuration_notes: '',
  price: 1975.00,
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

bag = Product.find_or_create_by_name!(
  name: 'Medic XL Cover',
  summary: %Q{The Medic XL travel and storage cover will keep you Medic looking good for game.},
  description: ''
)

bag.variants.find_or_create_by_item_code!(
  item_code: 'medic-xl-bag',
  default: true,
  product_color_ids: nil,
  configuration: 'Medic XL Cover',
  configuration_notes: '',
  price: 100.00,
  custom_graphic_price: nil,
  image: (File.open(Rails.root.join('db', 'seeds', '004_products', 'images', "impact-athletic-product-medic-xl-case.png")) rescue nil)
)

product.variants.each { |v| v.accessories << bag }

puts "added #{bag.name} with #{bag.variants.size} variants"
