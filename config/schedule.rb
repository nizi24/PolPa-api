require File.expand_path(File.dirname(__FILE__) + "/environment")
rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env
set :output, "#{Rails.root}/log/cron.log"

every :monday, :at => '4am' do
  runner "lib/script/weekly_target_achievement.rb", :environment_variable => "RAILS_ENV", :environment => "development"
end
