class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.string :permalink
      t.text :content
      t.string :document_code

      t.timestamps
    end
    add_index :pages, :permalink
  end
end
