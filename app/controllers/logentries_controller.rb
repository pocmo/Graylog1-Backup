class LogentriesController < ApplicationController
  def destroy
    # Also delete Validmessage if there is one connected to this Logentry.
    vm = Validmessage.find_by_syslog_message_id params[:id]
    vm.destroy unless vm.blank?

    ActiveRecord::Base.connection.execute "DELETE FROM `Syslog`.`SystemEvents` WHERE `ID` = #{params[:id].to_i}"
    render :text => nil
  end

  def destroy_selection
    @filter_strings = Hash.new
    params[:filter_host].blank? ? @filter_strings["host"] = "" : @filter_strings["host"] = params[:filter_host]
    params[:filter_message].blank? ? @filter_strings["message"] = "" : @filter_strings["message"] = params[:filter_message]
    params[:filter_severity].blank? ? @filter_strings["severity"] = "" : @filter_strings["severity"] = params[:filter_severity]
    params[:filter_date_start].blank? ? @filter_strings["date_start"] = "" : @filter_strings["date_start"] = params[:filter_date_start]
    params[:filter_date_end].blank? ? @filter_strings["date_end"] = "" : @filter_strings["date_end"] = params[:filter_date_end]


    # Build conditions from possibly set filter options
    conditions = build_conditions_from_filter_parameters CGI::unescape(@filter_strings["host"]), CGI::unescape(@filter_strings["message"]), CGI::unescape(@filter_strings["severity"]), CGI::unescape(@filter_strings["date_start"]), CGI::unescape(@filter_strings["date_end"])

    if conditions.blank?
      # Delete all messages.
      Logentry.delete_all
    else
      # Only delete some messages hit by a filter.
      Logentry.delete_all conditions
    end
    redirect_back_or_default("/")
  end

end
