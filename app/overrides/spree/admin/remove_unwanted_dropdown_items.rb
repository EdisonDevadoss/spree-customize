Deface::Override.new(
  name: 'remove_documentation_content',
  virtual_path: 'spree/admin/shared/_account_nav', # Replace with the actual view path
  remove: "erb[loud]:contains('Spree.t(:documentation)')", # Remove the text content
  original: 'remove' # Use 'remove' action to remove the matched elements
)

Deface::Override.new(
  name: 'remove_documentation_icon',
  virtual_path: 'spree/admin/shared/_account_nav', # Replace with the actual view path
  remove: "erb[loud]:contains('svg_icon name: \"book.svg\"')", # Remove the svg_icon content
  original: 'remove' # Use 'remove' action to remove the matched elements
)