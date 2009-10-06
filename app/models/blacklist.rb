class Blacklist < ActiveRecord::Base
  has_many :blacklistterms
  
  def self.build_conditions
    conditions = Array.new
    bl_terms = Blacklistterm.find :all
    bl_terms.each do |term|
      conditions << [ "Message NOT LIKE ?", "%#{term.message}%" ] unless term.message.blank?
    end

    return Logentry.merge_conditions *conditions
  end
end
