class HomeController < ApplicationController
  def show
    @developers = Developer
      .visible
      .includes(:role_type).with_attached_avatar
      .actively_looking.newest_first
      .limit(10)
    Analytics::Event.home_page_viewed(current_user, cookies)
  end
end
