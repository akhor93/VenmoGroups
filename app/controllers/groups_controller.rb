class GroupsController < ApplicationController
  before_filter :require_login

  def show
    @group = Group.find(params[:id])
    @user = current_user
    @members = Group.get_members(@group, @user)
    @transactions = Transaction.get_transactions_from_group(@group, @user)
  end

  def create
    @friends = current_user.get_friends
    @group = Group.new(group_params)
    @group.convert_members(@friends)
    @group.user_id = current_user.id
    respond_to do |format|
      if @group.save
        format.html { redirect_to '/' }
        format.js   {}
      else
        format.json { render json: group.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def group_params
    params.require(:group).permit(:name, :members)
  end
end
