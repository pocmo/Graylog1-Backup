class DashboardController < ApplicationController

  include Amatch

  SCAN_NUMBER_OF_MESSAGES = 50
  MINIMUM_LEVENSHTEIN_MATCH = 15
  MINIMUM_MATCHES = 5

  def index
    blacklist_conditions = build_conditions_from_blacklist
    messages = Logentry.find :all, :order => "ReceivedAt DESC", :conditions => blacklist_conditions, :limit => SCAN_NUMBER_OF_MESSAGES
    @alert_messages = get_dashboard_alarms messages
  end

  private
  
  def get_dashboard_alarms messages
    results = Array.new
    messages.each do |message|
      matches = 0
      last_matched_message = String.new
      l = Levenshtein.new message.Message
      
      i = 0
      messages.each do |message|
        # Don't scan yourself.
        if i == 0
          i += 1
          next
        end
        
        res = l.match message.Message
        if res <= MINIMUM_LEVENSHTEIN_MATCH
          matches += 1
          logger.info "MATCH: #{message.Message}"
          last_matched_message = message.Message
        end
        i += 1
      end
      
      if matches > MINIMUM_MATCHES
        results << {:message => last_matched_message, :matches => matches }
      end
    end
    
    # Remove double results
    return results.uniq
    
  end

end
