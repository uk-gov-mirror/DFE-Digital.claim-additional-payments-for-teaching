module Admin
  class BaseAdminController < ApplicationController
    ADMIN_TIMEOUT_LENGTH_IN_MINUTES = 2

    layout "admin"

    before_action :ensure_authenticated_user
    helper_method :service_operator_signed_in?

    private

    def timeout_in_minutes
      ADMIN_TIMEOUT_LENGTH_IN_MINUTES
    end

    def ensure_authenticated_user
      redirect_to admin_sign_in_path unless admin_signed_in?
    end

    def admin_session
      @admin_session ||= AdminSession.new(session[:user_id], session[:organisation_id], session[:role_codes])
    end

    def service_operator_signed_in?
      admin_session.is_service_operator?
    end

    def ensure_service_operator
      render "admin/auth/failure", status: :unauthorized unless service_operator_signed_in?
    end

    def end_expired_sessions
      if admin_session_timed_out?
        session.delete(:user_id)
        session.delete(:organisation_id)
        session.delete(:role_codes)
        flash[:notice] = "Your session has timed out due to inactivity, please sign-in again"
      end
    end

    def admin_session_timed_out?
      admin_signed_in? && session[:last_seen_at] < ADMIN_TIMEOUT_LENGTH_IN_MINUTES.minutes.ago
    end
  end
end
