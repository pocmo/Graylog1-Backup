class OverviewController < ApplicationController

  # This just disables the layout if a RSS feed was requested (?feed=true).
  layout :no_layout_for_feed

  def index
    @feed = true

    @severity_options = Array.new
    @severity_options << [ ">= Debug (0)", 7 ]
    @severity_options << [ ">= Info (1)", 6 ]
    @severity_options << [ ">= Notice (2)", 5 ]
    @severity_options << [ ">= Warning (3)", 4 ]
    @severity_options << [ ">= Error (4)", 3 ]
    @severity_options << [ ">= Critical (5)", 2 ]
    @severity_options << [ ">= Alert (6)", 1 ]
    @severity_options << [ ">= Emergency (7)", 0 ]

    @filter_strings = Hash.new
    if params[:commit] == "Filter"
      @filter_strings["host"] = params[:filter][:host]
      @filter_strings["message"] = params[:filter][:message]
      @filter_strings["severity"] = params[:filter][:severity]
      @filter_strings["date_start"] = params[:filter][:date_start]
      @filter_strings["date_end"] = params[:filter][:date_end]

      # Build conditions from possibly set filter options
      conditions = build_conditions_from_filter_parameters @filter_strings["host"], @filter_strings["message"], @filter_strings["severity"], @filter_strings["date_start"], @filter_strings["date_end"] 
    end    
   
    # Ordering from table heads
    order = build_order_string params[:order], params[:direction]

    # Ordering
    order = String.new
    if params[:order].blank?
      order = "ReceivedAt DESC"
    else
      case params[:order]
        when "date": order = "ReceivedAt"
        when "host": order = "FromHost"
        when "severity": order = "Priority"
        when "message": order = "Message"
      end

      # Add sorting order if a valid column was selected.
      unless order.blank?
        case params[:direction]
          when "desc": order += " DESC"
          when "asc": order += " ASC"
          else order += " DESC"
        end
      end
    end
 
    if params[:feed] == "true"
      limit = 50
      limit = params[:entries] unless params[:entries].blank?
      @messages = Logentry.find :all, :order => order, :conditions => conditions, :limit => limit
      @feed_title = "Overview"
      @feed_description = "Overview of the last log messages"
      @feed_url = "http://localhost:3000/"
      render :template => "feed"
    else
      if current_user
        @favorites = Favorite.find_all_by_user_id current_user.id
        @recent_messages_count = Logentry.recent current_user
      end
      @messages = Logentry.paginate :page => params[:page], :order => order, :conditions => conditions
      @new_category = Category.new
    end
  end

  private

  def no_layout_for_feed
    return nil if params[:feed] == "true"
    return "application"
  end

end
