class VideosController < ApplicationController
  skip_before_action :authenticate_account!, only: [:show, :download]
  before_filter :restrict_access_by_token, only: [:show, :download] 
  before_filter :set_video, only: [:preview, :edit, :update, :refresh, :destroy]

  def index
    @videos = current_account.videos.most_recent.page(params[:page])
  end

  def show
    if @video.encoded
      @h264_encoding = @video.encodings['h264']
      @ogg_encoding = @video.encodings['ogg']
    end

    @message = @video.messages.by_token(params[:token]).first
    if !@message.blank?
      @template = @message.template
      @message.read_by!(params[:email]) if !params[:email].blank?
      render 'show', layout:'email'
    end
  end

  def download
    redirect_to @video.download_url if @video.encoded
  end

  def preview
    if @video.encoded
      @h264_encoding = @video.encodings['h264']
      @ogg_encoding = @video.encodings['ogg']
    end
  end

  def new
    @video = current_account.videos.build
  end

  def create
    @video = current_account.videos.build(video_params)
    if @video.save
      flash[:success] = 'Video created successfully'
      redirect_to edit_video_path(@video)
    else
      flash.now[:danger] = @video.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @screenshots = @video.screenshots
  end

  def update
    @video = current_account.videos.find(params[:id])
    if @video.update_attributes(video_params)
      flash[:success] = 'Video updated successfully'
      redirect_to videos_path
    else
      flash.now[:danger] = @video.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if @video.messages.blank?
      @video.destroy
      flash[:success] = 'Video destroyed successfully'
    else
      flash[:alert] = "Sorry, couldn't destroy video, because its in use"
    end
    redirect_to videos_path
  end

  def refresh
    @video.refresh

    redirect_to edit_admin_video_path(@video)
  end

  def selection
    index
    render 'selection', layout: false
  end

  private

  def video_params
    params.require(:video).permit(:panda_video_id, :title, :screenshot, :stream_name)
  end

  def set_video
    @video = current_account.videos.find(params[:id])
  end

  def restrict_access_by_token
    @video = Video.find(params[:id])
    unless @video.is_accessible?(current_account, params[:token])
      flash[:alert] = 'Access denied'
      if current_account
        redirect_to root_path
      else
        redirect_to new_account_session_path
      end
    end
  end
end
