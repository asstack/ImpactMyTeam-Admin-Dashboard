Fabricator(:product_variant) do
  product              nil
  configuration        { Faker::Company.bs }
  item_code            { SecureRandom.uuid }
  price                0.00
  custom_graphic_price 0.00
end
