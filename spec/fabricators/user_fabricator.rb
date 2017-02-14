Fabricator(:user) do
  first_name  { Faker::Name.first_name }
  last_name   { Faker::Name.last_name }
  email       { Faker::Internet.email }
  phone_number { Faker::PhoneNumber.phone_number }
  password    'changeme'
  password_confirmation 'changeme'
  # required if the Devise Confirmable module is used
  # confirmed_at Time.now
end

Fabricator(:admin_user, from: :user) do
  after_create do |user|
    user.add_role :admin
  end
end
