class UsersController < ApplicationController

  before_filter :require_login, :only => ['show', 'settings']

  def show
    @user_id = current_user.id
    puts current_user.inspect
    @user = current_user.get_full_info
    @friends = current_user.get_friends
    @groups = current_user.groups
    @transactions = current_user.transactions
  end

  def create
    if params[:error]
      flash[:error] = "Please allow Boosted Payments to use Venmo on your behalf"
      return redirect_to :controller => :welcome, :action => :index 
    end
    user_json = JSON.parse(RestClient.post('https://api.venmo.com/v1/oauth/access_token', 'client_id' => 1843, 'client_secret' => "9wgWKHkzY5pLdcAbwJq3wqy7uEAFHzaR", 'code' => params[:code]))

    if User.exists?(:venmo_id => user_json['user']['id'])
      user = User.where(venmo_id: user_json['user']['id']).first
      session[:user_id] = user.id
      user.update_access_token_if_needed
      return redirect_to :action => :show, id: user.id
    end
    user_params = {
      :access_token => user_json['access_token'],
      :refresh_token => user_json['refresh_token'],
      :venmo_id => user_json['user']['id'],
      :expires_in => user_json['expires_in'],
      :updated_at => Time.now
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

end
