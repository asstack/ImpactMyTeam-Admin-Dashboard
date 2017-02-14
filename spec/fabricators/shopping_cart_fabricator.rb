Fabricator(:shopping_cart) do
  campaign nil
  subtotal 0.00
  fees     0.00
  taxes    0.00
  notes    { Faker::Lorem.sentences(rand(3)) }
end
