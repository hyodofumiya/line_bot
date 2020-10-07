desc "This task is called by the Heroku scheduler add-on"
task :reset_standby => :environment do
  Standby.task_to_reset_standby
end