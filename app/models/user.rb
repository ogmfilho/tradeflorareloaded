require 'brazilian_documents'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :city

  has_many :reports, dependent: :destroy
  has_many :trades, dependent: :destroy
  has_many :areas, dependent: :destroy
  has_many :proposals, through: :areas, source: :trades, dependent: :destroy

  validates :name, :phone_number, :address, :document_number, presence: true
  validate :document_valid

  private
  def document_valid
    errors.add(:document_number, 'Número do documento inválido.') unless BRDocuments::CPF.valid?(document_number) ||  BRDocuments::CNPJ.valid?(document_number)
  end

end
