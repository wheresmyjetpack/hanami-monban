require 'spec_helper'

describe Hanami::Monban::Auth do
  before do
    stub_const('HashedPassword', double('password hasher', from: 'password'))

    Hanami::Monban.configuration do |config|
      config.sign_in_route = sign_in_route
      config.user_source = user_source
    end
  end

  let(:sign_in_route) { :foo_path }
  let(:user_source) { :FooRepo }
  let(:controller_params) { {user: {password: 'password'}} }
  let(:app_routes) { spy('application routes object') }
  let(:controller_double) do
    Class.new do
      def self.before(callback)
        callback
      end

      def flash
        {}
      end

      def session
        {}
      end

      def redirect_to
        true
      end

      def params
        controller_params
      end

      def routes
        app_routes
      end
    end
  end

  let(:controller) { class_spy(controller_double) }

  context 'when included in a controller' do
    before { controller.include(described_class) }

    it 'sets up #authenticate! in a before hook' do
      expect(controller).to have_received(:before).with(:authenticate!)
    end

    describe 'the controller class' do
      subject { class_spy(controller_double.include(described_class)) }

      it { is_expected.to respond_to(:skip_auth) }
    end

    describe 'an instance of the controller' do
      subject { instance_spy(controller_double.include(described_class)) }

      it { is_expected.to respond_to(:authenticate!) }
      it { is_expected.to respond_to(:authenticated?) }
      it { is_expected.to respond_to(:current_user) }
      it { is_expected.to respond_to(:login) }
      it { is_expected.to respond_to(:logout) }
      it { is_expected.to respond_to(:valid_password?) }
    end
  end
end
