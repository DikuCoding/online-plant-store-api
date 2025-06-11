class User < ApplicationRecord
  enum role: { user: 0, admin: 1 }
  has_one :cart, dependent: :destroy
  has_many :orders

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  def admin?
    role == 'admin'
  end 
end
