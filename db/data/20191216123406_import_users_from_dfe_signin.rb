class ImportUsersFromDfeSignin < ActiveRecord::Migration[6.0]
  def up
    DfeSignIn::UserDataImporter.new.run
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
