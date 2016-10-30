class MessagesController < ApplicationController
  before_filter :set_message, only: [:deliver, :edit, :update, :destroy, :show, :clone, :preview, :statistics]

  before_filter only: [:new, :create, :clone] do
    unless current_account.can_create_message?
      redirect_to messages_path, notice: 'Upgrade your plan to create more videomails'
      false
    end
  end

  def index
    status = params[:status]
    status ||= 'all'
    set_tab status
    @messages = current_account.messages_in_status(params[:status]).order('updated_at desc').page(params[:page])

    unless params[:statistics].blank?
      set_tab :statistics
      render :index_with_statistics
    end
  end

  def show
    @video = @message.video
    @playlist = @message.playlist
    @template = @message.template
    @back = true

    if !@video.blank?
      render 'videos/show', layout: 'email'
    elsif !@playlist.blank?
      render 'playlists/show', layout: 'email'
    end
  end

  def new
    @message = current_account.messages.build
    @message.template = Template.default_templates.first

    if params[:video_id].present?
      @message.video = current_account.videos.encoded.find_by_id(params[:video_id])
      @message.play = 'video'
    elsif params[:playlist_id].present?
      @message.playlist = current_account.playlists.find_by_id(params[:playlist_id])
      @message.play = 'list'
    end

    load_data
  end

  def create
    @message = current_account.messages.build(message_params)
    if @message.save
      flash[:success] = 'Message successfully created'

      if params[:commit] == 'Send'
        @message.deliver
        if !@message.delayed_email?
          flash[:success] = 'Message successfully sent'
        else
          flash[:success] = "Message will send at #{@message.send_at}"
        end
      end

      redirect_to edit_message_path(@message)
    else
      load_data

      flash.now[:danger] = @message.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    load_data
  end

  def update
    if @message.update_attributes(message_params)
      flash[:success] = 'Message updated successfully'
      if params[:commit] == 'Send'
        @message.deliver
        if !@message.delayed_email?
          flash[:success] = 'Message sent successfully'
        else
          flash[:success] = "Message will be sent at #{@message.send_at}"
        end
      end
      redirect_to edit_message_path(@message)
    else
      flash[:danger] = @message.errors.full_messages.to_sentence
      redirect_to edit_message_path(@message)
    end
  end

  def destroy
    @message.destroy
    redirect_to messages_path
  end

  def destroy_multiple
    params[:messages].each do |message_id|
      current_account.messages.find(message_id).destroy
    end

    flash[:success] = 'Messages deleted successfully'
    redirect_to messages_path
  end

  def restore_multiple
    params[:messages].each do |message_id|
      current_account.messages.with_deleted.find(message_id).restore
    end

    flash[:success] = 'Messages deleted successfully'
    redirect_to messages_path
  end

  def really_destroy_multiple
    params[:messages].each do |message_id|
      current_account.messages.with_deleted.find(message_id).really_destroy!
    end

    flash[:success] = 'Messages deleted permanently'
    redirect_to messages_path(status: 'trash')
  end
  
  def preview
    @video = @message.video
    @template = @message.template
    @playlist = @message.playlist
    @back = true
    render layout:'layouts/email'
  end

  def statistics
    render layout: false
  end

  def deliver
    if @message.valid?
      @message.deliver_now
      flash[:success] = 'Message successfully sent.'
      redirect_to messages_path
    else
      flash[:danger] = "Sorry, couldn't send email now"
      redirect_to edit_message_path(@message)
    end
  end

  def clone
    @message = @message.clone_message

    flash[:success] = 'Message successfully cloned'
    redirect_to edit_message_path(@message)
  end

  #TODO
  def contacts
    head :ok
  end

  private

  def load_data
    @templates = current_account.templates
    @videos = current_account.videos.encoded
    @playlists = current_account.playlists
  end

  def message_params
    attrs = [:subject, :text, :template_id, :message_id, :account_id, :video_id, :send_at, :email_type, :emails, :downloadable]

    if current_account.can_use_video_playlist?
      attrs += [:playlist_id, :play]
    end

    params.require(:message).permit(*attrs)
  end

  def set_message
    @message = current_account.messages.find(params[:id])
  end
end
