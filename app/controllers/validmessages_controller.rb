class ValidmessagesController < ApplicationController
  def index
    @messages = Validmessage.paginate :page => params[:page],
      :joins => "LEFT JOIN `Syslog`.`SystemEvents` AS messages ON messages.ID = validmessages.syslog_message_id",
      :select => "validmessages.id, messages.ID, ReceivedAt, Priority, FromHost, Message, SysLogTag"
  end

  def create
    # We get the IDs to create in a long string separated by comma.
    ids = params[:items].split ","

    ids.each do |id|
      next if id == "checkAll"
      msg = Validmessage.new
      msg.syslog_message_id = id
      msg.save
    end

    render :text => nil
  end

  def destroy
    msg = Validmessage.find_by_syslog_message_id params[:id]
    msg.destroy
    render :text => nil
  end
end
