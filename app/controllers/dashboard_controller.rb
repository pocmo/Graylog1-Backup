class DashboardController < ApplicationController

  include Amatch

  TIMESPAN_MINUTES = 10
  MINIMUM_LEVENSHTEIN_MATCH = 15
  MINIMUM_MATCHES = 10

  def index

  end

  private
  
##### USE MEMCACHE
#  def get_dashboard_alarms messages
#    require 'digest/md5'
#    results = Array.new
#
#    cache = Hash.new
#
#    messages.each do |message|
#      matches = 0
#      last_matched_message = String.new
#      l = Levenshtein.new message.Message
#      
#      i = 0
#      messages.each do |message|
#        # Don't scan yourself.
#        if i == 0
#          i += 1
#          next
#        end
#        
#        messages.each do |message|
#            message_md5 = Digest::MD5.hexdigest message.Message
#            if cache[message_md5] === i
#              # Cache miss.
#              levenshtein = l.match(message.Message)
#              cache[message_md5] = levenshtein
#              res = levenshtein
#            end
#        end
#
#        if res <= MINIMUM_LEVENSHTEIN_MATCH
#          matches += 1
#          last_matched_message = message.Message
#        end
#        i += 1
#      end
#      
#      if matches > MINIMUM_MATCHES
#        results << {:message => last_matched_message, :matches => matches }
#      end
#    end
#    
#    # Remove double results
#    return results.uniq
#  end

end
