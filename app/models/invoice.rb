class Invoice < ApplicationRecord
  belongs_to :user
  belongs_to :payplan
  belongs_to :invoiceable, polymorphic: true
  has_one :payment, dependent: :destroy
end
