class User < ActiveRecord::Base
  # Validations
  validates :access_token, presence: true
  validates :refresh_token, presence: true
  validates :venmo_id, presence: true, uniqueness: true

  #Associations
  has_many :groups, dependent: :destroy
  has_many :transactions, dependent: :destroy

  #Methods
  def get_friends
    #use obscenely high limit to get all friends in one page
    url = 'https://api.venmo.com/v1/users/' + venmo_id + '/friends?limit=2000&access_token=' + access_token
    friends_uri = URI(url)
    friends_res = Net::HTTP.get(friends_uri)
    friends_json = JSON.parse friends_res
    friends_json['data']
  end

  def get_full_info
    uri = URI('https://api.venmo.com/v1/me?access_token=' + access_token)
    JSON.parse(Net::HTTP.get(uri))['data']
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
