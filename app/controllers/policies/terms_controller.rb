module Policies
  class TermsController < ApplicationController
    def show
      Analytics::Event.tos_page_viewed(current_user, cookies)
    end
  end
end
