class AddBlacklistIdToBlacklistterms < ActiveRecord::Migration
  def self.up
    add_column :blacklistterms, :blacklist_id, :integer, :default => 0
  end

  def self.down
    remove_column :blacklistterms, :blacklist_id
  end
end
