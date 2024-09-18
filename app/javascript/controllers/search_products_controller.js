import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["searchForm", "productsList", "searchField", "searchButton"];

  connect() {
    this.searchFormTarget.addEventListener("submit", this.handleSubmit.bind(this));
    this.searchFieldTarget.addEventListener("input", this.handleInput.bind(this));
  }

  showLoading() {
    this.searchButtonTarget.disabled = true;
  }

  hideLoading() {
    this.searchButtonTarget.disabled = false;
  }

  handleSubmit(event) {
    event.preventDefault();
    this.showLoading();

    const formData = new FormData(this.searchFormTarget);
    const queryString = new URLSearchParams(formData).toString();

    fetch(this.searchFormTarget.action + "?" + queryString, {
      method: "GET",
      headers: { "X-Requested-With": "XMLHttpRequest" },
    })
      .then((response) => response.text())
      .then((html) => {
        this.productsListTarget.innerHTML = new DOMParser()
          .parseFromString(html, "text/html")
          .querySelector("#products-list").innerHTML;
        this.hideLoading();
      })
      .catch((error) => {
        console.error("Error:", error);
        this.hideLoading();
      });
  }

  handleInput(event) {
    if (this.searchFieldTarget.value.trim() === "") {
      this.showLoading();
      this.searchFormTarget.requestSubmit();
    }
  }
}
