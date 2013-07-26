require "prawn/measurement_extensions"

pdf.font_families.update(
   "CourierNew" => {  :normal      => "#{Rails.root}/lib/assets/fonts/cour.ttf" })

pdf.line_width = 0.5
pdf.font("CourierNew", :style => :normal, :size => 8) 

for order in @orders do

cod = order.payments.last.payment_method.is_a?(Spree::CashOnDelivery::PaymentMethod)
shipping_method = order.shipment.shipping_method.name
posta = (shipping_method == "Pošta Slovenije")
gls = (shipping_method == "GLS")
prevzem = (shipping_method == "Osebni prevzem")

if cod
  pdf.text_box "#{order.bill_address.firstname.mb_chars.upcase} #{order.bill_address.lastname.mb_chars.upcase} #{order.bill_address.address1.mb_chars.upcase}, #{order.bill_address.zipcode.to_s} #{order.bill_address.city.mb_chars.upcase}",
             :at => [(4).mm, (93.25).mm],
             :height => (9).mm,
             :width => (53).mm,
             :character_spacing => -0.5

  pdf.text_box "#{(order.shipment.tracking ? order.shipment.tracking : order.shipment.number)}",
                      :at => [(19.9).mm, (96.6).mm],
                      :height => (7.35).mm,
                      :width => (37.1).mm,
                      :character_spacing => -0.5
             
  pdf.text_box "Lekarnar.com ##{order.number}",
                        :at => [(4).mm, (80.75).mm],
                        :height => (9).mm,
                        :width => (53).mm,
                        :character_spacing => -0.5
  pdf.text_box "SI 00 #{order.id}",
                        :at => [(4).mm, (42.75).mm],
                        :height => (9).mm,
                        :width => (53).mm,
                        :character_spacing => -0.5
                        
pdf.font("CourierNew", :style => :normal, :size => 10)                         
  pdf.text_box "#{order.bill_address.firstname.mb_chars.upcase} #{order.bill_address.lastname.mb_chars.upcase} #{order.bill_address.address1.mb_chars.upcase}, #{order.bill_address.zipcode.to_s} #{order.bill_address.city.mb_chars.upcase}",
                       :at => [(63.75).mm, (80.75).mm],
                       :height => (9).mm,
                       :width => (99.5).mm
                       
pdf.text_box "OTHR",
                     :at => [(63.75).mm, (68.25).mm],
                     :height => (5).mm,
                     :width => (15).mm

pdf.text_box "Lekarnar.com račun št. #{order.number}",
                     :at => [(82.5).mm, (68.25).mm],
                     :height => (5).mm,
                     :width => (112.5).mm

pdf.text_box "SI 00",
                     :at => [(63.75).mm, (42.75).mm],
                     :height => (5).mm,
                     :width => (15).mm
                     
pdf.text_box "#{order.number}",
                     :at => [(80.75).mm, (42.75).mm],
                     :height => (5).mm,
                     :width => (82.50).mm
                     
pdf.text_box "#{(Date.today+2.days).to_s}",
                     :at => [(120).mm, (59.75).mm],
                     :height => (4.75).mm,
                     :width => (30.02).mm

end
if @orders.last != order and cod and @orders.at(@orders.index(order)+1).payments.last.payment_method.is_a?(Spree::CashOnDelivery::PaymentMethod)
  pdf.start_new_page(
                :page_size => [595.28, 288],
                :left_margin=>5.mm,
                :right_margin=>0,
                :top_margin=>(1.5).mm,
                :bottom_margin=>0)
end
end #loop