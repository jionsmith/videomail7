class Admin::VideosController < Admin::BaseController
  def index
    @videos = current_account.videos.most_recent
  end

  def show
    @video = Video.find(params[:id])
    if @video.panda_video_id
      @h264_encoding = @video.encodings['h264']
      @ogg_encoding = @video.encodings['ogg']
    end

    render :preview, layout: false
  end

  def preview
    @video = Video.find(params[:id])
    if @video.panda_video_id
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
      flash[:success] = 'Video successfully created'
      redirect_to edit_admin_video_path(@video)
    else
      flash.now[:danger] = @video.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @video = current_account.videos.find(params[:id])
    @screenshots = @video.screenshots
  end

  def update
    @video = current_account.videos.find(params[:id])
    if @video.update_attributes(video_params)
      flash[:success] = 'Video successfully updated'
      redirect_to admin_videos_path
    else
      flash.now[:danger] = @video.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @video = current_account.videos.find(params[:id])
    @video.destroy
    respond_to do |format|
      format.js
      format.html{ redirect_to admin_videos_path }
    end
  end

  def refresh
    @video = current_account.videos.find(params[:id])
    @video.refresh

    redirect_to edit_admin_video_path(@video)
  end

  private

    def video_params
      params.require(:video).permit(:panda_video_id, :title, :screenshot, :stream_name)
    end
end
