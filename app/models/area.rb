class Area < ApplicationRecord
  belongs_to :city
  belongs_to :basin
  belongs_to :user
end
