require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module CompaniesApi
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])
    config.api_only = true
    config.active_job.queue_adapter = :sidekiq
  end
end
