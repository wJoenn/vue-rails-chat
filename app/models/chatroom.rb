class Chatroom < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
