class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :title
      t.string :description
      t.string :filter_host
      t.string :filter_message
      t.timestamps
    end
  end

  def self.down
    drop_table :categories
  end
end
