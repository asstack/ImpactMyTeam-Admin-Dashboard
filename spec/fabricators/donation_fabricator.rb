Fabricator(:donation) do
  campaign        nil
  # ip_address      { Faker::Internet.ip_v6_address }
  first_name      { Faker::Name.first_name }
  last_name       { Faker::Name.last_name }
  card_brand       { 'visa' }
  card_expires_on { Date.today + 1.year }
  card_number     { '4242424242424242' }
  card_verification { '123' }
  amount_authorized { rand(100) + rand(99)/100.00 }

  email { Faker::Internet.email }
  phone { Faker::PhoneNumber.phone_number }

  billing_address1  { Faker::Address.street_address }
  billing_city      { Faker::Address.city }
  billing_state     { Faker::Address.state }
  billing_zip       { Faker::Address.zip_code }
  billing_country   { Faker::Address.country }
end
