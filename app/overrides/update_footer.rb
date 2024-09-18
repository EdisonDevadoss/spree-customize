Deface::Override.new(
  virtual_path: 'spree/shared/_footer',
  name: 'change_footer_text',
  replace: 'div.footer-spree-copyright-content',
  text: %q(
    <div class="d-flex flex-column flex-lg-row align-items-center justify-content-center py-3 footer-spree-copyright-content">
      <div>
        Designed <a target="_blank" aria-label="Go to Spark Solutions" rel="follow" href="https://sparksolutions.co/">Spark Solutions</a> | © 2024 <a href="http://demo.spreecommerce.org">Spree Demo Site</a>. All rights reserved.
      </div>
    </div>
  )
)
