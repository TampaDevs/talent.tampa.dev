import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fixedFee", "salaryRange", "roleType"]
  
  connect() {
  console.log("ContractType controller connected");
}

  toggle(event) {
    const isContract = event.target.value.includes("contract");

    this.fixedFeeTarget.classList.toggle("hidden", !isContract);
    this.salaryRangeTarget.classList.toggle("hidden", isContract);
  }
}
