require 'barby'
require 'barby/outputter/prawn_outputter'
require 'barby/barcode/code_39'




pdf.font_families.update(
   "Roboto" => {             :bold        => "#{Rails.root}/lib/assets/fonts/Roboto-Bold.ttf",
                            :normal      => "#{Rails.root}/lib/assets/fonts/Roboto-Regular.ttf" })
font "Roboto"

pdf.line_width = 0.5
pdf.fill_color = "444444"


for order in @orders do

cod = order.payments.last.payment_method.is_a?(Spree::CashOnDelivery::PaymentMethod)
shipping_method = order.shipment ? order.shipment.shipping_method.name : ""
posta = (shipping_method == "Pošta Slovenije")
gls = (shipping_method == "GLS")
prevzem = (shipping_method == "Osebni prevzem")

if posta

pdf.bounding_box [0,740], :width => 100 do
  logo = "#{Rails.root}/app/assets/images/pdf-lekarnar-logo.png" 
  pdf.image logo, :scale => 0.4, :position => :left,   :vposition => :top
end

pdf.move_down(5)
pdf.font("Roboto", :style => :bold, :color => "666666") 
pdf.text "Pošiljatelj                      tel: 01 521 12 76", :size => 10, :style => :bold
pdf.move_down(5)
pdf.font("Roboto", :style => :normal, :size => 10)
pdf.text "Lekarna Nove Poljane, Dušan Hrobat s.p."
pdf.text "Gasparijeva 2"
pdf.text "1000 Ljubljana"

pdf.move_down(10)


pdf.text "Vrednost EUR:"
pdf.stroke_line 85, 633, 170, 633
pdf.stroke_line 85, 617, 170, 617
pdf.move_down(5)
if cod
  pdf.text "Odkupnina EUR:"
else
  pdf.text "Odkupnina EUR:              0,00 €"
end


pdf.move_down(10)
pdf.text "Storitve", :size => 10, :style => :bold
pdf.move_down(5)
pdf.font("Roboto", :style => :normal, :size => 10)
if cod
  pdf.text "Z odkupnino"
end
#if order.delivery_type == "Navadna dostava do 10h"
# pdf.text "Dostava do 10. ure"
#elsif order.delivery_type == "Navadna dostava po 16h"
# pdf.text "Dostava po 16. uri"
#elsif order.delivery_type == "Večerna dostava"
# pdf.text "Večerna dostava"
#end
if cod
  pdf.move_down(5)
  pdf.text "Vplačnina po pogodbi 03265565946", :size => 8
end


pdf.bounding_box [0,525], :width => 280 do
  #pdf.text "Opombe: #{cod ? ' ODK, ' : ''}#{order.delivery_type == "Navadna dostava do 10h" ? ' DO 10. URE, ' : ''}#{order.delivery_type == "Navadna dostava po 16h" ? ' PO 16. URI, ' : ''}#{order.delivery_type == "Večerna dostava" ? ' VEČERNA DOSTAVA (od 18h do 20h), ' : ''} #{order.payment_type == APP_CONFIG['payment_types']['cash'] ? 'VPL PG' : ''}", :style => :bold
  pdf.text "Opombe: #{cod ? ' ODK, ' : ''} #{cod ? 'VPL PG' : ''}", :style => :bold
end






