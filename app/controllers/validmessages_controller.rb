class ValidmessagesController < ApplicationController
  def create
    if params[:id].blank?
      render :status => 500, :text => "missing parameters"
      return
    end
    msg = Validmessage.new
    msg.syslog_message_id = params[:id]
    msg.save
    render :text => nil
  end

  def destroy
    msg = Validmessage.find_by_syslog_message_id params[:id]
    msg.destroy
    render :text => nil
  end
end
