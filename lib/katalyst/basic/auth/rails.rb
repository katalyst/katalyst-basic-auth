# frozen_string_literal: true

module Katalyst
  module Basic
    module Auth
      class Railtie < Rails::Railtie
        initializer "katalyst.basic.auth.configure_rack_middleware" do |app|
          middleware = Katalyst::Basic::Auth::Middleware
          if Rails::VERSION::MAJOR >= 4
            app.middleware.insert_before Rack::Sendfile, middleware
          else
            app.config.app_middleware.use middleware
          end
        end

        rake_tasks do
          path = File.expand_path(__dir__)
          Dir.glob("#{path}/tasks/**/*.rake").each { |f| load f }
        end
      end
    end
  end
end
