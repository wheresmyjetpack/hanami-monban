module Hanami::Monban
  module Auth
    private

    def authenticate!
      unless authenticated?
        login_warning || flash[:warning] = 'Please sign in'
        redirect_to sign_in_route || routes.sign_in_path
      end
    end

    def authenticated?
      !!current_user
    end

    def current_user
      @user_source ||= UserRepository.new
      @current_user ||= @user_source.find(session[:user_id])
    end

    def login(id)
      session[:user_id] = id
    end

    def logout(id)
      session[:user_id] = nil
    end

    def sign_in_route
      # no-op
    end

    def login_warning
      # no-op
    end
  end
end
