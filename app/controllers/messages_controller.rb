class MessagesController < ApplicationController
  before_action :find_msg, :authorize, only: %i[edit update destroy]

  def index
    @messages = Message.all
    @msg = Message.new

    render :index
  end

  def create
    @msg = Message.new(message_sanitized)

    if @msg.save && Message.count > 10
      Message.first.destroy
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to "/chat/" }
    end
  end

  def edit
  end

  def update
    if @msg.update(message_sanitized)
      redirect_to "/messages/"
    else
      @errors = @msg.errors.full_messages
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @msg.destroy
    redirect_to "/messages/"
  end

   private

  def message_sanitized
    params.require(:message).permit(:text, :user_id)
  end

  def find_msg
    @msg = Message.find(params[:id])
  end

  def authorize
    if current_user != @msg.user && !current_user.admin
      redirect_to "/chat", status: :unauthorized
    end
  end
end
