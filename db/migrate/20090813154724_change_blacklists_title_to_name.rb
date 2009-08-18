class ChangeBlacklistsTitleToName < ActiveRecord::Migration
  def self.up
    rename_column :blacklists, :title, :name
  end

  def self.down
    rename_column :blacklists, :name, :title
  end
end
