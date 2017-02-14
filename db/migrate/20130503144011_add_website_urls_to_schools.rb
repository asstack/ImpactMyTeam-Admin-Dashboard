class AddWebsiteUrlsToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :website_url, :string
    add_column :schools, :athletics_url, :string
  end
end
