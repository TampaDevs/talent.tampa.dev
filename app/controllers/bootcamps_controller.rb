class BootcampsController < ApplicationController
  def show
    Analytics::Event.bootcamps_page_viewed(current_user, cookies)
  end
end
