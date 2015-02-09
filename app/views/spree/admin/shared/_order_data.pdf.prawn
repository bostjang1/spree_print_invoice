bounding_box [0,cursor], :width => 540 do
    
  	orderdata = [[" ", Prawn::Table::Cell.new( :text => I18n.t(:order_number), :font_style => :bold ),  :text => (@order.number), :align => :right, :font_style => :bold ]]

	orderdata << ["", I18n.t(:shipment_number) , :text => @shipment.number, :align => :right ] if @packaging_slip
	
	orderdata << ["", I18n.t(:rma_number) , :text => @return_authorization.number, :align => :right ] if @credit_note
	
	orderdata << ["", I18n.t(:rma_number) , :text => "RMA" + @order.number, :align => :right ] if @order_canceled

  	orderdata << ["", I18n.t(:order_date) , :text => l(@order.completed_at.to_date), :align => :right ]

	orderdata << ["", I18n.t(:invoice_date) , :text => l(Date.today.to_date), :align => :right ]

	if (@shipment.state == 'shipped' && @shipment.shipped_at)
		@shipped_at = @shipment.shipped_at
	end
	
	if @shipped_at
		orderdata << ["", I18n.t(:delivery_date) , :text => l(@shipped_at.to_date), :align => :right ]
	end

    table orderdata,
      :position => :center,
      :border_width => 0.0,
      :vertical_padding   => 0,
      :horizontal_padding => 0,
      :font_size => 10,
      :column_widths => { 0 => 340, 1 => 100, 2 => 100}

end