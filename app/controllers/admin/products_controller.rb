class Admin::ProductsController < Admin::BaseController

  def index
    @templates = Template.by_product_status.by_title
    @packages = Package.by_name
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])

    if @product.update_attributes(product_params)
      flash[:success] = "Template Successfully updated"
      redirect_to admin_products_path

    else
      flash[:danger] = @product.errors.full_messages.to_sentence
      redirect_to edit_admin_product_path(@product)
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to admin_products_path
  end

  def add_category
    @product = Product.find(params[:id])
    @category = Category.find(params[:category])
    @product.categories << @category
    flash[:success] = "Category successfully added"
    redirect_to edit_admin_product_path(@product)
  end

  def remove_category
    @product = Product.find(params[:id])
    @category = Category.find(params[:category])

    if @product.categories.destroy(@category)
      flash[:success] = "Category successfully removed"
    end

    redirect_to edit_admin_product_path(@product)
  end

  protected

  def product_params
     params.require(:product).permit(:price, :status)
  end

end
