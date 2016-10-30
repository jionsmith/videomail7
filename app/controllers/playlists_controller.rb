class PlaylistsController < ApplicationController
  skip_before_action :authenticate_account!, only: [:show]
  before_filter :set_playlist, only: [:edit, :update, :destroy, :add_video, :remove_video]
  before_filter :set_videos, only: [:edit, :update]

  before_filter except: :show do
    unless current_account.can_use_video_playlist?
      redirect_to root_path, notice: 'Upgrade your plan to use video playlists'
      false
    end
  end

  def index
    @playlists = current_account.playlists.page(params[:page])
  end

  def show
    @playlist = Playlist.find(params[:id])
    @playlist.videos ||= []

    # Token access
    unless @playlist.is_accessible?(current_account, params[:token])
      flash[:alert] = 'Access denied'

      if current_account
        redirect_to root_path
      else
        redirect_to new_account_session_path
      end
    else
      @message = @playlist.messages.by_token(params[:token]).first
      if !@message.blank?
        @template = @message.template
        @message.read_by!(params[:email]) if !params[:email].blank?
        render 'show', layout:'email'
      end
    end
  end

  def new
    @playlist = current_account.playlists.build
  end

  def create
    @playlist = current_account.playlists.build(playlist_params)
    if @playlist.save
      redirect_to edit_playlist_path(@playlist), flash: { success: 'Playlist created successfully' }
    else
      flash.now[:danger] = @playlist.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @playlist = current_account.playlists.find(params[:id])
  end

  def update
    @playlist = current_account.playlists.find(params[:id])

    if @playlist.update_attributes(playlist_params)
      redirect_to edit_playlist_path(@playlist), flash: { success: 'Playlist updated successfully' }
    else
      flash.now[:danger] = @playlist.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @playlist.destroy
    redirect_to playlists_path
  end

  def add_video
    @video = current_account.videos.find(params[:video_id])
    @playlist.videos ||= []
    @playlist.videos << @video if !@playlist.videos.include?(@video)
    @playlist.save

    redirect_to edit_playlist_path(@playlist)
  end

  def remove_video
    @video = @playlist.videos.find(params[:video_id])
    @playlist.videos.destroy(@video)
    redirect_to edit_playlist_path(@playlist)
  end

  def selection
    index
    render 'selection', layout: false
  end

  private

  def playlist_params
    params.require(:playlist).permit(:title, :description, :outro_text)
  end

  def set_playlist
    @playlist = current_account.playlists.find(params[:id])
    @playlist.videos ||= []
  end

  def set_videos
    ids_to_exclude = @playlist.videos.map(&:id)
    @videos = current_account.videos.where.not(id: ids_to_exclude).page(params[:page])
  end
end
