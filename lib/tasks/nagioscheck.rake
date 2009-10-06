namespace :nagios do
  desc "Check if the number of new messages is too high."
  task :check => :environment do
    @dashboard_settings = Setting.get_dashboard_settings
    @new_messages = Logentry.get_new_messages @dashboard_settings["timespan"], Blacklist.build_conditions
    
    if !Logentry.alert? @dashboard_settings["number_of_allowed_messages"], @new_messages
      puts "okay"
    else
      puts "alert"
    end

  end
end
