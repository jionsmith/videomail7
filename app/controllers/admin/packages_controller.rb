class Admin::PackagesController < Admin::BaseController
  before_filter :load_package, only: [:edit, :update, :destroy, :manage_templates, :add_template, :remove_template]
  
  def index
    @packages = Package.all
  end

  def new
    @package = Package.new
    @package.build_product
  end

  def create
    @package = Package.new(package_params)
    if @package.save
      flash[:success] = "Package successfully created"
      redirect_to edit_admin_package_path(@package)
    else
      flash.now[:danger] = @package.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @package.build_product unless @package.product
  end

  def update
    if @package.update_attributes(package_params)
      flash[:success] = "Package successfully updated"
    else
      flash[:danger] = @package.errors.full_messages.to_sentence
    end
    redirect_to edit_admin_package_path(@package)
  end

  def destroy
    unless @package.product.accounts.count > 0
      @package.destroy
      flash[:success] = "A package is deleted successfully."
    else
      flash[:alert] = "We could not delete the package because some users use that template."
    end
    redirect_to admin_packages_path
  end

  def manage_templates
    @templates = Template.all
    render :manage_templates, layout: 'clean'
  end

  def add_template
    @template = Template.find(params[:template])
    @package.templates << @template
    flash[:success] = "Template successfully added"
    redirect_to manage_templates_admin_package_path(@package)
  end

  def remove_template
    @template = @package.templates.find(params[:template])

    if @package.templates.destroy(@template)
      flash[:success] = "Template successfully removed"
    end

    redirect_to manage_templates_admin_package_path(@package)
  end

  private

    def package_params
      params.require(:package).permit(:name,
        product_attributes:[:price, :status]
      )
    end

    def load_package
      @package = Package.find(params[:id])
    end
end
