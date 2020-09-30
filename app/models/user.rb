class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reviews
  has_many :trades, dependent: :destroy
  has_many :areas, dependent: :destroy

  validates :name, :document_number, :phone_number, :address, presence: true
end
