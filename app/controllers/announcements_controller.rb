class AnnouncementsController < ApplicationController
	before_action :only_allow_admin, only: %i[new create edit update destroy]
	before_action :find_announcement, only: %i[edit update destroy]

  def new
		@announcement = Announcement.new
  end

  def index
		@announcements = Announcement.all.reverse
  end

  def create
		@announcement = Announcement.new(announcement_sanitized)

    if @announcement.save
      redirect_to root_path
		else
      @errors = @announcement.errors.full_messages
      render :new, status: :unprocessable_content
    end
  end

	def edit
	end

  def update
    if @announcement.update(announcement_sanitized)
			redirect_to root_path
    else
      @errors = @announcement.errors.full_messages
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @announcement.destroy
		redirect_to root_path
  end

  private

  def announcement_sanitized
    params.require(:announcement).permit(:text)
	end

  def only_allow_admin
		unless current_user.admin
      redirect_to root_path, status: :unauthorized
    end
 	end

  def find_announcement
    @announcement = Announcement.find(params[:id])
	end
end
