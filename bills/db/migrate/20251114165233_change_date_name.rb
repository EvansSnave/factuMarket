class ChangeDateName < ActiveRecord::Migration[8.0]
  def change
    rename_column :bills, :date, :bill_date
  end
end
