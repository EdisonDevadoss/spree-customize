// app/javascript/controllers/zones_controller.js

import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["selectAll", "zoneCheckbox"];

  connect() {
    this.updateSelectAllState();
  }

  toggleAll() {
    const isChecked = this.selectAllTarget.checked;
    this.zoneCheckboxTargets.forEach((checkbox) => {
      checkbox.checked = isChecked;
    });
  }

  updateSelectAll() {
    this.selectAllTarget.checked = this.zoneCheckboxTargets.every(
      (checkbox) => checkbox.checked
    );
  }

  updateSelectAllState() {
    this.selectAllTarget.checked = this.zoneCheckboxTargets.every(
      (checkbox) => checkbox.checked
    );
  }
}
