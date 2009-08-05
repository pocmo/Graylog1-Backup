class CategoriesController < ApplicationController

  # This just disables the layout if a RSS feed was requested (?feed=true).
  layout :no_layout_for_feed

  def index
    @categories = Category.find :all
    @number_of_messages = Hash.new
    @categories.each do |cat|
      @filter_strings = Hash.new
      @filter_strings["host"] = cat.filter_host
      @filter_strings["message"] = cat.filter_message
      @filter_strings["severity"] = cat.filter_severity
      @filter_strings["date_start"] = cat.filter_date_start
      @filter_strings["date_end"] = cat.filter_date_end

      # Build conditions from possibly set filter options
      conditions = build_conditions_from_filter_parameters @filter_strings["host"], @filter_strings["message"], @filter_strings["severity"], @filter_strings["date_start"], @filter_strings["date_end"] 
      
      @number_of_messages[cat.id] = Logentry.count :conditions => conditions
    end
  end

  def show
    @feed = true
    @category = Category.find params[:id]

    @filter_strings = Hash.new
    @category.filter_host.blank? ? @filter_strings["host"] = "" : @filter_strings["host"] = @category.filter_host
    @category.filter_message.blank? ? @filter_strings["message"] = "" : @filter_strings["message"] = @category.filter_message
    @category.filter_severity.blank? ? @filter_strings["severity"] = "" : @filter_strings["severity"] = @category.filter_severity
    @category.filter_date_start.blank? ? @filter_strings["date_start"] = "" : @filter_strings["date_start"] = @category.filter_date_start
    @category.filter_date_end.blank? ? @filter_strings["date_end"] = "" : @filter_strings["date_end"] = @category.filter_date_end

    # Build conditions from possibly set filter options
    conditions = build_conditions_from_filter_parameters @filter_strings["host"], @filter_strings["message"], @filter_strings["severity"], @filter_strings["date_start"], @filter_strings["date_end"] 
    
    if params[:feed] == "true"
      limit = 50
      limit = params[:entries] unless params[:entries].blank?
      @messages = Logentry.find :all, :order => "ReceivedAt DESC", :conditions => conditions, :limit => limit
      @feed_title = "Category #{@category.title}"
      @feed_description = "Overview of the last log messages in the category #{@category.title}"
      @feed_url = "http://localhost:3000/categories/show/#{@category.id}"
      render :template => "feed"
    else
      @filtered_messages = Logentry.paginate :page => params[:page], :order => "ReceivedAt DESC", :conditions => conditions
    end
  end

  def create
    @new_category = Category.new params[:category]
    if @new_category.save
      flash["notice"] = "Category has been created."
      redirect_to :action => "index"
    else
      flash["error"] = "Could not create category!"
      redirect_to :controller => "settings", :action => "index"
    end
  end

  def destroy
    category = Category.find params[:id]
    if category.destroy
      flash["notice"] = "Category has been deleted."
    else
      flash["error"] = "Could not delete category!"
    end
    redirect_to :controller => "settings", :action => "index"
  end
  
  def favorite
    favorite = Favorite.new
    favorite.category_id = params[:id]
    favorite.user_id = current_user.id
    favorite.save
    render :text => nil
  end

  def unfavorite
    favorite = Favorite.find_by_category_id_and_user_id params[:id], current_user.id
    favorite.destroy
    render :text => nil
  end

  private

  def no_layout_for_feed
    return nil if params[:feed] == "true"
    return "application"
  end

end
