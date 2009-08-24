class BlacklistsController < ApplicationController

  # This just disables the layout if a RSS feed was requested (?feed=true).
  layout :no_layout_for_feed

  def index
    @blacklists = Blacklist.find :all

    @new_blacklist = Blacklist.new
  end

  def show
    @feed = true
    @blacklist = Blacklist.find params[:id]
    
    # Ordering from table heads
    order = build_order_string params[:order], params[:direction]
    
    @geterror_url = String.new
    unless Setting.last.blank?
      @geterror_url = Setting.last.geterror_url unless Setting.last.geterror_url.blank?
    end

    conditions = build_conditions_for_blacklist @blacklist.id

    if params[:feed] == "true"
      limit = 50
      limit = params[:entries] unless params[:entries].blank?
      if @blacklist.blacklistterms.count > 0
        @messages = Logentry.find :all, :order => order, :conditions => conditions, :limit => limit
      else
        @messages = Array.new
      end
      @feed_title = "Blacklist #{@blacklist.name}"
      @feed_description = "Overview of the last log messages filtered by blacklist #{@blacklist.name}"
      if Setting.last.blank?
        @feed_url = "/"
      else
        @feed_url = "#{Setting.last.base_url}/blacklists/show/#{@blacklist.id}"
      end
      render :template => "feed"
    else
      if @blacklist.blacklistterms.count > 0
        @messages = Logentry.paginate :page => params[:page], :order => order, :conditions => conditions
      else
        @messages = Array.new
      end
    end
    
    @new_term = Blacklistterm.new
  end

  def create
    new_blacklist = Blacklist.new params[:blacklist]
    if new_blacklist.save
      flash[:notice] = "Blacklist has been saved"
    else
      flash[:error] = "Could not save blacklist"
    end
    redirect_to :action => "index"
  end

  def destroy
    Blacklistterm.delete_all [ "blacklist_id = ?", params[:id] ]
    blacklist = Blacklist.find params[:id]
    blacklist.destroy
    redirect_to :action => "index"
  end

end
