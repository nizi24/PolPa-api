# weeklyTargetの達成を判定するために使用する予定だったが、方法を変更

ENV.each { |k, v| env(k, v) }
require File.expand_path(File.dirname(__FILE__) + "/environment")
rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env
set :output, "#{Rails.root}/log/cron.log"

# every :monday, :at => '4am' do
#   runner "Script::WeeklyTargetAchievement.achieve", :environment_variable => "RAILS_ENV", :environment => "development"
# end

every 1.minutes do
  command "echo 'hello world'"
end
