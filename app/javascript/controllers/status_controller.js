import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  update(event) {
    const newStatus = event.target.value;
    const applicationId = this.element.dataset.statusApplicationIdParam;
    const jobPostId = this.element.dataset.statusJobPostIdParam;
    const url = `/jobs/${jobPostId}/update_application_status/${applicationId}`;

    // Confirmation prompt
    if (!confirm(`Are you sure you want to change the status to ${newStatus}?`)) {
      return;
    }

    fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({ status: newStatus })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        location.reload(); // Reload the page upon successful update
      } else {
        alert('Failed to update status.');
      }
    })
    .catch(error => console.error('Error:', error));
  }
}
