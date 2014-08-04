class UsersController < ApplicationController

  before_filter :require_login, :only => ['show', 'settings']

  def show
    @user = current_user
    @friends = current_user.get_friends
    @group = Group.new
  end

  def create
    verify_uri = URI('https://api.venmo.com/v1/oauth/access_token')
    verify_res = Net::HTTP.post_form(verify_uri, 'client_id' => 1843, 'client_secret' => "9wgWKHkzY5pLdcAbwJq3wqy7uEAFHzaR", 'code' => params[:code])
    user_json = JSON.parse verify_res.body


    if User.exists?(:venmo_id => user_json['user']['id'])
      user = User.where(venmo_id: user_json['user']['id']).first
      puts user.inspect
      session[:user_id] = user.id
      return redirect_to :action => :show, id: user.id
    else
      puts "DONT"
      puts user_json['user']['id']
      puts user_json['user']['id'].class.name
    end
    user_params = {
      :first_name => user_json['user']['first_name'],
      :last_name => user_json['user']['last_name'],
      :access_token => user_json['access_token'],
      :refresh_token => user_json['refresh_token'],
      :picture_url => user_json['user']['profile_picture_url'],
      :venmo_id => user_json['user']['id']
    }
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id 
      redirect_to :action => :show, id: user.id
    else
      flash[:error] = user.errors.full_messages
      redirect_to :controller => :welcome, :action => :index 
    end
  end

  def settings
    @user = current_user
  end
end
