Deface::Override.new(:virtual_path => "spree/admin/shipments/index",
                     :name => "link_to_packaging_slip",
                     :insert_top => "[data-hook='admin_shipments_index_row_actions'], #admin_shipments_index_row_actions[data-hook]",
                     #:partial => "spree/admin/shipments/packaging_slip_link",

                     :disabled => true)