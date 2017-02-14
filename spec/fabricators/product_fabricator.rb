Fabricator(:product) do
  name        { Faker::Company.bs }
  summary     { Faker::Lorem.paragraph }
  description { Faker::Lorem.paragraph }
end
