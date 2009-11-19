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

    filter_strings = Hash.new
    filter_strings["host"] = ""
    filter_strings["message"] = ""
    filter_strings["severity"] = ""
    filter_strings["date_start"] = ""
    filter_strings["date_end"] = ""

    # Category Filter
    if !params[:category].blank?
      category = Category.find params[:category]
      category.filter_host.blank? ? filter_strings["host"] = "" : filter_strings["host"] = category.filter_host
      category.filter_message.blank? ? filter_strings["message"] = "" : filter_strings["message"] = category.filter_message
      category.filter_severity.blank? ? filter_strings["severity"] = "" : filter_strings["severity"] = category.filter_severity
      category.filter_date_start.blank? ? filter_strings["date_start"] = "" : filter_strings["date_start"] = category.filter_date_start
      category.filter_date_end.blank? ? filter_strings["date_end"] = "" : filter_strings["date_end"] = category.filter_date_end
    end
    
    # Blacklist
    if params[:blacklist].blank? || params[:blacklist] == 'true'
      blacklist_conditions = build_conditions_from_blacklist
    else
      blacklist_conditions = []
    end
    
    # Filter (will override filters by category)
    if !params[:filter].blank?
      !params[:filter][:host].blank? && filter_strings["host"] = params[:filter][:host]
      !params[:filter][:message].blank? && filter_strings["message"] = params[:filter][:message]
      !params[:filter][:severity].blank? && filter_strings["severity"] = params[:filter][:severity]
      !params[:filter][:date_start].blank? && filter_strings["date_start"] = params[:filter][:date_start]
      !params[:filter][:date_end].blank? && filter_strings["date_end"] = params[:filter][:date_end]
    end

    # Build Filters
    filter_condition = build_conditions_from_filter_parameters filter_strings["host"], filter_strings["message"], filter_strings["severity"], filter_strings["date_start"], filter_strings["date_end"]

    # Merge all conditions
    conditions = Logentry.merge_conditions start_condition, filter_condition, blacklist_conditions

    logmessages = Logentry.find :all, :conditions => conditions, :limit => limit, :offset => offset, :order => "ID DESC"
    render :text => logmessages.to_json
  end
  
  def getdashboard
    begin
      @dashboard_settings = Setting.get_dashboard_settings
      @new_messages = Logentry.get_new_messages @dashboard_settings["timespan"], build_conditions_from_blacklist
      json = { "status" => "success", "messages" => @new_messages, "last_message" => Logentry.last, "timespan" => @dashboard_settings["timespan"] }
    rescue
      json = { "status" => "error" }
    end
      render :text => json.to_json
  end
  
end
