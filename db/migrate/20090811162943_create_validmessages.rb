class CreateValidmessages < ActiveRecord::Migration
  def self.up
    create_table :validmessages do |t|
      t.integer :syslog_message_id
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :validmessages
  end
end
