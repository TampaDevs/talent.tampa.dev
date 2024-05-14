import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["roleTypeSelect", "fixedFee", "salaryRange"];

  connect() {
    this.setupInitialVisibility();
  }

  setupInitialVisibility() {
    const selectedRadio = this.roleTypeSelectTargets.find(r => r.checked);
    if (selectedRadio) {
      this.toggleFieldsBasedOnValue(selectedRadio.value);
    }
  }

  toggleFieldsBasedOnValue(value) {
    const showFixedFee = ["part_time_contract", "full_time_contract"].includes(value);
    this.fixedFeeTarget.classList.toggle("hidden", !showFixedFee);

    const showSalaryRange = value === "full_time_employment";
    this.salaryRangeTarget.classList.toggle("hidden", !showSalaryRange);
  }

  toggleFields(event) {
    this.toggleFieldsBasedOnValue(event.target.value);
  }
}
