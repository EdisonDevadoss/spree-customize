import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    CKEDITOR.replace(this.element);
  }
}
