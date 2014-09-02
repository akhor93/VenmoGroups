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
    friends_json = JSON.parse RestClient.get(url)
    friends_json['data']
  end

  def get_full_info
    JSON.parse(RestClient.get('https://api.venmo.com/v1/me?access_token=' + access_token))['data']
  end
end
