# frozen_string_literal: true

require_relative "auth/version"
require_relative "auth/config"
require_relative "auth/middleware"
require_relative "auth/rails" if defined?(Rails)

module Katalyst
  module Basic
    module Auth
      class << self
        # Add a path to be protected by basic authentication
        def add(path, username: nil, password: nil)
          Config.add(path: path, username: username, password: password)
        end

        # Add a path to be excluded from basic authentication
        def exclude(path)
          Config.add(path: path, enabled: false)
        end
      end
    end
  end
end
