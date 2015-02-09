Deface::Override.new(:virtual_path => "spree/admin/return_authorizations/index",
                     :name => "link_to_credit_note",
                     :insert_top => "[data-hook='rma_row'] > td:last-child",
                     :partial => "spree/admin/return_authorizations/credit_note_link",
                     :disabled => false)
                     
Deface::Override.new(:virtual_path => "spree/admin/return_authorizations/edit",
                     :name => "return_authorization_botton_edit",
                     :insert_top => "[data-hook='toolbar'], #toolbar[data-hook]",
                     :partial => "spree/admin/return_authorizations/credit_note_button",
                     :disabled => false)