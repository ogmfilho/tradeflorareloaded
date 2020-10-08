class Trade < ApplicationRecord
  belongs_to :user
  belongs_to :area

  has_many :reports, dependent: :destroy

  validates :status, inclusion: {
    in: ['Enviada pelo proponente', 'Aceita', 'Recusada'],
    message: "%{value} não é um status válido."
  }
  validates :details, presence: true

  validates_associated :user
  validates_associated :area

end
