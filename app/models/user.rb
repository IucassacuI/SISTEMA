class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :messages, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name, presence: true, uniqueness: true
  validates :description, length: { maximum: 500 }
  validate :valid_invite_code?

  def valid_invite_code?
     if !User.exists?({ invite_code: invite_code })
      errors.add(:invite_code, "inválido.")
     end
  end
end
