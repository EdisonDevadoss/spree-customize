import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['button'];

  connect() {
    this.originalButtonText = this.buttonTarget.value;
  }

  submit(event) {
    event.preventDefault();

    this.buttonChange('Submitting...', true);
    this.hideErrorDiv();

    setTimeout(() => {
      fetch(this.element.action, {
        method: this.element.method,
        body: new FormData(this.element),
        headers: {
          'X-CSRF-Token': document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute('content')
        }
      })
        .then((response) => {
          if (!response.ok) throw response;
          return response.json();
        })
        .then((data) => {
          if (data.redirect_url) {
            window.location.href = data.redirect_url;
          }
        })
        .catch((error) => {
          error
            .json()
            .then((err) => {
              this.addErrorMessage(err);
              this.buttonChange(this.originalButtonText, false);
            })
            .catch(() => {
              this.buttonChange(this.originalButtonText, false);
            });
        });
    }, 1000);
  }

  addErrorMessage(err) {
    const errorDiv = document.createElement('div');
    errorDiv.className = 'alert alert-danger';
    errorDiv.innerText = err.errors.join(', ');
    this.element.prepend(errorDiv);
  }

  hideErrorDiv() {
    const alertDiv = document.querySelector('.alert');
    if (alertDiv) {
      alertDiv.style.display = 'none';
    }
  }

  buttonChange(text, toogle) {
    this.buttonTarget.value = text;
    this.buttonTarget.disabled = toogle;
  }
}
