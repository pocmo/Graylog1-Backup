class ApiController < ApplicationController
  
  def ping
    # just to check if there's a graylog installation answering
    render :text => 'GrayLog/Pong'
  end
  
  def getcategories
    categories = Category.find :all
    render :text => categories.to_json
  end
  
  def getmessages
    limit = params[:limit].to_i
    limit = 50 if limit.blank? or limit > 250

    offset = params[:offset].to_i
    offset = 0 if offset.blank?

    if params[:start_from_id].blank?
      start_condition = Array.new
    else
      start_condition = [ "ID > ?", params[:start_from_id] ]
    end

    if params[:category].blank?
      category_condition = Array.new
    else
      category_condition = [ ]
    end

    # Merge all conditions
    conditions = Logentry.merge_conditions start_condition, category_condition

    logmessages = Logentry.find :all, :conditions => conditions, :limit => limit, :offset => offset, :order => "ID DESC"
    render :text => logmessages.to_json
  end
  
end
