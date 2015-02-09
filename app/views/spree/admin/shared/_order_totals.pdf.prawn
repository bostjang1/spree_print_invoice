if @packaging_slip || @credit_note
  @column_widths = { 0 => 390, 1 => 100, 2 => 50 } 
  @align = { 0 => :left, 1 => :right, 2 => :right }
else
  @column_widths = { 0 => 365, 1 => 100, 2 => 69 } 
  @align = { 0 => :left, 1 => :right, 2 => :right }
end

move_down(7)

ordertotal = @credit_note ? @return_authorization.amount : @order.total
taxtotal  = @credit_note ? @return_authorization.amount * Spree::TaxRate.find(Spree::Zone.default_tax).amount : @order.included_tax_total

shipmentlabel = nil
shipmentamount = 0.0

tracking = I18n.t('shipment_mailer.shipped_email.track_information', :tracking => @shipment.tracking) if @shipment.tracking && !@shipment.tracking.empty? && !@credit_note

totals = []

unless @credit_note

	totals << [ Prawn::Table::Cell.new(:text => tracking, :font_size => 10), Prawn::Table::Cell.new( :text => t(:subtotal) + ":", :font_style => :bold), :text => number_to_currency(@order.item_total), :font_style => :bold]
	
	@order.adjustments.each do |charge|
	  # we don't want any returns on our pretty invoice
	  if charge.source_type == 'Spree::ReturnAuthorization'
	  	ordertotal += charge.amount * -1
	  elsif charge.source_type == 'Spree::Shipment'
	  	shipmentamount += charge.amount
	  	shipmentlabel = charge.label
	  else
	  	totals << ["", Prawn::Table::Cell.new( :text => charge.label + ":", :font_style => :bold), :text => number_to_currency(charge.amount), :font_style => :bold]
	  end 
	end
	
	if shipmentlabel 
		totals << ["", Prawn::Table::Cell.new( :text => shipmentlabel + ":", :font_style => :bold), :text => number_to_currency(shipmentamount), :font_style => :bold]
	end
	
	@order.price_adjustments.each do |charge|
	  totals << ["", Prawn::Table::Cell.new( :text => charge.label + ":", :font_style => :bold), :text => number_to_currency(charge.amount), :font_style => :bold]
	end
	
end

totals << ["", Prawn::Table::Cell.new( :text => t(:order_total) + ":", :font_style => :bold), :text => number_to_currency(ordertotal), :font_style => :bold]

totals << ["", Prawn::Table::Cell.new( :text => @order.tax_total_label + ":"), :text => number_to_currency(taxtotal)]

bounding_box [0, cursor], :width => 534 do
  table totals,
    :position => :right,
    :border_width => 0,
    :vertical_padding   => 2,
    :horizontal_padding => 0,
    :font_size => 9,
    :column_widths => @column_widths ,
    :align => @align
end
