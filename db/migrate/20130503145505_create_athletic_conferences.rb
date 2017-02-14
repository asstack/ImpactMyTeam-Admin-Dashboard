class CreateAthleticConferences < ActiveRecord::Migration
  def change
    create_table :athletic_conferences do |t|
      t.string :name

      t.timestamps
    end
  end
end
