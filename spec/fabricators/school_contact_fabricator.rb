Fabricator(:school_contact, aliases: [:contact]) do
  school       nil
  contact_type { SchoolContact.contact_types.sample }
  first_name   { Faker::Name.first_name }
  last_name    { Faker::Name.last_name }
  phone_number { Faker::PhoneNumber.phone_number }
  email        { Faker::Internet.email }
end
