# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "spree_print_invoice"
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Spree Community"]
  s.date = "2014-10-25"
  s.files = ["README.md", "lib/prawn_handler.rb", "lib/spree_print_invoice.rb", "lib/spree_print_invoice", "lib/spree_print_invoice/engine.rb", "app/controllers", "app/controllers/spree", "app/controllers/spree/admin", "app/controllers/spree/admin/orders_controller_decorator.rb", "app/controllers/spree/admin/return_authorizations_controller_decorator.rb", "app/controllers/spree/admin/shipments_controller_decorator.rb", "app/models", "app/models/spree", "app/models/spree/print_invoice_configuration.rb", "app/overrides", "app/overrides/invoice.rb", "app/overrides/packaging_slip.rb", "app/views", "app/views/spree", "app/views/spree/admin", "app/views/spree/admin/orders", "app/views/spree/admin/orders/_invoice_link.html.erb", "app/views/spree/admin/orders/bills.pdf.prawn", "app/views/spree/admin/orders/confirmation.pdf.prawn", "app/views/spree/admin/orders/edit.html.erb", "app/views/spree/admin/orders/invoice.pdf.prawn", "app/views/spree/admin/orders/show.html.erb", "app/views/spree/admin/return_authorizations", "app/views/spree/admin/return_authorizations/credit_note.pdf.prawn", "app/views/spree/admin/return_authorizations/edit.html.erb", "app/views/spree/admin/return_authorizations/index.html.erb", "app/views/spree/admin/shared", "app/views/spree/admin/shared/_footer.pdf.prawn", "app/views/spree/admin/shared/_header.pdf.prawn", "app/views/spree/admin/shared/_print.pdf.prawn", "app/views/spree/admin/shared/_print_buttons.html.erb", "app/views/spree/admin/shared/_print_edit_buttons.html.erb", "app/views/spree/admin/shared/_slips.pdf.prawn", "app/views/spree/admin/shared/backup_print.pdf.prawn", "app/views/spree/admin/shared/credit_note.pdf.prawn", "app/views/spree/admin/shipments", "app/views/spree/admin/shipments/_packaging_slip_link.html.erb", "app/views/spree/admin/shipments/packaging_slip.pdf.prawn", "config/locales"]
  s.homepage = "https://github.com/spree/spree_print_invoice"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.requirements = ["none"]
  s.rubygems_version = "1.8.29"
  s.summary = "Print invoices, packaging slips, and  from a spree order"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<prawn>, ["= 0.12"])
      s.add_runtime_dependency(%q<spree_core>, ["~> 1.3.0"])
    else
      s.add_dependency(%q<prawn>, ["= 0.12"])
      s.add_dependency(%q<spree_core>, ["~> 1.3.0"])
    end
  else
    s.add_dependency(%q<prawn>, ["= 0.12"])
    s.add_dependency(%q<spree_core>, ["~> 1.3.0"])
  end
end
