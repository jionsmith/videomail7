class Admin::CategoriesController < Admin::BaseController
  before_filter :load_categories

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    if category_params[:default]
      Category.update_all(default: false)
    end

    @category = Category.find(params[:id])
    if @category.update_attributes(category_params)
      flash[:success] = "Category successfully updated."
      redirect_to edit_admin_category_path(@category)
    else
      flash.now[:danger] = @category.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:success] = "Category successfully deleted."
    redirect_to admin_categories_path
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:success] = "Category successfully created."
      redirect_to admin_categories_path
    else
      flash.now[:danger] = @category.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :parent_id, :default)
  end

  def load_categories
    @categories = Category.all
  end
end
