class ApplicationController < ActionController::Base

  include AuthenticatedSystem

  before_filter :block_unauthenticated
  before_filter :update_last_user_activity

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password

  helper_method :is_favorited_category?
  def is_favorited_category? category_id, user_id
    favorite = Favorite.find_by_category_id_and_user_id category_id, user_id
    return false if favorite.blank?
    return true
  end

  def build_conditions_from_filter_parameters host, message, severity, date_start, date_end
    c1 = String.new
    c2 = String.new
    c3 = String.new
    c4 = String.new
    c1 = [ "FromHost = ?", host ] if !host.blank?
    c2 = [ "Message LIKE ?", "%#{message}%" ] if !message.blank?
    c3 = [ "Priority <= ?", severity.to_i ] if !severity.blank?
    if !date_start.blank? and !date_end.blank?
      c4 = [ "ReceivedAt >= ? AND ReceivedAt <= ?", date_start, date_end ]
    end
    return Logentry.merge_conditions c1, c2, c3, c4
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

end
