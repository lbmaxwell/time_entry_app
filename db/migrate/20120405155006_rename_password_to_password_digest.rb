class RenamePasswordToPasswordDigest < ActiveRecord::Migration
  def up
    change_table :users do |u|
      u.rename :password, :password_digest
    end
  end

  def down
  end
end
