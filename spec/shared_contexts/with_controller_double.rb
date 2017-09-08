require 'spec_helper'

shared_context 'with controller double' do
  let(:controller_double) do
    Class.new do
      def self.before(callback)
        callback
      end

      attr_accessor :params, :routes
      attr_writer :flash, :session

      def redirect_to(route)
        route
      end

      def session
        @session ||= {}
      end

      def flash
        @flash ||= {}
      end
    end
  end
end
