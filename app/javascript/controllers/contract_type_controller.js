import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fixedFee", "salaryRange", "roleType"]

  connect() {
    this.updateFields();
  }

  updateFields() {
    const roleTypeValue = this.roleTypeTarget.querySelector('input[type="radio"]:checked').value;
    const isContract = roleTypeValue === "part_time_contract" || roleTypeValue === "full_time_contract";
    this.fixedFeeTarget.classList.toggle("hidden", !isContract);
    this.salaryRangeTarget.classList.toggle("hidden", isContract);
  }

  toggle() {
    this.updateFields();
  }
}




