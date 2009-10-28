class DashboardController < ApplicationController

  def index
    @dashboard_settings = Setting.get_dashboard_settings
    @new_messages = Logentry.get_new_messages @dashboard_settings["timespan"], build_conditions_from_blacklist
    @alert = Logentry.alert? @dashboard_settings["number_of_allowed_messages"], @new_messages
  end
  
  def nagioscheck
    @dashboard_settings = Setting.get_dashboard_settings
    @new_messages = Logentry.get_new_messages @dashboard_settings["timespan"], build_conditions_from_blacklist
    
    unless params[:simple].blank?
      if !Logentry.alert? @dashboard_settings["number_of_allowed_messages"], @new_messages
        render :text => "okay"
        return
      end
      
      render :text => "alert"
    else
      render :text => @new_messages
    end
  end

  def api
    begin
      @dashboard_settings = Setting.get_dashboard_settings
      @new_messages = Logentry.get_new_messages @dashboard_settings["timespan"], build_conditions_from_blacklist
      json = { "status" => "success", "messages" => @new_messages, "last_message" => Logentry.last.Message, "timespan" => @dashboard_settings["timespan"] }
    rescue
      json = { "status" => "error" }
    end
      render :text => json.to_json
  end

end
