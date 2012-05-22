class ChangeTimeDataTypeForPaidTimeEntry < ActiveRecord::Migration
  def up
    change_table :paid_time_entries do |t|
      #t.change :time, :integer
      # PG::Error: ERROR:  column "time" cannot be cast to type integer

      #Had to manually make change in DB, b/c SQLite allowed the cast
      #postgres gave me the error above, so I commented all of this out
      #and ran the SQL directly below

      #ALTER TABLE paid_time_entries DROP COLUMN time;
      #ALTER TABLE paid_time_entries ADD COLUMN time INT;

    end
    #In retrospect, I should have just added the lines below

    #execute <<-SQL
    #ALTER TABLE paid_time_entries DROP COLUMN time;
    #ALTER TABLE paid_time_entries ADD COLUMN time INT;
    #SQL
  end

  def down
  end
end
