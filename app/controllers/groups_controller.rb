class GroupsController < ApplicationController
	before_action :prevent_hack

	def show
		@group = Group.find(params[:group_id])
	end

	def create
		if Group.find_by({:name => group_params[:name]}) != nil
	      flash[:error] = "Group name already exists. Please try again"
	    else
	      @group = Group.new(group_params)
	      @group.manager_ids << current_user.id
	      @group.users << current_user
	      @group.save
	      flash[:success] = "Group created: #{@group.name}!"
	    end
	    redirect_to user_path(current_user.id)
	end

	def join
		join_group = Group.find_by({:name => group_params[:name]})
		has_group = (join_group != nil)
		join_group != nil ? has_correct_passcode = join_group.passcode == group_params[:passcode] : has_correct_passcode = false
		if has_group && has_correct_passcode
			if current_user.groups.include?(join_group)
				flash[:notice] = "You're already inside group #{join_group.name}!"
				redirect_to user_path(current_user.id)
				return
			end	
			join_group.users << current_user
      flash[:success] = "Joined group: #{join_group.name}!"
      redirect_to user_path(current_user.id)
    else
      flash[:error] = "Cannot find group name #{group_params[:name]} or incorrect passcode! (note that group names are case sensitive)"
	    redirect_to user_path(current_user.id)
    end
	end

	def destroy
		if current_user != nil
			@group = Group.find(params[:group_id])
			flash[:notice] = "#{@group.name} has been deleted"
			@group.destroy
			redirect_to user_path(current_user.id)
		end
	end

	private
  def group_params
    params.require(:group).permit(:name, :passcode)
  end
end
