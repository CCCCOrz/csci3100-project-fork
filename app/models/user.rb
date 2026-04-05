class User < ApplicationRecord
  has_many :items, foreign_key: "seller_id"
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true, if: :password_present?

  def self.find_seller_id(name)
    find_by("name ILIKE ?", "%#{name}%").id
  end

  private
  
  def password_present?
    password.present?
  end
end
