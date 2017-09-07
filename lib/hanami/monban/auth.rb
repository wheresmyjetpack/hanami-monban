require 'hanami/monban/skip_auth'
require 'hanami/monban/hashed_password'

module Hanami::Monban
  module Auth
    def self.included(controller)
      controller.class_eval do
        before :authenticate!

        def self.skip_auth
          include SkipAuth
        end
      end
    end

    private

    def authenticate!
      unless authenticated?
        login_warning || flash[:warning] = 'Please sign in'
        redirect_to sign_in_route
      end
    end

    def authenticated?
      !!current_user
    end

    def current_user
      @current_user ||= user_source.find(session[:user_id])
    end

    def login(user)
      session[:user_id] = user.id
    end

    def logout
      session[:user_id] = nil
    end

    def valid_password?(user)
      HashedPassword.from(user.password_hash) == params[:user][:password]
    end

    def sign_in_route
      routes.send(Hanami::Monban.configuration.sign_in_route)
    end

    def user_source
      @user_source ||= eval(Hanami::Monban.configuration.user_source.to_s).new
    end

    def login_warning
      # no-op
    end
  end
end
