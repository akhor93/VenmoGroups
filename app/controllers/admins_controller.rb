class AdminsController < ApplicationController
  def index
    @users = User.all
    @groups = Group.all
    @transactions = Transaction.all
  end
end
