class CreateBlacklistterms < ActiveRecord::Migration
  def self.up
    create_table :blacklistterms do |t|
      t.string :message
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :blacklistterms
  end
end
