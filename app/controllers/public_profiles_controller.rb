class PublicProfilesController < ApplicationController
  before_action :authenticate_user!

  def new
    @developer = developer
    authorize @developer, :share_profile?
  end

  private

  def developer
    Developer.find_by_hashid!(params[:developer_id])
    Analytics::Event.developer_public_profile_viewed(current_user, cookies, params[:developer_id])
  end
end
