class Invoice < ApplicationRecord
  belongs_to :user
  belongs_to :payplan
  belongs_to :invoiceable, polymorphic: true
end
