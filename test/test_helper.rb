ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
require "rails/test_help"

module ActiveSupport
  class TestCase
    fixtures :all
    def is_logged_in?
      !session[:user_id].nil?
    end
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    include ApplicationHelper
    fixtures :all
    def is_logged_in?
      !session[:user_id].nil?
    end

    def log_in_as user
      session[:user_id] = user.id
    end
  end

  class ActionDispatch::IntegrationTest
    def log_in_as user, password: "password", remember_me: "1"
      post login_path, params: {session: {email: user.email,
                                          password: password,
                                          remember_me: remember_me}}
    end
  end
end
