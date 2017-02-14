Fabricator(:donation_transaction) do
  donation      nil
  action        'authorize'
  amount        1
  success       false
  authorization "MyString"
  message       "MyString"
  params        {}
end
