class SessionsController < ApplicationController
  def destroy
    reset_session
    redirect_to :controller => :welcome, :action => :index
  end
end
