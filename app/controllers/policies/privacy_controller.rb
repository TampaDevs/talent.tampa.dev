module Policies
  class PrivacyController < ApplicationController
    def show
      Analytics::Event.privacy_page_viewed(current_user, cookies)
    end
  end
end
