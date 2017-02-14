Fabricator(:school_address, aliases: [:address]) do
  school       nil
  phone_number { Faker::PhoneNumber.phone_number }
  line_1       { Faker::Address.street_address }
  line_2       nil
  city         { Faker::Address.city }
  region       { Faker::Address.state }
  postal_code  { Faker::Address.zip_code }
  country      { Faker::Address.country }
  address_type { SchoolAddress.address_types.sample }
end
