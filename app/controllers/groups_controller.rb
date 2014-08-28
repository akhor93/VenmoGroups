class GroupsController < ApplicationController
  before_filter :require_login

  def show
    @group = Group.find( params[:id] )
    respond_to do |format|
      format.html
      format.json { render json: @group }
    end
  end

  def create
    params[:group][:members] = params[:group][:members].to_s
    @group = Group.new(group_params)
    @group.user_id = current_user.id
    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        puts @group.errors.full_messages
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @group = Group.find(params[:id])
    params[:group][:members] = params[:group][:members].to_s
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render json: @group, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # TODO
  def destroy
    respond_to do |format|
      Group.destroy(params[:id])
      format.html { redirect_to current_user, notice: 'Group was deleted' }
      format.json { head :no_content }
    end
  end

  private
  def group_params
    params.require(:group).permit(:name, :members)
  end
end