pdf.bounding_box [280,740], :width => 330 do
  pdf.text "Pošta 1102 Ljubljana", :size => 8
  pdf.move_down(40)
  barcode = Barby::Code39.new((order.shipment.tracking ? order.shipment.tracking : "").gsub(" ", ""))
  pdf.fill_color = "000000"
  barcode.annotate_pdf(pdf, :height => 38, :xdim => 0.8, :ydim => 200)
  pdf.fill_color = "444444"
  pdf.font("Times-Roman", :style => :normal, :size => 14)
  pdf.move_down(5)
  pdf.text (order.shipment.tracking ? order.shipment.tracking : order.number)
  pdf.font("Roboto", :style => :normal, :size => 8)
  pdf.move_down(5)
  pdf.text "Datum in čas sprejema:"
  pdf.stroke_rectangle [110,15], 90, 15
  pdf.stroke_line 125,15,125,0
  pdf.stroke_line 140,15,140,0
  pdf.stroke_line 155,15,155,0
  pdf.stroke_line 170,15,170,0
  pdf.stroke_line 185,15,185,0
  pdf.stroke_rectangle [210,15], 60, 15
  pdf.stroke_line 225,15,225,0
  pdf.stroke_line 240,15,240,0
  pdf.stroke_line 255,15,255,0
  pdf.move_down(5)
  pdf.text "Sprejemna pošta:"
  pdf.stroke_line 110,0,270,0
  pdf.move_down(5)  
  pdf.text "Masa:"
  pdf.stroke_line 110,0,270,0
  pdf.move_down(5)
  pdf.text "Poštnina EUR:"
  pdf.stroke_line 110,0,270,0
  pdf.move_down(5)
  pdf.text "DDV 20% EUR:"
  pdf.stroke_line 110,0,270,0


  
end


pdf.bounding_box [280,588], :width => 330 do
  pdf.text "Naslovnik", :size => 10, :style => :bold
  #pdf.move_down(2)
  pdf.font("Roboto", :style => :normal, :size => 15)
  pdf.text "#{order.ship_address.firstname.mb_chars.upcase} #{order.ship_address.lastname.mb_chars.upcase}"
  pdf.text "#{order.ship_address.address1.mb_chars.upcase}"
  pdf.text "#{order.ship_address.address2.mb_chars.upcase}" if order.ship_address.address2 && order.ship_address.address2 != ""
  pdf.text "#{order.ship_address.zipcode} #{order.ship_address.city.mb_chars.upcase}"
  pdf.text "#{order.ship_address.country.name.mb_chars.upcase}" if order.ship_address.country_id != 1
  if order.shipment.shipping_method == "Osebni prevzem v Lekarni Nove Poljane"
    pdf.stroke_line 0,0,280,210
    pdf.stroke_line 0,210,280,0
  end
  if order.shipment.shipping_method == "GLS dostava"
    pdf.stroke_line 0,210,280,0
  end
end

else
  pdf.bounding_box [0,740], :width => 550, :height => 225 do
  logo = "#{Rails.root}/app/assets/images/pdf-lekarnar-logo.png" 
  pdf.image logo, :scale => 0.4, :position => :left,   :vposition => :top
end
end # if posta

pdf.stroke_line 0, 510, 550, 510 

pdf.move_down(20)
pdf.text "Naročilo ##{order.number} - #{order.ship_address.firstname.mb_chars.upcase} #{order.ship_address.lastname.mb_chars.upcase}#{(order.shipment.tracking ? " - " + order.shipment.tracking : "")}", :size => 16, :style => :normal

if order.shipment.shipping_method.name == "Osebni prevzem"
 pdf.move_down(5)
 pdf.text "Osebni prevzem"+(((order.payments.last.payment_method.name == "Plačilo po povzetju") or (order.payments.last.payment_method.name == "Osebni prevzem")) ? " - plačilo ob prevzemu" : "") , :size => 14, :style => :normal
 pdf.stroke_line 0,468,280,468
 pdf.stroke_line 0,448,280,448
end
if order.shipment.shipping_method.name == "GLS"
 pdf.move_down(5)
 pdf.text "GLS dostava" , :size => 14, :style => :normal
 pdf.stroke_line 0,468,100,468
 pdf.stroke_line 0,448,100,448
end

pdf.move_down(5)
pdf.font("Roboto", :style => :normal, :size => 10)
pdf.text "Datum: #{l order.completed_at}"
pdf.move_down(10)

