import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.dismiss();
    }, 12000);
  }

  dismiss() {
    this.element.remove();
  }
}