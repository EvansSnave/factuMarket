class Bill < ApplicationRecord
  validates :user_id, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :bill_date, presence: true
end