items = [["Izdelek", "Kol", "Cena", "Skupaj"]]
items += order.line_items.map do |item|
  options = []
  item.ad_hoc_option_values.each do |pov| 
      options << pov.option_value.option_type.presentation+": "+pov.option_value.presentation
  end
  [
    item.variant.product.name+((item.variant.product.promo && item.variant.product.promo != "") ? " ("+item.variant.product.promo+")" : "")+((item.variant.product.comment and item.variant.product.comment != "") ? " ("+item.variant.product.comment+") " : " ")+options.join(" | "),
    item.quantity,
    number_to_currency(item.price)+" €" + (item.variant.product.sale_price != 0.00 ? " (-"+item.variant.product.discount_percentage.round(2).to_s.gsub(".", ",")+"%)" : ""),
    number_to_currency(item.price * item.quantity) + " €"
  ]
end

#items << [ '', {:text => "#{order.shipment.shipping_method.name}", :colspan => 2}, "#{number_to_currency(order.adjustments.shipping.last.amount)} EUR"]
#if order.payments.last.payment_method.name == "Plačilo po povzetju"
# items << [ '', '', "Plačilo po povzetju", "#{number_to_currency(order.adjustments.shipping.last.amount)} EUR"]
#end
order.adjustments.eligible.each do |adjustment| 
  next if (adjustment.originator_type == 'Spree::TaxRate') and (adjustment.amount == 0)
    items << [  adjustment.label,'', '',number_to_currency(adjustment.amount) + " €"]
end
#if order.points_spent
#  items << [ '', '', "Skupaj", "#{number_to_currency(order.subtotal)} EUR"]
#  items << [ '', '', "Popust #{number_to_currency(order.percentage)} %", "#{number_to_currency(order.subtotal-order.total)} EUR"]
#end
items << [  '','', "Skupaj za plačilo", "#{number_to_currency(order.total)} €"]

pdf.text "Naročeni izdelki", :size => 10, :style => :bold

pdf.font("Roboto", :style => :normal, :size => 10)
pdf.table( items, #:border_style => :grid,
  #:row_colors => ["FFFFFF","FFFFFF"],
  #:headers => ["Izdelek", "Količina", "Cena", "Skupaj"],
  #:font_size => 8,
  #:border_width => 0.1,
  #:horizontal_padding => 4,
  :width => 550,
  :cell_style => {:padding => 4, :padding_left => 0, :padding_bottom => 3, :align => :center, :borders => [:bottom], :border_width => 0.1, :border_color => "444444", :size => 8},
  :column_widths => [400, 20, 80, 50]
  #:vertical_padding   => 3, 
  #:align => { 0 => :left, 1 => :center, 2 => :right, 3 => :right }
  ) do
      column(0).style :align => :left
      column(-1).style :align => :right
      column(-2).style :align => :right
      row(order.line_items.size).style :border_width => 1, :padding_bottom => 7, :borders => [:bottom] 
      row(0).style :font_style => :bold, :border_width => 0.5, :padding_bottom => 7, :borders => [:top,:bottom]
      row(-2).style :padding_bottom => 7
      row(-1).style :font_style => :bold, :borders => [:top,:bottom], :border_width => 1, :padding_bottom => 7
  end

