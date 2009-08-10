class AddBaseUrlToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :base_url, :string
  end

  def self.down
    remove_column :settings, :base_url
  end
end
