class CreateStudentLoansPolicyConfiguration < ActiveRecord::Migration[5.2]
  def up
    PolicyConfiguration.create!(policy_class_name: "StudentLoans")
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
