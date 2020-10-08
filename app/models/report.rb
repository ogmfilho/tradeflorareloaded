class Report < ApplicationRecord
  belongs_to :trade
  belongs_to :user

  validates :content, presence: true
  has_many_attached :photos
end
