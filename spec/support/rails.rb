# frozen_string_literal: true

class DummyRailsEnv
  ENVIRONMENTS = %w[production development staging uat].freeze

  attr_accessor :value

  ENVIRONMENTS.each do |env|
    define_method("#{env}?") do
      value == env
    end
  end
end

class DummyRails
  module VERSION
    MAJOR = 4
  end

  class Application
    class << self
      def module_parent_name
        self
      end

      def parent_name
        self
      end

      def underscore
        "app"
      end
    end
  end

  class << self
    def application
      Application.new
    end
  end
end
