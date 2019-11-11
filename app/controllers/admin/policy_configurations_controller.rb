module Admin
  class PolicyConfigurationsController < BaseAdminController
    before_action :ensure_service_operator

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

    private

    def policy_configuration_params
      params.require(:policy_configuration).permit(:maintenance_mode_availability_message, :maintenance_mode).tap do |params|
        params[:maintenance_mode_availability_message] = nil if params[:maintenance_mode_availability_message].blank?
      end
    end
  end
end
