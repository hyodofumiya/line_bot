desc "This task is called by the Heroku scheduler add-on"
task :update_feed => :environment do
  Standby.task_to_reset_standby
end