class Integration < ApplicationRecord
  belongs_to :user
  has_one :review_integration, dependent: :destroy
end