pdf.move_down(5)
#pdf.table [
#  [ "Naslov za dostavo","#{order.ship_to_first_name} #{order.ship_to_last_name}", "#{order.ship_to_street}", "#{order.ship_to_post_num.to_s} #{order.ship_to_city.upcase}"],
#  ["Naslov za plačilo","#{order.user.name} #{order.user.surname}", "#{order.user.addresses.first.street}", "#{order.user.addresses.first.post_num.to_s} #{order.user.addresses.first.city.upcase}"]],
#  :font_size => 10,
#  :border_width => 0.2,
#  :horizontal_padding => 10,
#  :vertical_padding   => 3,
#  :row_colors => ["FFFFFF","FFFFFF"],
#  :width => 550,
#  :headers => ["","Ime in priimek", "Naslov", "Poštna št. in kraj"],
#  :align => { 0 => :left, 1 => :center, 2 => :center, 3 => :center }

    left_address = order.bill_address
    right_address = order.ship_address
    l_tableheader = make_cell(:content => "Podatki naročnika", :font_style => :bold)
    tableheader = make_cell(:content => "Podatki za dostavo", :font_style => :bold)

    addressdata = [[l_tableheader, tableheader]] 
    addressdata << ["#{left_address.firstname} #{left_address.lastname}", "#{right_address.firstname} #{right_address.lastname}"]       
    addressdata << [left_address.address1, right_address.address1] unless prevzem       
    addressdata << [left_address.address2, right_address.address2] unless left_address.address2.blank? and right_address.address2.blank?       
    addressdata << ["#{left_address.zipcode} #{left_address.city}  #{(left_address.state ? left_address.state.abbr : "")} ", "#{right_address.zipcode} #{right_address.city} #{(right_address.state ? right_address.state.abbr : "")}"] unless prevzem               
    addressdata << [left_address.country.name, right_address.country.name] if order.ship_address.country_id != 1
    addressdata << ["tel: #{order.bill_address.phone}", "#{ prevzem ? "tel prevzemnika:" : "tel za dostavo"} #{order.ship_address.phone}"]
    addressdata << ["Način plačila: #{order.payments.last.payment_method.name}", "Način dostave: #{order.shipment.shipping_method.name.capitalize}"]
    addressdata << ["email: #{order.email}", ""]
    addressdata << ["št. naročil: #{Spree::Order.find_all_by_email(order.email, :conditions => "completed_at IS NOT null AND shipment_state = 'shipped'").count}", "dodatna navodila: #{order.shipment.special_instructions}"]
    
    table(addressdata, :column_widths => [340, 200], :cell_style => {:padding => [0, 0, 0, 0], :border_width => 0, :size => 10}) do
      row(1).style :size => 14
      row(-2).style  :padding_bottom => 4
      row(-3).style  :padding_bottom => 4, :font_style => :bold
      row(-4).style :padding_bottom => 4
      row(-5).style :padding_bottom => 10
    end  

#pdf.move_down(5)
#pdf.text "Opombe", :size => 10, :style => :bold
#pdf.text "#{order.user.note}"

#if order.payment_type == APP_CONFIG['payment_types']['cash'] 
#  pdf.bounding_box [350,85], :width => 200 do
#    pdf.stroke_rectangle [0,4], 200, 88
#    pdf.text " Izpolni plačilni nalog:", :size => 12, :style => :bold
#    pdf.move_down(5)
#    pdf.font("Roboto", :style => :normal, :size => 10)
#    pdf.text " Naziv: #{order.ship_to_first_name.mb_chars.upcase} #{order.ship_to_last_name.mb_chars.upcase}"
#    pdf.text " Ulica: #{order.ship_to_street.mb_chars.upcase}"
#    pdf.text " Kraj:  #{order.ship_to_post_num.to_s} #{order.ship_to_city.mb_chars.upcase}"
#    pdf.text " Namen plačila: Račun Lekarnar.com #{order.id}"
#    pdf.text " Kontrolni znesek: #{number_to_currency(order.total)} EUR"
#    pdf.text " Znesek prepiši z računa iz blagajne!"
#  end
#end
pdf.bounding_box [424,446], :width => 120 do
  barcode2 = Barby::Code39.new(order.number.to_s)
  pdf.fill_color = "000000"
  barcode2.annotate_pdf(pdf, :height => 26, :xdim => 0.8, :ydim => 200)
  pdf.fill_color = "444444"
  pdf.move_down(1)
  pdf.text (order.number)
end
if @orders.last != order
  pdf.start_new_page(:layout => :portrait)
end
end #loop