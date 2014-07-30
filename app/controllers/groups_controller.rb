class GroupsController < ApplicationController
  before_filter :require_login

  def create
    puts params.inspect
    friend_data = current_user.get_friends
    friend_json = JSON.parse friend_data
    group = Group.new(group_params)
    respond_to do |format|
      if group.save_with_venmoids(friend_json['data'])
        format.html { redirect_to '/' }
        format.js   {}
        # format.json { render json: group, status: :created, location: group }
      else
        # format.json { render json: group.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  def group_params
    puts "SFSDFS"
    puts params.inspect
    params.require(:group).permit(:name, :members)
  end
end
