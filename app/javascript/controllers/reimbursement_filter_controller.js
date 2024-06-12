import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    console.log("ReimbursementFilterController connected");
    this.element.addEventListener("submit", this.handleSubmit.bind(this));
  }

  handleSubmit(event) {
    const minField = this.element.querySelector("#reimbursement_min");
    const maxField = this.element.querySelector("#reimbursement_max");

    console.log("handleSubmit triggered");
    console.log("minField value before check:", minField.value);
    console.log("maxField value before check:", maxField.value);

    if (minField.value.trim() === "" && maxField.value.trim() === "") {
      minField.removeAttribute("name");
      maxField.removeAttribute("name");
      console.log("Both fields are empty, name attributes removed");
    }

    // Log the form data to check if the name attributes were removed
    const formData = new FormData(this.element);
    for (let pair of formData.entries()) {
      console.log(pair[0] + ': ' + pair[1]);
    }
  }
}
