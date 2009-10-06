class AddDashboardSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :dashboard_timespan, :string
    add_column :settings, :dashboard_messages, :string
  end

  def self.down
    remove_column :settings, :dashboard_timespan, :string
    remove_column :settings, :dashboard_messages, :string
  end
end
