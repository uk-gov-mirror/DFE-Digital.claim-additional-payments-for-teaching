class PolicyConfiguration < ApplicationRecord
  validates :policy_class_name, inclusion: {in: Policies.all.map(&:name)}

  def policy
    policy_class_name.constantize
  end
end
