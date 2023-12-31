module Admin
    module Businesses
      class JobPostsController < ApplicationController
        def index
          @forms = ::Businesses::JobPost.includes(:business).order(created_at: :desc)
        end
  
        def show
          @form = ::Businesses::JobPost.find(params[:id])
        end
      end
    end
  end
  