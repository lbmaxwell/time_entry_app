class RenamePasswordToPasswordDigest < ActiveRecord::Migration
  def up
#    change_table :users do |u|
#      u.rename :password, :password_digest
       add_column :users, :password_digest, :string
  end

  def down
  end
end
