Fabricator(:school) do
  name          { Faker::Company.name }
  school_type   { School.school_types.sample }
  school_level  { School.school_levels.sample }
  city          { Faker::Address.city }
  region        { Faker::Address.state }
  website_url   { Faker::Internet.url }
  athletics_url { Faker::Internet.url }
end

Fabricator(:school_full, from: :school) do
  addresses(count: 1) { Fabricate(:school_address, address_type: 'Default') }
  contacts(count: 1)
  teams(count: 1) do |attrs, i|
    Fabricate(:team, school_contact: attrs[:contacts].sample)
  end
end
