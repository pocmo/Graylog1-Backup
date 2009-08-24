class UsersController < ApplicationController
 
  def new
    @user = User.new
  end
 
  def create
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      redirect_to :controller => "overview"
      flash[:notice] = "Your account has been created."
    else
      flash[:error]  = "Could not create your account!"
      render :action => 'new'
    end
  end
end
