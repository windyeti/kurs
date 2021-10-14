class Invoice < ApplicationRecord
  belongs_to :user
  belongs_to :payplan
  belongs_to :invoiceable, polymorphic: true
  has_one :payment, dependent: :destroy

  after_update :change_invoiceable

  private

  def change_invoiceable
    invoiceable.update(status: true) if status == 'Оплачен'
  end
end
