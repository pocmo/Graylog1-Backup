class BlacklistsController < ApplicationController
  def index
    @blacklists = Blacklist.find :all

    @new_blacklist = Blacklist.new
  end

  def show
    @blacklist = Blacklist.find params[:id]
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

end
