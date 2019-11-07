class CreatePolicyConfigurations < ActiveRecord::Migration[5.2]
  def change
    create_table :policy_configurations, id: :uuid do |t|
      t.string :policy_class_name, null: false
      t.boolean :maintenance_mode, default: false, null: false
      t.string :maintenance_mode_availability_message

      t.timestamps

      t.index :policy_class_name, unique: true
    end
  end
end
