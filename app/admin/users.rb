ActiveAdmin.register User do
  menu priority: 3
  actions :all, except: [:new, :destroy]

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column(:email) { |user| mail_to user.email }
    column :phone_number
    column :last_sign_in_at
    column :created_at
    default_actions
  end

  show do |user|
    attributes_table do
      rows :id, :first_name, :last_name
      row(:email) { mail_to user.email }
      rows :phone_number
      rows :reset_password_sent_at
      rows :remember_created_at, :sign_in_count, :current_sign_in_at
      rows :current_sign_in_ip, :last_sign_in_at, :last_sign_in_ip
      rows :created_at, :updated_at
    end

    panel "Roles" do
      table_for user.school_roles do
        column :school
        column :name
        column :verified_by
        column :verified_at
        column :actions do |role|
          span link_to('View', admin_school_role_path(role), class: 'member_link')
          span link_to('Edit', edit_admin_school_role_path(role), class: 'member_link')
          span link_to('Destroy', admin_school_role_path(role), method: :delete, confirm: 'Are you sure you want to delete this user role?', class: 'member_link')
          span link_to('Verify', verify_admin_school_role_path(role), method: :put, confirm: 'Are you sure? You should review this user carefully before granting privileges.', class: 'member_link') unless role.verified?
        end
      end
    end

    user.campaigns.group_by(&:school).each do |school, campaigns|
      panel "Campaigns for #{school.name}" do

        table_for campaigns do
          column(:title) { |campaign| auto_link campaign }
          column(:school) { |campaign| auto_link campaign.school }
          column(:status) { |campaign| status_tag(campaign.status) }
          column(:goal) { |campaign| [campaign.collected_donations.total, campaign.goal_amount].map{|a| number_to_currency(a) }.join(' / ') }
          column :start_date
          column :end_date
          column(:donations) { |campaign| campaign.collected_donations.size }
        end
      end
    end


    active_admin_comments
  end

  form do |f|
    f.inputs "Details" do
      # These should be set by the user only. We are keeping editing around
      # for admins to be able to verify identities and tie them to schools
      f.input :first_name, input_html: { readonly: current_admin_user != f.object }
      f.input :last_name, input_html: { readonly: current_admin_user != f.object }
      f.input :email, input_html: { readonly: current_admin_user != f.object }
      f.input :phone_number, input_html: { readonly: current_admin_user != f.object }
    end
    f.actions
  end
end
