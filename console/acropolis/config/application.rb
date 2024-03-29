require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Acropolis
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('app/navigation_renderers')

    # i18n settings
    config.i18n.available_locales = ['zh-CN', :en]

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Beijing'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = 'zh-CN'

    config.to_prepare do
      Devise::SessionsController.layout "devise"
      ApplicationController.layout 'application'
    end

    # For nav_lynx
    config.nav_lynx.selected_class = 'active'

    config.generators.stylesheets = false
    # config.generators.javascripts = false

    config.assets.configure do |env|
      if Rails.env.development? || Rails.env.test?
        env.cache = ActiveSupport::Cache.lookup_store(:memory_store)
      end
    end
  end
end
