require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"

# require "active_storage/engine"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ShadowrunDiceBot
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.action_controller.allow_forgery_protection = false

    config.generators.system_tests = nil

    config.eager_load = true
    Rails.autoloaders.log!
    Rails.autoloaders.logger = Logger.new("#{Rails.root}/log/autoloading.log")

    ['lib', 'jobs', 'jobs/telegram'].each do |path|
      full_path = Rails.root.join path
      config.eager_load_paths << full_path
      config.autoload_paths   << full_path
    end
    #raise config.eager_load_paths.inspect
    #raise config.autoload_paths.inspect

    config.active_job.queue_adapter = :async

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))
    config.telegram_bot_token = ENV['TELEGRAM_BOT_TOKEN'].to_s.strip
  end
end
