class Logentry < ActiveRecord::Base
  
  include AuthenticatedSystem

  def self.get_new_messages timespan, blacklist_conditions
    timespan_condition = [ "ReceivedAt > ?", timespan.minutes.ago]
    conditions = self.merge_conditions blacklist_conditions, timespan_condition
    return self.count :conditions => conditions
  end

  def self.count_new_messages_since timestamp, blacklist_conditions
    timespan_condition = [ "ReceivedAt > ?", timestamp]
    conditions = self.merge_conditions blacklist_conditions, timespan_condition
    return self.count :conditions => conditions

  end

  def self.alert? number_of_allowed_messages, new_messages
    return true if new_messages > number_of_allowed_messages
    return false
  end

  def human_readable_severity
    case self.Priority
      when 0: "Emergency"
      when 1: "Alert"
      when 2: "Critical"
      when 3: "Error"
      when 4: "Warning"
      when 5: "Notice"
      when 6: "Info"
      when 7: "Debug"
      else "Unknown"
    end
  end

  def self.recent user
    return self.count :conditions => [ "ReceivedAt > ?", user.last_activity ]
  end

  def self.table_name
    "#{SYSLOG_DB}.SystemEvents"
  end

  def self.per_page
    100
  end

end
