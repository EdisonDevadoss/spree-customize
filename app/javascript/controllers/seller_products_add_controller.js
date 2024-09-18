import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['customOrigin'];

  connect() {
    this.toggleCustomOriginRequired();
  }

  selectOrigin() {
    this.toggleCustomOriginRequired();
  }

  toggleCustomOriginRequired() {
    const selectElement = this.element.querySelector('select');
    const selectOption = selectElement.options[selectElement.selectedIndex];
    const name = selectOption.text;

    if (name === 'Others') {
      this.customOriginTarget.hidden = false;
      this.customOriginTarget.querySelector('input').required = true;
    } else {
      this.customOriginTarget.hidden = true;
      this.customOriginTarget.querySelector('input').required = false;
    }
  }
}
