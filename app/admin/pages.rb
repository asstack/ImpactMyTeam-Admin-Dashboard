ActiveAdmin.register Page do
  controller do
    defaults finder: :find_by_permalink
  end

  menu priority: 4

  index do
    selectable_column
    id_column
    column(:name) { |page| auto_link page }
    column :document_code
    column(:permalink) { |page| link_to page.permalink, page_path(page) }
    column :created_at
    column :updated_at

    default_actions
  end

  show do |page|
    attributes_table do
      row :id
      row :name
      row :permalink

      row(:content) { markdown(page.content) }

      row(:created_at) { pretty_format(page.created_at) }
      row(:updated_at) { pretty_format(page.updated_at) }
      row :document_code
    end
    active_admin_comments
  end

  form do |f|
    f.inputs "Details" do
      f.input :permalink, hint: 'The url slug for the page: i.e. "www.impactmyteam.com/permalink"'
      f.input :name
      f.input :document_code
      f.input :content, hint: 'Content is formatted in markdown.'
    end
    f.actions
  end
end
