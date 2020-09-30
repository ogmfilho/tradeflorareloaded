class Area < ApplicationRecord
  belongs_to :cities
  belongs_to :basin
  belongs_to :user
end
