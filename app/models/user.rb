class User < ActiveRecord::Base
  # Validations
  validates :access_token, presence: true
  validates :refresh_token, presence: true
  validates :venmo_id, presence: true, uniqueness: true
  validates :expires_in, presence: true
  validates :updated_at, presence: true

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

  def update_access_token_if_needed
    seconds_since_update = (Time.now - updated_at.localtime).to_i
    if seconds_since_update > expires_in
      begin
        resp = RestClient.post('https://api.venmo.com/v1/oauth/access_token', 'client_id' => 1843, 'client_secret' => "9wgWKHkzY5pLdcAbwJq3wqy7uEAFHzaR", 'refresh_token' => refresh_token);
        access_token = resp['access_token']
        expires_in = resp['expires_in']
        refresh_token = resp['refresh_token']
        updated_at = Time.now
      rescue RestClient::BadRequest
        puts RestClient::BadRequest.inspect
      end
    end
  end
end
