class Shop::CheckoutController < BaseController
  layout 'darkswarm'

  before_filter :set_distributor
  before_filter :require_order_cycle
  before_filter :require_line_items
  
  def new
    @order = current_order
    @order.bill_address = Spree::Address.new
  end

  private

  def set_distributor
    unless @distributor = current_distributor 
      redirect_to root_path
    end
  end

  def require_order_cycle
    unless current_order_cycle
      redirect_to shop_path
    end
  end
  
  # Y U LOOK AT CART? CART IS EMPTY!
  # NO CAN HAZ!
  def require_line_items
    if current_order.line_items.empty?
      redirect_to shop_path
    end
  end
end