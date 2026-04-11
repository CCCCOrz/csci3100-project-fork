class User < ApplicationRecord
  has_many :items, foreign_key: "seller_id"

  has_many :favorites, dependent: :destroy
  has_many :favorite_items, through: :favorites, source: :item
  
  has_secure_password

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true, if: :password_present?

  def self.find_seller_id(name)
    clean_name = name.to_s.strip
    user = find_by("name ILIKE ?", "%#{clean_name}%")
    user&.id
  end


  def generate_password_reset_code!
    self.password_reset_code = rand(100000..999999).to_s
    self.password_reset_expires_at = 1.hour.from_now # datetime()
    save!
  end

  def clear_password_reset_code!
    self.password_reset_code = nil
    self.password_reset_expires_at = nil
    save!
  end

  private

  def password_present?
    password.present?
  end
end
