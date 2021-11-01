class ReviewIntegration < ApplicationRecord
  belongs_to :user
  belongs_to :integration
  has_one :invoice, as: :invoiceable

  after_create :init_review_integration
  after_destroy :delete_review_integration

  private

  def init_review_integration
    Services::Review::SetupInsales.new(self).call
    update(ready: true)
  end

  def delete_review_integration
    Services::Review::DeleteInsales.new(self).call
  end
end
