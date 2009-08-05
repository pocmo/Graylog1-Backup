class SettingsController < ApplicationController
  def index
    @new_category = Category.new
    @categories = Category.find :all
  end
end
