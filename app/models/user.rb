class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # :recoverable, :rememberable
  devise :database_authenticatable,
    :registerable,
    :validatable,
    :jwt_authenticatable,
    jwt_revocation_strategy: JwtDenylist

  validates :username, presence: true, uniqueness: true
  validates :email, format: { with: /\A[\w\d]+(?:[._-]?[\w\d]+)*@[\w\d]+(?:[.-]?[\w\d]+)*(?:\.\w{2,})+\z/ }
end
