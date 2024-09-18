import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = [
    'individualBtn',
    'businessSec',
    'businessBtn',
    'accountNumber',
    'accountNumBtn',
    'confirmAccountNumber',
    'confirmAccountNumBtn'
  ];

  connect() {
    this.checkBoxToogle();
  }

  checkBoxToogle() {
    if (!this.individualBtnTarget.checked && !this.businessBtnTarget.checked) {
      this.individualBtnTarget.checked = true;
      this.businessSecTarget.hidden = true;
    } else if (this.individualBtnTarget.checked) {
      this.businessSecTarget.hidden = true;
    }
  }

  indivClick() {
    this.businessSecTarget.hidden = true;
  }

  businessClick() {
    this.businessSecTarget.hidden = false;
  }

  setPlainMode(textBox, toogleButton) {
    const eyeIcon = toogleButton.querySelector('#eyeIcon');
    const eyeSlashIcon = toogleButton.querySelector('#eyeSlashIcon');

    textBox.type = 'text';
    eyeIcon.style.display = 'none';
    eyeSlashIcon.style.display = 'inline';
  }

  setPasswordMode(textBox, toogleButton) {
    const eyeIcon = toogleButton.querySelector('#eyeIcon');
    const eyeSlashIcon = toogleButton.querySelector('#eyeSlashIcon');
    textBox.type = 'password';
    eyeIcon.style.display = 'inline';
    eyeSlashIcon.style.display = 'none';
  }

  toogleAccountNum() {
    if (this.accountNumberTarget.type == 'password') {
      this.setPlainMode(this.accountNumberTarget, this.accountNumBtnTarget);
    } else {
      this.setPasswordMode(this.accountNumberTarget, this.accountNumBtnTarget);
    }
  }

  toogleConfirmAccountNum() {
    if (this.confirmAccountNumberTarget.type == 'password') {
      this.setPlainMode(
        this.confirmAccountNumberTarget,
        this.confirmAccountNumBtnTarget
      );
    } else {
      this.setPasswordMode(
        this.confirmAccountNumberTarget,
        this.confirmAccountNumBtnTarget
      );
    }
  }
}
