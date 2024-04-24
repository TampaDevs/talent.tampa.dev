// app/javascript/controllers/role_type_controller.js
import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["roleTypeSelect", "fixedFee", "salaryRange"];

  toggleFields() {
    const selectedValue = this.roleTypeSelectTarget.value.replace(/_/g, ' ').toLowerCase();

    this.fixedFeeTarget.classList.toggle("hidden", !["part time contract", "full time contract"].includes(selectedValue));
    this.salaryRangeTarget.classList.toggle("hidden", selectedValue !== "full time employment");
  }
}
