move_down(15)

if @packaging_slip
  text I18n.t(:packaging_slip) , :style => :bold, :size => 18
elsif @credit_note || @order_canceled
  text I18n.t(:credit_note), :style => :bold, :size => 18
else
  text I18n.t(:customer_invoice), :style => :bold, :size => 18
  move_down(15)	
  text I18n.t('mailer.email.dear_customer'), :size => 10
  move_down(7)
  text I18n.t('mailer.email.thanks', :site_name => Spree::Config[:site_name]), :size => 10
  move_down(7)
end

move_down(15)