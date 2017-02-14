class AddIndexForNameAndLocationOnSchools < ActiveRecord::Migration
  def change
    add_index :schools, :name
    add_index :schools, :city
    add_index :schools, :region
  end

  # These might be a better way to go, but would be more involved,
  # as I think it will change our db strategy from schema to sql.
  # Keeping these around for reference, but also because in testing,
  # I didn't see that significant of a difference in the query speed
  # between the gin and the standard indexes.
  #
  # def up
  #   execute "create index schools_name on schools using gin(to_tsvector('english', name))"
  #   execute "create index schools_city on schools using gin(to_tsvector('english', city))"
  #   execute "create index schools_region on schools using gin(to_tsvector('english', region))"
  # end

  # def down
  #   execute "drop index schools_name"
  #   execute "drop index schools_city"
  #   execute "drop index schools_region"
  # end
end
