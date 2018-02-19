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
    config.autoload_paths << Rails.root.join('lib')

    config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"

    config.max_upload_size = 4.megabytes

    config.action_mailer.default_options = {
        from: 'contact@ensemble-app.fr',
        to:   'clairezuliani@gmail.com'
      }
  end
end
