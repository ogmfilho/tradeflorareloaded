class Trade < ApplicationRecord
  belongs_to :user
  belongs_to :area

  has_many :reviews, dependent: :destroy

  validates :status, inclusion: {
    in: ['Proposta', 'Visualizada', 'Aceita', 'Recusada', 'Concluída'],
    message: "%{value} não é um status válido."
  }
  validates :details, presence: true

  validates_associated :user
  validates_associated :area

end
