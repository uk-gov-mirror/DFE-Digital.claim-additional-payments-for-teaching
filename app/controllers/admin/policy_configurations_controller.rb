module Admin
  class PolicyConfigurationsController < BaseAdminController
    before_action :ensure_service_operator
    helper_method :current_policy_routing_name, :claim_in_progress?

    def index
      @policy_configurations = PolicyConfiguration.order(:policy_class_name)
    end

    def edit
      @policy_configuration = PolicyConfiguration.find(params[:id])
    end

    def update
      policy_configuration = PolicyConfiguration.find(params[:id])
      policy_configuration.update!(policy_configuration_params)

      redirect_to admin_policy_configurations_url
    end

    def preview
      policy_configuration = PolicyConfiguration.find(params[:policy_configuration_id])
      @availability_message = params[:policy_configuration][:maintenance_mode_availability_message]
      flash.now[:warning] = "This is a preview of the availability message. You need to save your changes for this new message to take effect."
      render layout: 'application', template: 'static_pages/maintenance'
    end

    private

    def policy_configuration_params
      params.require(:policy_configuration).permit(:maintenance_mode_availability_message, :maintenance_mode).tap do |params|
        params[:maintenance_mode_availability_message] = nil if params[:maintenance_mode_availability_message].blank?
      end
    end

    def policy_configuration
      @policy_configuration ||= PolicyConfiguration.find(params[:policy_configuration_id])
    end

    def current_policy_routing_name
      policy_configuration.policy.routing_name
    end

    def claim_in_progress?
      false
    end
  end
end
