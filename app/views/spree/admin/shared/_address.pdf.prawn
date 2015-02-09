if @packaging_slip
	left_address = @order.ship_address
	right_address = @order.bill_address
	tableheader = Prawn::Table::Cell.new( :text =>I18n.t(:billing_address), :font_style => :bold )
else
	left_address = @order.bill_address
	right_address = @order.ship_address
	tableheader = Prawn::Table::Cell.new( :text =>I18n.t(:shipping_address), :font_style => :bold )
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
     
      addressdata << ["#{left_address.zipcode} #{left_address.city}  #{(left_address.state ? left_address.state.abbr : "")} ",
                  "#{right_address.zipcode} #{right_address.city} #{(right_address.state ? right_address.state.abbr : "")}"]
              
      addressdata << [left_address.country.name, right_address.country.name]
      
    end
    
    table addressdata,
      :position => :center,
      :border_width => 0.0,
      :vertical_padding   => 0,
      :horizontal_padding => 0,
      :font_size => 10,
      :column_widths => { 0 => 340, 1 => 200 }
      
    move_down(15)

end
