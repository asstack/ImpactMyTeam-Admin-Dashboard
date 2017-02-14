ActiveAdmin.register SchoolContact do
  menu title: 'Contacts', parent: 'Schools'

  filter :school_name, as: :string
  filter :contact_type, as: :select, collection: SchoolContact.contact_types
  filter :first_name
  filter :last_name
  filter :phone_number
  filter :email
  filter :updated_at

  index do
    selectable_column

    id_column
    column(:contact_type)
    column(:first_name)
    column(:last_name)
    column(:phone_number)
    column(:email) { |c| mail_to(c.email, c.name) }
    column(:school)
    column(:created_at)
    column(:updated_at)

    default_actions
  end
end
