class AddDashboardFontsize < ActiveRecord::Migration
  def self.up
    add_column :settings, :dashboard_font_size, :integer
  end

  def self.down
    remove_column :settings, :dashboard_font_size, :integer
  end
end
