module InjectionHelper
  def inject_enterprises
    inject_json_ams "enterprises", Enterprise.all, Api::EnterpriseSerializer, active_distributors: @active_distributors
  end
  
  def inject_current_order
    inject_json_ams "currentOrder", current_order, Api::CurrentOrderSerializer, current_distributor: current_distributor, current_order_cycle: current_order_cycle
  end

  def inject_available_shipping_methods
    inject_json_ams "shippingMethods", available_shipping_methods, 
      Api::ShippingMethodSerializer, current_order: current_order
  end

  def inject_available_payment_methods
    inject_json_ams "paymentMethods", current_order.available_payment_methods, 
      Api::PaymentMethodSerializer
  end

  def inject_taxons
    inject_json_ams "taxons", Spree::Taxon.all, Api::TaxonSerializer
  end

  def inject_json(name, partial, opts = {})
    render partial: "json/injection", locals: {name: name, partial: partial}.merge(opts)
  end

  def inject_json_ams(name, data, serializer, opts = {})
    if data.is_a?(Array)
      json = ActiveModel::ArraySerializer.new(data, {each_serializer: serializer}.merge(opts)).to_json
    else
      json = serializer.new(data, opts).to_json
    end
    render partial: "json/injection_ams", locals: {name: name, json: json}
  end
end
