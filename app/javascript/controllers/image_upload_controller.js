import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['field']

  upload() {
    // var image_field = document.querySelector('#micropost_image');
    var image_field = this.fieldTarget;
    var size_in_megabytes = image_field.files[0].size/1024/1024

    if(size_in_megabytes > 5) {
      alert('Maximum file size is 5MB. Please choose a smaller file.');
      image_field.value = '';
    }
  }
}
