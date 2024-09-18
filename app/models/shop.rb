class Shop < ApplicationRecord
  belongs_to :user, class_name: 'Spree::User'
  has_one_attached :banner
  has_one_attached :logo

  validates :name, uniqueness: true, presence: true
  validates :language, presence: true
  validates :country, presence: true
  validates :currency, presence: true
  validates :user_id, uniqueness: true, presence: true
end
