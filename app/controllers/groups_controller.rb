class GroupsController < ApplicationController
  before_filter :require_login

  def create
    @friends = current_user.get_friends
    @group = Group.new(group_params)
    @group.convert_members(@friends)
    @group.user_id = current_user.id
    respond_to do |format|
      if @group.save
        format.html { redirect_to '/' }
        format.js   {}
        # format.json { render json: group, status: :created, location: group }
      else
        puts group.errors
        # format.json { render json: group.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def group_params
    params.require(:group).permit(:name, :members)
  end
end
