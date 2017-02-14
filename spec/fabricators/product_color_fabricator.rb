Fabricator(:product_color) do
  name { Faker::Name.last_name + %w(Red Blue Green Yellow Purple Orange).sample }
  hex  { rand(0xffffff).to_s(16) }
end
