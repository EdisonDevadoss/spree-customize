# app/overrides/admin_title_override.rb

Deface::Override.new(
  virtual_path: 'spree/admin/shared/_head',
  name: 'change_admin_panel_title',
  replace_contents: 'title',
  text: 'Yavar'
)
