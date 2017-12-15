# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsStarter
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = "Paris"

    config.max_upload_size = 4.megabytes

    config.action_mailer.default_options = {
        from: 'noreply@ensemble.fr',
        to:   'clairezuliani@gmail.com'
      }
  end
end
