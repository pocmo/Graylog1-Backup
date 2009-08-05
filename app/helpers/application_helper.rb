module ApplicationHelper
  def build_menu_link to
    if request.path_parameters["controller"] == to.downcase
      link_to to, { :controller => to }, :class => "top-menu-active-link"
    else
      link_to to, :controller => to
    end
  end
  
  def no_filters_set? filter
    filter["host"].blank? and filter["message"].blank? and filter["severity"].blank? and filter["date_start"].blank? and filter["date_end"].blank?
  end

  def th_link_to_order str
    if params[:order].blank? or params[:order] != str.downcase
      direction_string = "";
    else
      if params[:direction].blank?
        direction_string = "desc"
      else
        case params[:direction]
          when "asc": direction_string = "asc"
          when "desc": direction_string = "desc"
          else direction_string = "desc"
        end
      end
    end
    
    link = link_to str, {  :controller => request.path_parameters["controller"],
                                :action => request.path_parameters["action"],
                                :id => request.path_parameters["id"],
                                :order => str.downcase,
                                :direction => flip_order_direction(direction_string) }

    full_direction_string = String.new
    unless direction_string.blank?
      full_direction_string = "(#{direction_string.upcase})"
    end

    return "#{link} #{full_direction_string}"
  end

  def flip_order_direction str
    "desc" if str == "asc"
    "asc" if str == "desc"
  end

end
