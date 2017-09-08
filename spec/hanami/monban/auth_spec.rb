require 'spec_helper'
require 'shared_contexts/with_controller_double'

describe Hanami::Monban::Auth do
  include_context 'with controller double'

  before do
    stub_const('UserRepository', double('the user source constant', new: user_source))
  end

  let(:sign_in_route) { :foo_path }
  let(:user_source) { :FooRepo }
  let(:controller_params) { {user: {password: 'password'}} }
  let(:app_routes) { spy('the application routes object') }
  let(:user_source) {spy('user source', find: logged_in_user)}
  let(:logged_in_user) { nil }
  let(:controller_with_auth) { controller_double.include(described_class) }
  let(:controller) { class_spy(controller_double) }

  context 'when included in a controller' do
    before { controller.include(described_class) }

    it 'sets up #authenticate! in a before hook' do
      expect(controller).to have_received(:before).with(:authenticate!)
    end

    describe 'the controller class' do
      subject { class_spy(controller_with_auth) }

      it { is_expected.to respond_to(:skip_auth) }
    end

    describe 'an instance of the controller' do
      subject { instance_spy(controller_with_auth) }

      it { is_expected.to respond_to(:authenticate!) }
      it { is_expected.to respond_to(:authenticated?) }
      it { is_expected.to respond_to(:current_user) }
      it { is_expected.to respond_to(:login) }
      it { is_expected.to respond_to(:logout) }
      it { is_expected.to respond_to(:valid_password?) }
    end

    describe '#authenticate!' do
      before do
        controller_with_auth.new.tap do |dbl|
          dbl.params = controller_params
          dbl.routes = app_routes
          dbl.authenticate!
        end
      end

      context 'when a user is not logged in' do
        describe 'the routes schema' do
          subject { app_routes }

          it { is_expected.to have_received(:sign_in_path) }
        end
      end
    end

    describe '#authenticated?' do
      subject { controller_with_auth.new.authenticated? }

      context 'when there is a current user' do
        let(:logged_in_user) { :user }
        it { is_expected.to be(true) }
      end

      context 'when there is no current user' do
        it { is_expected.to be(false) }
      end
    end

    describe '#current_user' do
      subject { controller_with_auth.new.current_user }

      context 'if the user is not logged in' do
        it { is_expected.to be_nil }
      end

      context 'if the user is logged in' do
        let(:logged_in_user) { :user_entity }
        it { is_expected.to be(logged_in_user) }
      end
    end

    describe '#login' do
      before do
        @controller = controller_with_auth.new
        @controller.login(user)
      end

      let(:user) { double('a user', id: 1) }

      it 'sets the session for the user' do
        expect(@controller.session[:user_id]).to eq(user.id)
      end
    end

    describe '#logout' do
      before do
        @controller = controller_with_auth.new
        @controller.login(user)
        @controller.logout
      end

      let(:user) { double('a user', id: 1) }

      it 'expires the session for the user' do
        expect(@controller.session[:user_id]).to be_nil
      end
    end

    describe '#valid_password?' do
      before do
        stub_const('Hanami::Monban::HashedPassword', double('password hasher', from: 'password'))
        @controller = controller_with_auth.new.tap do |dbl|
          dbl.params = controller_params
        end
      end

      let(:user) { double('a user', password_hash: 'a hashed password') }
      subject { @controller.valid_password?(user) }

      context 'when the passwords match' do
        it { is_expected.to be(true) }
      end

      context 'when the passwords do not match' do
        let(:controller_params) { {user: {password: 'bad password'}} }
        it { is_expected.to be(false) }
      end

      describe 'the user entity' do
        before { @controller.valid_password?(user) }
        subject { user }
        it { is_expected.to have_received(:password_hash) }
      end
    end
  end
end
