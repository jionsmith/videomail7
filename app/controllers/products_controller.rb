class ProductsController < ApplicationController
  before_filter :load_product, only: [:show, :add_to_user]
  before_filter do
    #redirect_to :back, notice: 'Coming soon'
    #false
  end

  def index
    @products = Product.enabled.templates.page(params[:page])
  end

  def show
  end

  def add_to_user
    if @product.is_free?
      if current_account.add_product(@product)
        flash[:notice] = "#{@product.name} added"
      else
        flash[:alert] = "#{@product.name} cannot be added"
      end
    else
      flash[:alert] = "#{@product.name} cannot be added"
    end

    redirect_to templates_path
  end

  private

  def load_product
    @product = Product.find(params[:id])
  end
end
