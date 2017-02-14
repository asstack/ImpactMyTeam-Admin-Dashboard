ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    # div :class => "blank_slate_container", :id => "dashboard_default_message" do
    #   span :class => "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    columns do

      column do
        panel "Campaigns Awaiting Admin Approval" do
          table_for Campaign.with_status(:awaiting_contract).latest(15) do
            column(:campaign) { |c| auto_link(c, c.title) }
            column :school
            column(:goal) { |c| number_to_currency(c.goal_amount) }
            column(:creator) do |c|
              auto_link(c.creator, "#{c.creator.name} (#{c.creator.school_roles.where(school_id: c.school.id).pluck(:name).to_sentence})")
            end
          end
        end
        panel "Campaigns Recently Closed" do
          table_for Campaign.with_status(:closed).latest(15) do
            column(:campaign) { |c| auto_link(c, c.title) }
            column :school
            column(:goal) { |c| number_to_currency(c.goal_amount) }
            column(:creator) do |c|
                auto_link(c.creator, "#{c.creator.name} (#{c.creator.school_roles.where(school_id: c.school.id).pluck(:name).to_sentence})")
            end
          end
        end
      end

      column do
        panel "Users Awaiting Verification" do
          table_for SchoolRole.unverified.latest(15) do
            column :user
            column :school
            column(:role) { |role| auto_link(role, role.name) }
            column :actions do |role|
              span link_to('View', admin_school_role_path(role), class: 'member_link')
              span link_to('Edit', edit_admin_school_role_path(role), class: 'member_link')
              span link_to('Destroy', admin_school_role_path(role), method: :delete, confirm: 'Are you sure you want to delete this user role?', class: 'member_link')
              span link_to('Verify', verify_admin_school_role_path(role), method: :put, confirm: 'Are you sure? You should review this user carefully before granting privileges.', class: 'member_link')
            end
          end
        end
      end
    end
  end # content
end

