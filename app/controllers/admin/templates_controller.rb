class Admin::TemplatesController < Admin::BaseController
  before_filter :load_template, only: [:edit, :update, :destroy]

  def index
    @templates = Template.by_title
  end

  def show
    @template = Template.includes(:video).find(params[:id])
    render layout: false
  end

  def new
    @template = Template.new
    @template.build_product
    @videos = current_account.videos.encoded
  end

  def create
    @template = Template.new(template_params)
    @template.author_account = current_account
    if @template.save
      flash[:success] = 'Template successfully created'
      redirect_to edit_admin_template_path(@template)
    else
      flash.now[:danger] = @template.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @template.build_product unless @template.product
    @videos = current_account.videos
  end

  def update
    if @template.update(template_params)
      flash.now[:success] = 'Template successfully updated'
    else
      flash.now[:danger] = 'Template update failed'
    end
    render 'edit'
  end

  def destroy
    if @template.product.accounts.empty?
      @template.destroy
      flash[:success] = 'Template is deleted successfully.'
    else
      flash[:alert] = 'We could not delete the template because some users use that template.'
    end
    redirect_to admin_templates_path
  end

  private

  def template_params
    params.require(:template).permit(
      :title, :css, :video_id, :text_example, :premium_template,
      :content_file, :content_file_cache,
      :preview_image, :preview_image_cache, :remove_preview_image,
      template_images_attributes: [:id, :image_name, :image_file, :image_file_cache, :_destroy],
      product_attributes: [:price, :status]
    )
  end

  def load_template
    @template = Template.find(params[:id])
  end
end
