ActiveAdmin.register School do

  controller do
    def new
      new! do |format|
        @school.addresses.build
        @school.contacts.build
      end
    end
  end

  collection_action :upload_csv do
  end

  collection_action :import, method: :post do
    csv = params[:schools_csv]
    if csv && School.import(csv[:file])
      redirect_to admin_schools_path, notice: 'Schools successully imported.'
    else
      redirect_to admin_schools_path, error: 'Something went wrong!'
    end
  end

  action_item only: :index do
    link_to('Import Schools', upload_csv_admin_schools_path)
  end

  menu priority: 5

  filter :school_type, as: :select, collection: proc { School.school_types }
  filter :school_level, as: :select, collection: proc { School.school_levels }
  filter :name
  filter :city
  filter :region

  index do
    selectable_column
    id_column
    column :name
    column :city
    column :region
    column :school_type
    column :school_level

    column("Links") do |s|
      span link_to('Website', s.website_url) if s.website_url?
      span link_to('Athletics', s.athletics_url) if s.athletics_url?
    end

    column "Contact" do |s|
      contact = s.contacts.first
      span link_to(contact.name, [:admin, contact]) if contact
    end

    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :city
      f.input :region
      f.input :school_type, collection: School.school_types, prompt: 'Choose type'
      f.input :school_level, collection: School.school_levels, prompt: 'Choose level'
      f.input :website_url
      f.input :athletics_url

      f.has_many :addresses do |af|
        af.input :address_type, collection: SchoolAddress.address_types, include_blank: false
        af.input :phone_number
        af.input :line_1
        af.input :line_2
        af.input :city
        af.input :region
        af.input :postal_code
        af.input :country, priority_countries: ['United States', 'Canada']
      end

      f.has_many :contacts do |cf|
        cf.input :contact_type, collection: SchoolContact.contact_types, prompt: 'Choose Type'
        cf.input :first_name
        cf.input :last_name
        cf.input :phone_number
        cf.input :email
      end
    end

    f.actions
  end

  show do |school|
    attributes_table :id, :name, :school_type, :school_level, :created_at, :updated_at

    school.addresses.each do |addr|
      panel "#{addr.address_type} Address" do
        attributes_table_for addr do
          row :line_1
          row :line_2
          row :city
          row :region
          row :postal_code
          row :country
          row :updated_at
        end
      end
    end

    active_admin_comments
  end
end
