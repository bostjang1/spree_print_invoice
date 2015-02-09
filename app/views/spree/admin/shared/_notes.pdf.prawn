unless @packaging_slip || @credit_note || @order_canceled
	move_down(15)

	if @order.payment_method.type.gsub(':','') == "SpreeBillingIntegrationPaypalExpress" || @order.payment_state == "paid"
		text I18n.t(:order_is_paid, :paymentmethod => @order.payment_method.name), :style => :bold, :align => :center
	elsif @order.payment_method.type.gsub(':','') == "SpreePaymentMethodPaymentInAdvance"
		text I18n.t(:order_is_not_paid, :condition => nil, :paymentmethod => @order.payment_method.name, :site_url => Spree::Config[:site_url]), :style => :bold, :align => :left
	elsif @order.payment_method.type.gsub(':','') == "SpreePaymentMethodInvoice"
		text I18n.t(:order_is_not_paid, :condition => t(:after_delivery), :paymentmethod => I18n.t(:bank_transfer), :site_url => Spree::Config[:site_url]), :style => :bold, :align => :left
	end
end

if @order.special_instructions && !@order.special_instructions.empty? && @packaging_slip

	move_down(15)

	text("#{I18n.t('note')}: #{@order.special_instructions}")

end

move_down(15) unless @credit_note || @order_canceled

text I18n.t('mailer.email.greetings') unless @credit_note || @order_canceled

move_down(7) unless @credit_note || @order_canceled

text I18n.t('mailer.email.signature', :site_name => Spree::Config[:site_name]) unless @credit_note || @order_canceled