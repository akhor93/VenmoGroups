class Group < ActiveRecord::Base
  #Validations
  validates :name, presence: true
  validates :members, presence: true

  #Associations
  belongs_to :user

  #Custom Save
  #Need to change display names to venmo_ids
  def save_with_venmoids(friends)
    if new_record?
      names = members.split(', ')
      names.reject! { |n| n.empty? }
      (0..names.length-1).each do |i|
        (0..friends.length-1).each do |j|
          if friends[j]['display_name'] == name[i]
            break
          end
          #No match found. Should not happen
          if j == friends.length
            return false
          end
        end
      end
      return true
    else
      return false
    end
  end
end
