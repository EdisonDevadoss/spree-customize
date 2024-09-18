import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["jewelleryFields", "otherFields", "category"];

  connect() {
    this.toggleProperties();
  }

  toggleProperties() {
    const selectElement = this.element.querySelector("[data-action='form-toggle#toggleProperties']");
    const selectedOption = selectElement.options[selectElement.selectedIndex];
    const selectedCategoryName = selectedOption.text.toLowerCase();

    if (selectedCategoryName.includes('jewellery')) {
      this.showJewelleryFields();
    } else {
      this.showOtherFields();
    }
  }

  showJewelleryFields() {
    document.getElementById("jewellery-fields").classList.remove("d-none");
    document.getElementById("other-fields").classList.add("d-none");
  }

  showOtherFields() {
    document.getElementById("other-fields").classList.remove("d-none");
    document.getElementById("jewellery-fields").classList.add("d-none");
  }
}
