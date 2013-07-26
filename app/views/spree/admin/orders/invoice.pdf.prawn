# encoding: utf-8
if @orders

else
  @shipment = @order.shipment
  @order_canceled = params[:orderstate] == "canceled"
  @orders = [@order]
end

#render :partial => "spree/admin/shared/print"
render :partial => "spree/admin/shared/slips"