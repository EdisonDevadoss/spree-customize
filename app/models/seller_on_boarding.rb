class SellerOnBoarding < ApplicationRecord
  belongs_to :user, class_name: 'Spree::User'

  STATUS = {
    started: :'in-progress',
    completed: :completed
  }

  def self.start(user_id)
   record = SellerOnBoarding.new(user_id: user_id, step: 1, status: STATUS[:started])
   record.save
  end
end
