class AddGeterrorToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :geterror_url, :string
  end

  def self.down
    remove_column :settings, :geterror_url
  end
end
