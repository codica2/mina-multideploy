require 'mina/multideploy/railtie'
require 'mina/multideploy/base_service'
require 'mina/multideploy/version'

module Mina
  module Multideploy
    class << self
      attr_accessor :configuration
    end

    def self.configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    class Configuration
      attr_accessor :servers, :original, :w_dir

      def initialize
        @servers = {}
        @original = 'config/deploy.rb'
        @w_dir = 'tmp/deploy'
      end
    end
  end
end
