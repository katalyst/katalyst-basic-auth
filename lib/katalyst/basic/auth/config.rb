# frozen_string_literal: true

require "digest"

module Katalyst
  module Basic
    module Auth
      class Config
        DEFAULT_USERNAME = "katalyst"
        ROOT_PATH        = "/"

        class << self
          include Enumerable

          # @param path [String] Request path
          # @return [Config] The config for the given path
          def for_path(path)
            path ||= ROOT_PATH
            all.sort_by(&:path)
               .reverse
               .detect { |i| path.match(/^#{i.path}/) } || global
          end

          # @return [Config] The global configuration
          def global
            all[0]
          end

          def add(path:, username: nil, password: nil, enabled: nil)
            config = Config.new(path: path, username: username, password: password, enabled: enabled)
            all.delete(all.detect { |i| i.path == config.path })
            all << config
            config
          end

          def all
            @all ||= [Config.new]
          end

          def reset!
            @all = [Config.new]
          end

          def each(&block)
            all.each(&block)
          end

          def description
            output = ["Basic auth settings:", ""]
            all.each do |config|
              output << "path:     #{config.root_path? ? "(global)" : config.path}"
              output << "enabled:  #{config.enabled?}"
              output << "username: #{config.username}"
              output << "password: #{config.password}"
              output << ""
            end
            output.join("\n")
          end

          def enabled?
            global_enabled = ENV.fetch("KATALYST_BASIC_AUTH_ENABLED", enabled_rails_env?)
            [true, "yes", "true"].include?(global_enabled)
          end

          def enabled_rails_env?
            return false unless rails?

            Rails.env.staging? || Rails.env.uat?
          end

          def rails?
            defined?(Rails)
          end

          def default_username
            return ENV["KATALYST_BASIC_AUTH_USER"] if ENV["KATALYST_BASIC_AUTH_USER"]
            return DEFAULT_USERNAME unless rails?

            if Rails::VERSION::MAJOR >= 6
              Rails.application.class.module_parent_name.underscore
            else
              Rails.application.class.parent_name.underscore
            end
          end

          def default_password(username)
            return ENV["KATALYST_BASIC_AUTH_PASS"] if ENV["KATALYST_BASIC_AUTH_PASS"]

            Digest::SHA256.hexdigest("#{default_password_salt}#{username}")[0..15]
          end

          def default_password_salt
            if rails? && Rails.application.respond_to?(:secret_key_base)
              Rails.application.secret_key_base
            else
              ENV["SECRET_KEY_BASE"]
            end
          end
        end

        attr_reader :path, :username, :password

        def enabled?
          @enabled
        end

        def root_path?
          path == ROOT_PATH
        end

        private

        def initialize(path: nil, username: nil, password: nil, enabled: nil)
          @path     = sanitize_path(path)
          @username = username || self.class.default_username
          @password = password || self.class.default_password(@username)
          @enabled  = enabled.nil? ? (!root_path? || self.class.enabled?) : enabled
        end

        def sanitize_path(path)
          return ROOT_PATH if path.nil?

          path = "/#{path}" unless path.start_with?("/")
          path
        end
      end
    end
  end
end
