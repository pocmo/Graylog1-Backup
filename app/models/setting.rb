class Setting < ActiveRecord::Base
  
  def self.get_dashboard_settings
    if self.last.blank?
      timespan = 10
      number_of_allowed_messages = 100
      fontsize = 50
    else
      self.last.dashboard_timespan.blank? ? timespan = 10 : timespan = self.last.dashboard_timespan.to_i
      self.last.dashboard_messages.blank? ? number_of_allowed_messages = 100 : number_of_allowed_messages = self.last.dashboard_messages.to_i
      self.last.dashboard_font_size.blank? ? fontsize = 50 : fontsize = self.last.dashboard_font_size.to_i
    end
    
    return { "number_of_allowed_messages" => number_of_allowed_messages,
             "timespan" => timespan,
             "fontsize" => fontsize }
  end
  
end
