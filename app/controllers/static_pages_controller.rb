class StaticPagesController < BasePublicController
  def accessibility_statement
  end

  def contact_us
  end

  def cookies
  end

  def privacy_notice
  end

  def terms_conditions
  end

  def maintenance
    policy = Policies[params[:policy]]
    policy_configuration = PolicyConfiguration.find_by(policy_class_name: policy.name)
    @availability_message = policy_configuration.maintenance_mode_availability_message

    render status: :service_unavailable
  end

  private

  def current_policy_routing_name
    super || "student-loans"
  end
end
