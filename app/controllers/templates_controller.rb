class TemplatesController < ApplicationController
  before_filter :set_category, only: [:index, :available]
  before_filter :set_template, only: [:show, :preview, :remove]

  def index
    @templates = current_account.my_templates
    if @category
      @templates = @templates.by_category(@category)
    end
    @templates = @templates.page(params[:page])
  end

  def available
    @templates = current_account.available_templates
    if @category
      @templates = @templates.by_category(@category)
    end
    @templates = @templates.page(params[:page])
  end

  def selection
    index
    render layout: false
  end

  def preview
    @related_products = @template.related_products
    render layout: false
  end

  def show
    @template = Template.includes(:video).find(params[:id])
    render layout: false
  end

  def remove
    current_account.templates.destroy(@template)
    flash[:success] = "Template removed successfully"
    redirect_to templates_path
  end

  private

  def set_category
    @category = Category.find(params[:category_id]) if !params[:category_id].blank?
  end

  def set_template
    @template = Template.find(params[:id])
  end
end
