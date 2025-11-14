class CreateBills < ActiveRecord::Migration[8.0]
  def change
    create_table :bills do |t|
      t.integer :user_id
      t.string :description
      t.integer :amount
      t.string :product
      t.date :date

      t.timestamps
    end
  end
end
