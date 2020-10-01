class Area < ApplicationRecord
  belongs_to :city
  belongs_to :basin
  belongs_to :user

  has_many :trades, dependent: :destroy

  include PgSearch::Model
  pg_search_scope :search_by_area_user_or_basin,
                  against: [:description],
                  associated_against: {
                    user: [ :name],
                    basin: [:name]
                  },
                  using: {
                  tsearch: { prefix: true }
                  }
                  
end
