class DfeSignIn::User < ApplicationRecord
  def self.table_name
    "dfe_sign_in_users"
  end

  validates :given_name, presence: true
  validates :family_name, presence: true
  validates :email, presence: true
  validates :organisation_name, presence: true

  def full_name
    [given_name, family_name].join(" ")
  end
end
