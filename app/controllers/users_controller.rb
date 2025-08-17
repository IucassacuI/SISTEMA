class UsersController < ApplicationController
	allow_unauthenticated_access only: %i[new create]
	before_action :find_user, only: %i[show edit update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_sanitized)
		@user.admin = User.count == 0

    if @user.valid?
			@user.invite_code = SecureRandom.hex(5)
			@user.save validate: false

      flash[:notice] = 'Conta criada com sucesso.'
			redirect_to '/login'
		else
      @errors = @user.errors.full_messages
      render :new, status: :unprocessable_content
    end
  end

  def show
	end

  def edit
		if current_user != @user
      redirect_to root_path, status: :unauthorized
    end
	end

  def update
		if current_user != @user
      redirect_to root_path, status: :unauthorized
    end

		if @user.update(user_edit_sanitized.compact)
			redirect_to @user
		else
			@errors = @user.errors.full_messages
      render :edit, status: :unprocessable_content
    end
  end

  private

  def user_sanitized
    params.require(:user).permit(:email_address, :name, :password, :password_confirmation, :invite_code)
	end

  def user_edit_sanitized
		params.require(:user).permit(:email_address, :name, :password, :password_confirmation, :description)
	end

  def find_user
    @user = User.find(params[:id])
	end
end
