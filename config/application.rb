require_relative 'boot'

require "rails"

require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    config.load_defaults 6.0
    config.time_zone = "Tokyo"
    config.api_only = true
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.eager_load_paths += Dir["#{config.root}/lib/**/"]
    config.enable_dependency_loading = true
  end
end
