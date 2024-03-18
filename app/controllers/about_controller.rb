class AboutController < ApplicationController
  def show
    Analytics::Event.about_page_viewed(current_user, cookies)
  end
end
