class ApiController < ApplicationController
  
  def getcategories
    categories = Category.find :all
    render :text => categories.to_json
  end
  
  def getmessages
    limit = params[:limit]
    limit = 50 if limit.blank? or limit > 250

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

    logmessages = Logentry.find :all, :conditions => conditions, :limit => limit, :order => "ID DESC"
    render :text => logmessages.to_json
  end
  
end
