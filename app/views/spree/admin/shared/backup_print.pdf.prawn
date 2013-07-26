require 'prawn/layout'

#font "Helvetica"
pdf.font_families.update(
   "Roboto" => {             :bold        => "#{Rails.root}/lib/assets/fonts/Roboto-Bold.ttf",
                            :normal      => "#{Rails.root}/lib/assets/fonts/Roboto-Regular.ttf" })
font "Roboto"

fill_color "000000"

render :partial => "spree/admin/shared/header"

font_size 10


bounding_box [20,650], :width => 540, :height => 540 do

	### address ###
	
	if @packaging_slip
		left_address = @order.ship_address
		right_address = @order.bill_address
		tableheader = make_cell(:content => I18n.t(:billing_address), :font_style => :bold)
	else
		left_address = @order.bill_address
		right_address = @order.ship_address
		tableheader = make_cell(:content => I18n.t(:shipping_address), :font_style => :bold)
	end
	
	anonymous = @order.email =~ /@example.net$/
	
	bounding_box [0,cursor], :width => 540 do
	
	    if anonymous and Spree::Config[:suppress_anonymous_address]
	      
				addressdata = [[" "," "]] * 6 
	    
	    else
	
	      addressdata = [[" ", tableheader]] 
	      addressdata << ["#{left_address.firstname} #{left_address.lastname}", "#{right_address.firstname} #{right_address.lastname}"]	      
	      addressdata << [left_address.address1, right_address.address1]	      
	      addressdata << [left_address.address2, right_address.address2] unless left_address.address2.blank? and right_address.address2.blank?	     
	      addressdata << ["#{left_address.zipcode} #{left_address.city}  #{(left_address.state ? left_address.state.abbr : "")} ", "#{right_address.zipcode} #{right_address.city} #{(right_address.state ? right_address.state.abbr : "")}"]	              
	      addressdata << [left_address.country.name, right_address.country.name]
	      
	    end
	    
	    table(addressdata, :column_widths => [340, 200], :cell_style => {:padding => [0, 0, 0, 0], :border_width => 0, :size => 10})
	
	end
	
	move_down(15)
	
	### /address ###
	
	### order data ###
	
	bounding_box [340,cursor], :width => 200 do
	    
		orderdata = [[ make_cell(:content => I18n.t(:order_number), :font_style => :bold),  make_cell(:content => @order.number, :font_style => :bold, :align => :right) ]]
		orderdata << [ I18n.t(:shipment_number) , make_cell(:content => @shipment.number, :align => :right) ] if @packaging_slip		
		orderdata << [ I18n.t(:rma_number) , make_cell(:content => @return_authorization.number, :align => :right) ] if @credit_note	
		orderdata << [ I18n.t(:rma_number) , make_cell(:content => "RMA" + @order.number, :align => :right) ] if @order_canceled
		orderdata << [ I18n.t(:order_date) , make_cell(:content => l(@order.completed_at.to_date), :align => :right) ]
		orderdata << [ I18n.t(:invoice_date) , make_cell(:content => l(Date.today.to_date), :align => :right) ] unless @order_confirmation
	
		if (@shipment.state == 'shipped' && @shipment.shipped_at)
			@shipped_at = @shipment.shipped_at
		end
		
		if @shipped_at
			orderdata << [ I18n.t(:delivery_date) ,  make_cell(:content => l(@shipped_at.to_date), :align => :right) ]
		end
	
		table(orderdata, :column_widths => [100, 100], :cell_style => {:padding => [0, 0, 0, 0], :border_width => 0, :size => 10})
	
	end
	
	### /order data ###
	
	### topic ###
	
	move_down(15)

	if @packaging_slip
	  text I18n.t(:packaging_slip) , :style => :bold, :size => 18
	elsif @credit_note || @order_canceled
	  text I18n.t(:credit_note), :style => :bold, :size => 18
	elsif @order_confirmation
	 text I18n.t(:order_confirmation), :style => :bold, :size => 18
	else
	  text I18n.t(:customer_invoice), :style => :bold, :size => 18
	  move_down(15)	
	  text I18n.t('mailer.email.dear_customer'), :size => 10
	  move_down(7)
	  text I18n.t('mailer.email.thanks', :site_name => Spree::Config[:site_name]), :size => 10
	  move_down(7)
	end
	
	move_down(15)
	
	### /topic ### 
	
	### line items ###
	
	if @packaging_slip || @credit_note
	  @column_widths = { 0 => 100, 1 => 315, 2 => 75, 3 => 50 } 
	else
	  @column_widths = { 0 => 85, 1 => 180, 2 => 75, 3 => 75, 4 => 50, 5 => 75 } 
	end
	
	bounding_box [0,cursor], :width => 540 do
	  
	  header =  [ make_cell(:content => t(:sku_short), :font_style => :bold), make_cell(:content => t(:item_description), :font_style => :bold, :align => :left ) ]
	  header <<  make_cell(:content => t(:options), :font_style => :bold, :align => :left ) 
	  header <<  make_cell(:content => t(:price), :font_style => :bold, :align => :right ) unless @packaging_slip || @credit_note
	  header <<  make_cell(:content => t(:qty), :font_style => :bold, :align => :center )
	  header <<  make_cell(:content => t(:total), :font_style => :bold, :align => :right ) unless @packaging_slip || @credit_note	  
	  header2dim = [ header ]
	  
	  table(header2dim, :column_widths => @column_widths, :cell_style => {:padding => [2, 6, 2, 6], :border_width => 1, :size => 10 })
	
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
			      row << make_cell(:content => item[1].to_s, :align => :center)
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
			      row << make_cell(:content => item[1].to_s, :align => :center)
			      content << row
	        end
	    	end
	    else    
		     @order.line_items.each do |item|
		      row = [ item.variant.product.sku, item.variant.product.name]
		      row << item.variant.option_values.map {|ov| "#{ov.option_type.presentation}: #{ov.presentation}"}.concat(item.respond_to?('ad_hoc_option_values') ? item.ad_hoc_option_values.map {|pov| "#{pov.option_value.option_type.presentation}: #{pov.option_value.presentation}"} : []).join(', ')
		      row << make_cell(:content => number_to_currency(item.price), :align => :right)
		      row << make_cell(:content => item.quantity.to_s, :align => :center)
		      row << make_cell(:content => number_to_currency(item.price * item.quantity), :font_style => :bold, :align => :right ) 
		      content << row
		    end 
	    end
	    
	    if !content.empty?   	
	    	table(content, :column_widths => @column_widths, :cell_style => {:padding => [5, 6, 5, 6], :border_width => 0.5, :size => 9 })
	    end
	  end
	
		### order totals ###
		unless @packaging_slip
			if @packaging_slip || @credit_note
			  @column_widths = { 0 => 354, 1 => 130, 2 => 50 } 
			else
			  @column_widths = { 0 => 335, 1 => 130, 2 => 69 } 
			end
			
			move_down(7)
			
			ordertotal = @credit_note ? @return_authorization.amount : @order.total
			taxtotal  = @credit_note ? @return_authorization.amount * Spree::TaxRate.find(Spree::Zone.default_tax).amount : @order.tax_total
			
			shipmentlabel = nil
			shipmentamount = 0.0
			
			tracking = ""
			
			if @shipment.tracking.present? && !@credit_note		   
			   tracking = (@shipment.respond_to?(:shipment_label) && @shipment.shipment_label.present?) ? "#{I18n.t(:tracking)}: #{@shipment.shipment_label.carrier.upcase} #{@shipment.tracking}" : "#{I18n.t(:tracking)}: #{@shipment.tracking}"    		
			end

			totals = []
			
			unless @credit_note
							
				totals << [ make_cell(:content => tracking, :size => 10, :align => :left), make_cell(:content => t(:subtotal) + ":", :font_style => :bold, :align => :right), :content =>  number_to_currency(@order.item_total), :font_style => :bold, :align => :right ]			
				
				@order.adjustments.each do |charge|
				  # we don't want any returns on our pretty invoice
				  if charge.source_type == 'Spree::ReturnAuthorization'
				  	ordertotal += charge.amount * -1
				  elsif charge.source_type == 'Spree::Shipment'
				  	shipmentamount += charge.amount
				  	shipmentlabel = charge.label
				  else
				  	totals << ["", make_cell(:content => charge.label + ":", :font_style => :bold, :align => :right), make_cell(:content => number_to_currency(charge.amount), :font_style => :bold, :align => :right)]
				  end 
				end
				
				if shipmentlabel 
					totals << ["", make_cell(:content => shipmentlabel + ":", :font_style => :bold, :align => :right), make_cell(:content => number_to_currency(shipmentamount), :font_style => :bold, :align => :right)]
				end
				
				@order.price_adjustments.each do |charge|
				  totals << ["", make_cell(:content => charge.label + ":", :font_style => :bold, :align => :right), make_cell(:content => number_to_currency(charge.amount), :font_style => :bold, :align => :right)]
				end
				
			end
			
			totals << ["", make_cell(:content => t(:order_total) + ":", :font_style => :bold, :align => :right), make_cell(:content => number_to_currency(ordertotal), :font_style => :bold, :align => :right)]
			
			totals << ["", make_cell(:content => '' + ":", :align => :right), make_cell(:content => number_to_currency(taxtotal), :align => :right)]
  			
			bounding_box [0, cursor], :width => 534 do		
				table(totals, :column_widths => @column_widths, :cell_style => {:padding => [2, 0, 2, 6], :border_width => 0, :size => 9 })
			end		
		end
		### /order totals ###
	
	end
	
	### /line items ###
	
	### notes ###
	
	unless @packaging_slip || @credit_note || @order_canceled
		move_down(15)	  
		if @order.payment_state == "paid" || @order.payments.last.payment_method.type.gsub(':','') == "SpreeBillingIntegrationPaypalExpress" || @order.payments.last.payment_method.type.gsub(':','') == "SpreeBillingIntegrationPaymillCreditCard" 
			text I18n.t(:order_is_paid, :paymentmethod => @order.payments.last.payment_method.name), :style => :bold, :align => :center
		elsif @order.payments.last.payment_method.type.gsub(':','') == "SpreePaymentMethodPaymentInAdvance"
			text I18n.t(:order_is_not_paid, :condition => nil, :paymentmethod => @order.payments.last.payment_method.name, :site_url => Spree::Config[:site_url]), :style => :bold, :align => :left
		elsif @order.payments.last.payment_method.type.gsub(':','') == "SpreePaymentMethodInvoice"
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
	
	### /notes ###

end

render :partial => "spree/admin/shared/footer"
