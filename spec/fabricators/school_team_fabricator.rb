Fabricator(:school_team, aliases: [:team]) do
  school              nil
  school_contact      nil
  athletic_conference { Fabricate(:conference) }
  name                { Faker::Company.name }
  sport               { %w(Football Soccer Baseball Basketball).sample }
  mascot              { Faker::Name.first_name }
  colors              { 'red, blue, orange' }
  website_url         { Faker::Internet.url }
end
