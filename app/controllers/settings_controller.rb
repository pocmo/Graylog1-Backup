class SettingsController < ApplicationController
  def index
    @new_category = Category.new
    @categories = Category.find :all
    @settings = Setting.new
    @geterror_url = String.new
    unless Setting.last.blank? or Setting.last.geterror_url.blank?
      @geterror_url = Setting.last.geterror_url
    end
  end

  def update
    settings = Setting.find :last
    if settings.blank?
      settings = Setting.new params[:setting]
    else
      settings.geterror_url = params[:setting][:geterror_url]
    end
    if settings.save
      flash[:notice] = "Settings updated."
    else
      flash[:error] = "Could not update settings."
    end
    redirect_to :action => "index"
  end 
end
