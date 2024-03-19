module Admin
  module Developers
    class InvisiblizesController < ApplicationController
      def create
        developer = Developer.find(params[:developer_id])
        developer.toggle_visibility_and_notify!
        redirect_to developer_path(developer), notice: t(".created")
      end
    end
  end
end
