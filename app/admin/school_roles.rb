ActiveAdmin.register SchoolRole do
  member_action :verify, method: :put do
    school_role = SchoolRole.find(params[:id])
    school_role.verify!(current_admin_user)
    redirect_to :action => :show, :notice => "Verified!"
  end

  batch_action :verify, confirm: 'Are you sure you want to verify all of these?' do |selection|
    SchoolRole.find(selection).each do |role|
      role.verify! current_admin_user
    end
    redirect_to :back
  end

  action_item only: :show do
    link_to 'Verify School Role', verify_admin_school_role_path(school_role), method: :put, confirm: 'Are you sure?' unless school_role.verified?
  end

  menu parent: 'Users', priority: 2

  scope :all
  scope :verified
  scope :unverified

  filter :user_first_name_or_user_last_name, as: :string, label: 'User'
  filter :school_name_or_school_city_or_school_region, as: :string, label: 'School'
  filter :name, as: :select, collection: SchoolRole.role_mappings, label: 'Role'
  filter :verified_by,
          as: :select,
          collection: proc{ SchoolRole.find(:all, include: :verified_by, conditions: ['verified_by_id IS NOT NULL']).collect(&:verified_by) }
  filter :verified_at
  filter :created_at
  filter :updated_at

  index do
    selectable_column

    id_column
    column(:name) { |r| auto_link(r) }
    column(:school) { |r| auto_link(r.school) }
    column(:user) { |r| auto_link(r.user) }

    column(:verified_at) do |r|
      if r.verified_at.nil?
        link_to 'Verify', verify_admin_school_role_path(r), method: :put, confirm: 'Are you sure?'
      else
        pretty_format(r.verified_at)
      end
    end

    column(:verified_by)
    column(:created_at)
    column(:updated_at)

    default_actions
  end

  form do |f|
    f.inputs "Details" do
      f.input :user
      f.input :school
      f.input :name, collection: SchoolRole.roles, include_blank: 'Select Role'
    end

    f.actions
  end
end
