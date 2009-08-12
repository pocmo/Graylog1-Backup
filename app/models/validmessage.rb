class Validmessage < ActiveRecord::Base
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
  
  def self.per_page
    100
  end
end
