class Group < ActiveRecord::Base
  #Validations
  validates :name, presence: true

  #Associations
  belongs_to :user
end
