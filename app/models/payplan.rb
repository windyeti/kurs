class Payplan < ApplicationRecord
  has_many :invoices
  validates :period, :price, presence: true

  def period_price
    "Тариф на <strong>#{period}</strong> за #{price} руб.".html_safe
  end

end
