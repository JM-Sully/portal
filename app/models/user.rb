# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  encrypts :first_name, :last_name
  encrypts :email, deterministic: true

  validates :first_name, :last_name, :email, presence: true

  has_many :orders, dependent: :destroy
end
