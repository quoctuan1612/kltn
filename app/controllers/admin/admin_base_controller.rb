module Admin
  class AdminBaseController < ApplicationController
    # before_action :verify_manager!
    include Pundit

    layout "application_admin"
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

    # def verify_manager!
    #   return if current_user.manager?
    #   flash[:danger] = "Bạn không có quyền truy cập"
    #   redirect_back(fallback_location: root_path)
    # end

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path)
    end
  end
end
