class DashboardController < ApplicationController

  def index
    @dashboard_settings = get_dashboard_settings
    @new_messages = get_new_messages @dashboard_settings["timespan"]
    @alert = alert? @dashboard_settings["number_of_allowed_messages"], @new_messages
  end
  
  def nagioscheck
    @dashboard_settings = get_dashboard_settings
    @new_messages = get_new_messages @dashboard_settings["timespan"]
    
    if !alert? @dashboard_settings["number_of_allowed_messages"], @new_messages
      render :text => "okay"
      return
    end
    
    render :text => "alert"
  end
  
  private
  def get_new_messages timespan
    blacklist_conditions = build_conditions_from_blacklist
    timespan_condition = [ "ReceivedAt > ?", timespan.minutes.ago]
    conditions = Logentry.merge_conditions blacklist_conditions, timespan_condition
    return Logentry.count :conditions => conditions
  end
  
  def get_dashboard_settings
    if Setting.last.blank?
      timespan = 10
      number_of_allowed_messages = 100
      fontsize = 50
    else
      Setting.last.dashboard_timespan.blank? ? timespan = 10 : timespan = Setting.last.dashboard_timespan.to_i
      Setting.last.dashboard_messages.blank? ? number_of_allowed_messages = 100 : number_of_allowed_messages = Setting.last.dashboard_messages.to_i
      Setting.last.dashboard_font_size.blank? ? fontsize = 50 : fontsize = Setting.last.dashboard_font_size.to_i
    end
    
    return { "number_of_allowed_messages" => number_of_allowed_messages,
             "timespan" => timespan,
             "fontsize" => fontsize }
  end
  
  def alert? number_of_allowed_messages, new_messages
    return true if new_messages > number_of_allowed_messages
    return false
  end

end
