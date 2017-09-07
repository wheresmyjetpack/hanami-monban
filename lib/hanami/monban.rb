require "hanami/monban/version"

require 'hanami/monban/auth'
require 'hanami/monban/secure_password'

module Hanami
  module Monban
    def self.configure
      yield configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    private

    class Configuration
      def initialize
        @sign_in_route = :sign_in_path
        @user_source = :UserRepository
      end

      attr_accessor :sign_in_route, :user_source
    end
  end
end
