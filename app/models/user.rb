class User < ActiveRecord::Base
  #Accessors
  attr_accessor :friends

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :access_token, presence: true
  validates :refresh_token, presence: true
  validates :venmo_id, presence: true#, uniqueness: true

  #Associations
  has_many :groups, dependent: :destroy

  #Methods
  def get_friends
    #use obscenely high limit to get all friends in one page
    url = 'https://api.venmo.com/v1/users/' + venmo_id + '/friends?limit=1000&access_token=' + access_token
    friends_uri = URI(url)
    friends_res = Net::HTTP.get(friends_uri)
    return friends_res

    # url = 'https://api.venmo.com/v1/users/' + venmo_id + '/friends?access_token=' + access_token
    # friends = []
    # counter = 0
    # begin
    #   friends_uri = URI(url)
    #   friends_res = Net::HTTP.get(friends_uri)
    #   friends_json = JSON.parse friends_res
    #   friends << friends_json['data']
    #   if url == friends_json['pagination']['next']
    #     break
    #   end
    #   url = friends_json['pagination']['next'] + '&access_token=' + access_token
    #   puts url
    #   counter += 1
    # end while friends_json['pagination'] || counter == 10
    # return friends
  end

  #Virtual Attributes
  #Getter
  def full_name
    [first_name, last_name].join(' ')
  end

  #Setter
  def full_name=(name)
    split = name.split(' ', 2)
    self.first_name = split.first
    self.last_name = split.last
  end
end
