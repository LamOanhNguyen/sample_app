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
  end
  # Add more helper methods to be used by all tests here...
end
