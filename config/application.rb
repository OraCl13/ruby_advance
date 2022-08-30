require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Qna2
  class Application < Rails::Application
    config.app_generators.scaffold_controller :responders_controller

    config.active_job.queue_adapter = :sidekiq

    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       request_specs: false,
                       controller_specs: true
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end

    # config.action_cable.disable_request_forgery_protection = false
  end
end
