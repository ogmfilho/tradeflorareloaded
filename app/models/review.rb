class Review < ApplicationRecord
  belongs_to :trade
  belongs_to :user
end
