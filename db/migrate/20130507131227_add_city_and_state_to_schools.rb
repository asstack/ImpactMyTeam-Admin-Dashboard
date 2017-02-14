class AddCityAndStateToSchools < ActiveRecord::Migration
  # I've decided that it is important to specify the city and state of a school
  # independent of its address (either shipping or billing). This will also
  # improve indexing and searching performance.
  def change
    add_column :schools, :city, :string
    add_column :schools, :region, :string
  end
end
