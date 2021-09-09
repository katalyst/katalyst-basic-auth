# frozen_string_literal: true

module Katalyst
  module Basic
    module Auth
      class Middleware
        attr_reader :app

        def initialize(app)
          @app = app
        end

        def call(env)
          config = Config.for_path(env["PATH_INFO"])
          return @app.call(env) unless config.enabled?

          auth = Rack::Auth::Basic.new(app) do |u, p|
            u == config.username && p == config.password
          end
          auth.call env
        end
      end
    end
  end
end
