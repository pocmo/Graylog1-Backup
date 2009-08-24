class ApplicationController < ActionController::Base

  include AuthenticatedSystem

  before_filter :update_last_user_activity

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password

  helper_method :is_favorited_category?
  def is_favorited_category? category_id, user_id
    favorite = Favorite.find_by_category_id_and_user_id category_id, user_id
    return "" if favorite.blank?
    return "checked=\"checked\""
  end

  helper_method :is_valid_message?
  def is_valid_message? message
    vmsg = Validmessage.find_by_syslog_message_id message.ID
    return false if vmsg.blank?
    return true
  end

  def build_conditions_from_filter_parameters host, message, severity, date_start, date_end
    conditions = Array.new
    conditions << [ "FromHost = ?", host ] unless host.blank?
    conditions << [ "Message LIKE ?", "%#{message}%" ] unless message.blank?
    conditions << [ "Priority <= ?", severity.to_i ] unless severity.blank?
    conditions << [ "ReceivedAt >= ? AND ReceivedAt <= ?", date_start, date_end ] unless date_start.blank? or date_end.blank?

    return Logentry.merge_conditions *conditions
  end

  def build_conditions_from_blacklist
    conditions = Array.new
    bl_terms = Blacklistterm.find :all
    bl_terms.each do |term|
      conditions << [ "Message NOT LIKE ?", "%#{term.message}%" ] unless term.message.blank?
    end

    return Logentry.merge_conditions *conditions
  end
  
  def build_conditions_for_blacklist blacklist_id
    conditions = Array.new
    bl_terms = Blacklistterm.find_all_by_blacklist_id blacklist_id
    bl_terms.each do |term|
      conditions << [ "Message LIKE ?", "%#{term.message}%" ] unless term.message.blank?
    end

    return Logentry.merge_conditions_with_or *conditions
  end

  private

  def logged_in?
    begin
      return true if current_user
    end
    return false
  end

  def block_unauthenticated
    if !logged_in?
      redirect_to :controller => "sessions", :action => "new"
    else
      return true
    end
    return false
  end

  def update_last_user_activity
    return unless logged_in?
    user = User.find current_user.id
    user.last_activity = Time.now
    user.save
  end
  
  def build_order_string p_order, p_direction
    # Ordering
    order = String.new
    if p_order.blank?
      order = "ReceivedAt DESC"
    else
      case p_order
        when "date": order = "ReceivedAt"
        when "host": order = "FromHost"
        when "severity": order = "Priority"
        when "message": order = "Message"
      end

      # Add sorting order if a valid column was selected.
      unless order.blank?
        case p_direction
          when "desc": order += " DESC"
          when "asc": order += " ASC"
          else order += " DESC"
        end
      end
    end
    return order
  end

  def no_layout_for_feed
    return nil if params[:feed] == "true"
    return "application"
  end

end
