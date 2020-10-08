require 'brazilian_documents'

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_accessor :dont_send_email
  after_create :send_welcome_email
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :city

  has_many :reports, dependent: :destroy
  has_many :trades, dependent: :destroy
  has_many :areas, dependent: :destroy
  has_many :proposals, through: :areas, source: :trades, dependent: :destroy
  has_one_attached :photo

  validates :name, :phone_number, :address, :document_number, presence: true
  validate :document_valid

  private
  def document_valid
    errors.add(:document_number, 'Número do documento inválido.') unless BRDocuments::CPF.valid?(document_number) ||  BRDocuments::CNPJ.valid?(document_number)
  end

  def send_welcome_email
    unless dont_send_email
    UserMailer.with(user: self).welcome.deliver_now
    end
  end

end
