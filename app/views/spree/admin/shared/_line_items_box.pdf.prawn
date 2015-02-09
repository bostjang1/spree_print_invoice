if @packaging_slip || @credit_note
  @column_widths = { 0 => 100, 1 => 315, 2 => 75, 3 => 50 } 
  @align = { 0 => :left, 1 => :left, 2 => :left, 3 => :center }
else
  @column_widths = { 0 => 75, 1 => 190, 2 => 75, 3 => 75, 4 => 50, 5 => 75 } 
  @align = { 0 => :left, 1 => :left, 2 => :left, 3 => :right, 4 => :center, 5 => :right}
end

# Line Items
bounding_box [0,cursor], :width => 540 do
  
  header =  [Prawn::Table::Cell.new( :text => t(:sku_short), :font_style => :bold), Prawn::Table::Cell.new( :text => t(:item_description), :font_style => :bold )]
  header <<  Prawn::Table::Cell.new( :text => t(:options), :font_style => :bold ) 
  header <<  Prawn::Table::Cell.new( :text => t(:price), :font_style => :bold ) unless @packaging_slip || @credit_note
  header <<  Prawn::Table::Cell.new( :text => t(:qty), :font_style => :bold, :align => 1 )
  header <<  Prawn::Table::Cell.new( :text => t(:total), :font_style => :bold ) unless @packaging_slip || @credit_note
    
  table [header],
    :position  => :center,
    :border_width => 1,
    :vertical_padding   => 2,
    :horizontal_padding => 6,
    :font_size => 10,
    :column_widths => @column_widths,
    :align => @align

  move_down 3

  bounding_box [0,cursor], :width => 540 do
    move_down 2
    content = []
    
    if @packaging_slip
    	items = []
    	query = "select variant_id, count(id) as quantity from spree_inventory_units where shipment_id = '#{@shipment.id}' group by variant_id"
   	 	result = Spree::InventoryUnit.connection.execute(query)
    	if result
    		result.each do |item|
    		  variant = Spree::Variant.find(item[0])
    		  row = [ variant.product.sku, variant.product.name]
		      row << variant.option_values.map {|ov| "#{ov.option_type.presentation}: #{ov.presentation}"}.concat(variant.respond_to?('ad_hoc_option_values') ? variant.ad_hoc_option_values.map {|pov| "#{pov.option_value.option_type.presentation}: #{pov.option_value.presentation}"} : []).join(', ')
		      row << item[1]
		      content << row
    		end
    	end
    elsif @credit_note
    	items = []
    	query = "select variant_id, count(id) as quantity from spree_inventory_units where return_authorization_id = '#{@return_authorization.id}' group by variant_id"
   	 	result = Spree::InventoryUnit.connection.execute(query)
    	if result
    		result.each do |item|
    		  variant = Spree::Variant.find(item[0])
    		  row = [ variant.product.sku, variant.product.name]
		      row << variant.option_values.map {|ov| "#{ov.option_type.presentation}: #{ov.presentation}"}.concat(variant.respond_to?('ad_hoc_option_values') ? variant.ad_hoc_option_values.map {|pov| "#{pov.option_value.option_type.presentation}: #{pov.option_value.presentation}"} : []).join(', ')
		      row << item[1]
		      content << row
        	end
    	end
    else    
	     @order.line_items.each do |item|
	      row = [ item.variant.product.sku, item.variant.product.name]
	      row << item.variant.option_values.map {|ov| "#{ov.option_type.presentation}: #{ov.presentation}"}.concat(item.respond_to?('ad_hoc_option_values') ? item.ad_hoc_option_values.map {|pov| "#{pov.option_value.option_type.presentation}: #{pov.option_value.presentation}"} : []).join(', ')
	      row << number_to_currency(item.price)
	      row << item.quantity
	      row <<  Prawn::Table::Cell.new( :text => number_to_currency(item.price * item.quantity), :font_style => :bold ) 
	      content << row
	    end 
    end
    
    table content,
      :position => :center,
      :border_width => 0.5,
      :vertical_padding   => 5,
      :horizontal_padding => 6,
      :font_size => 9,
      :column_widths => @column_widths ,
      :align => @align
  end

  render :partial => "spree/admin/shared/order_totals" unless @packaging_slip

end
