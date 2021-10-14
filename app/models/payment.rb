class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :invoice
  belongs_to :payplan

  after_update :change_invoice

  private

  def change_invoice
    invoice.update(status: 'Оплачен') if status == 'Оплачен'
  end
end
