require 'brazilian_documents'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reviews
  has_many :trades, dependent: :destroy
  has_many :areas, dependent: :destroy
  
  validates :name, :phone_number, :address, presence: true
  validates :document_number, presence: true, if: :document_valid?

  def document_valid?
    BRDocuments::CPF.valid?(:document_number) ||  BRDocuments::CNPJ.valid?(:document_number)
  end

end
