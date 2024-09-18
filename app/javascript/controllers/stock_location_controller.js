import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['state'];

  connect() {
    
  }

  selectCountry(event){
    const selectedCountry = event.target.value;

    console.log('selectedCountry is', selectedCountry);

    this.stateTarget.value = ""; 

    const stateOptions = Array.from(this.stateTarget.options);

    // Log each state's value and label (optional)
    stateOptions.forEach(option => {
        const countryId = option.dataset.countryId; // Access country_id from data attribute
        console.log(`State: ${option.value} - ${option.text} - Country ID: ${countryId}`);
        
        if (option.value === "" || countryId === selectedCountry) {
            option.disabled = false;  // Enable the valid options
            option.hidden = false;    // Show the valid options
          } else {
            option.disabled = true;   // Disable the invalid options
            option.hidden = true;     // Hide the invalid options
          }
    });

  }

}