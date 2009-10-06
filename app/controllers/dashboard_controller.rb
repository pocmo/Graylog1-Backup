class DashboardController < ApplicationController

  def index
    if Setting.last.blank?
      @timespan = 10
      @number_of_allowed_messages = 100
      @fontsize = 50
    else
      Setting.last.dashboard_timespan.blank? ? @timespan = 10 : @timespan = Setting.last.dashboard_timespan.to_i
      Setting.last.dashboard_messages.blank? ? @number_of_allowed_messages = 100 : @number_of_allowed_messages = Setting.last.dashboard_messages.to_i
      Setting.last.dashboard_font_size.blank? ? @fontsize = 50 : @fontsize = Setting.last.dashboard_font_size.to_i
    end
    blacklist_conditions = build_conditions_from_blacklist
    timespan_condition = [ "ReceivedAt > ?", @timespan.minutes.ago]
    conditions = Logentry.merge_conditions blacklist_conditions, timespan_condition
    @new_messages = Logentry.count :conditions => conditions
    
    @alert = alert? @number_of_allowed_messages, @new_messages
  end
  
  def nagioscheck
    render :text => "okay" if !alert?
    render :text => "alert"
  end
  
  private
  def alert? number_of_allowed_messages, new_messages
    true if new_messages > number_of_allowed_messages
    false
  end

end
