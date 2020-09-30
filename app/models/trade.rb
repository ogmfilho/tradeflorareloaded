class Trade < ApplicationRecord
  belongs_to :user
  belongs_to :area

  has_many :trades, dependent: :destroy

  validates :status, inclusion: {
    in: ['Proposta', 'Visualizada', 'Aceita', 'Recusada', 'Concluída'],
    message: "%{value} não é um status válido."
  }

  validates_associated :user
  validates_associated :area

end