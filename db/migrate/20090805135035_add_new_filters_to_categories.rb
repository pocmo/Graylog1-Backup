class AddNewFiltersToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :filter_severity, :integer
    add_column :categories, :filter_date_start, :datetime
    add_column :categories, :filter_date_end, :datetime
  end

  def self.down
    remove_column :categories, :filter_severity
    remove_column :categories, :filter_date_start
    remove_column :categories, :filter_date_end
  end
end
