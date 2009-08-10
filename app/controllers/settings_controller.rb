class SettingsController < ApplicationController
  def index
    @new_category = Category.new
    @categories = Category.find :all
    @settings = Setting.new
    if Setting.last.blank?
      @geterror_url = String.new
      @base_url = String.new
    else
      Setting.last.geterror_url.blank? ? @geterror_url = String.new : @geterror_url = Setting.last.geterror_url
      Setting.last.base_url.blank? ? @base_url = String.new : @base_url = Setting.last.base_url
    end
  end

  def update
    settings = Setting.find :last
    if settings.blank?
      settings = Setting.new params[:setting]
    else
      settings.geterror_url = params[:setting][:geterror_url] unless params[:setting][:geterror_url].blank?
      settings.base_url = params[:setting][:base_url] unless params[:setting][:base_url].blank?
    end
    if settings.save
      flash[:notice] = "Settings updated."
    else
      flash[:error] = "Could not update settings."
    end
    redirect_to :action => "index"
  end 
end
