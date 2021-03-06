Spree::Api::ProductsController.class_eval do
  def managed
    authorize! :admin, Spree::Product
    authorize! :read, Spree::Product

    @products = product_scope.ransack(params[:q]).result.managed_by(current_api_user).page(params[:page]).per(params[:per_page])
    respond_with(@products, default_template: :index)
  end

  def bulk_products
    @products = product_scope.ransack(params[:q]).result.managed_by(current_api_user).page(params[:page]).per(params[:per_page])
    render text: { products: ActiveModel::ArraySerializer.new(@products, each_serializer: Spree::Api::ProductSerializer), pages: @products.num_pages }.to_json
  end

  def soft_delete
    authorize! :delete, Spree::Product
    @product = find_product(params[:product_id])
    authorize! :delete, @product
    @product.delete
    respond_with(@product, :status => 204)
  end


  private

  # Copied and modified from Spree::Api::BaseController to allow
  # enterprise users to access inactive products
  def product_scope
    if current_api_user.has_spree_role?("admin") || current_api_user.enterprises.present? # This line modified
      scope = Spree::Product
      unless params[:show_deleted]
        scope = scope.not_deleted
      end
    else
      scope = Spree::Product.active
    end

    scope.includes(:master)
  end

end
