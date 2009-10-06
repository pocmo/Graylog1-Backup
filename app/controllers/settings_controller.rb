class SettingsController < ApplicationController
  def index
    @new_category = Category.new
    @categories = Category.find :all
    @settings = Setting.new
    if Setting.last.blank?
      @geterror_url = String.new
      @base_url = String.new
      @dashboard_timespan = String.new
      @dashboard_messages = String.new
      @dashboard_font_size = String.new
    else
      Setting.last.geterror_url.blank? ? @geterror_url = String.new : @geterror_url = Setting.last.geterror_url
      Setting.last.base_url.blank? ? @base_url = String.new : @base_url = Setting.last.base_url
      Setting.last.dashboard_timespan.blank? ? @dashboard_timespan = String.new : @dashboard_timespan = Setting.last.dashboard_timespan
      Setting.last.dashboard_messages.blank? ? @dashboard_messages = String.new : @dashboard_messages = Setting.last.dashboard_messages
      Setting.last.dashboard_font_size.blank? ? @dashboard_font_size = String.new : @dashboard_font_size = Setting.last.dashboard_font_size
    end
  end

  def update
    settings = Setting.find :last
    if settings.blank?
      settings = Setting.new params[:setting]
    else
      settings.geterror_url = params[:setting][:geterror_url] unless params[:setting][:geterror_url].blank?
      settings.base_url = params[:setting][:base_url] unless params[:setting][:base_url].blank?
      settings.dashboard_timespan = params[:setting][:dashboard_timespan] unless params[:setting][:dashboard_timespan].blank?
      settings.dashboard_messages = params[:setting][:dashboard_messages] unless params[:setting][:dashboard_messages].blank?
      settings.dashboard_font_size = params[:setting][:dashboard_font_size] unless params[:setting][:dashboard_font_size].blank?
    end
    if settings.save
      flash[:notice] = "Settings updated."
    else
      flash[:error] = "Could not update settings."
    end
    redirect_to :action => "index"
  end 
end
