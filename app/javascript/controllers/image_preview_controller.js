import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['imgInput'];

  initialize() {
    this.previousFiles = [];
    this.cropper = null; // Store Cropper instance
    this.currentAspectRatio = 1;
  }

  preview() {
    const input = this.imgInputTarget;
    const files = Array.from(input.files);
    const allFiles = [...this.previousFiles, ...files];

    // Check for max files limit
    if (allFiles.length > 10) {
      alert('You can only upload a maximum of 10 images.');
      input.value = ''; // Clear selected files
      return;
    }

    this.previousFiles = allFiles; // Update the array of files
    this.renderPreview();
  }

  // Method to remove an image from the list
  removeImage(index) {
    this.previousFiles.splice(index, 1);
    this.renderPreview();
  }

  // Method to render the preview with the remove buttons
  renderPreview() {
    const preview = document.getElementById('image-preview');
    preview.innerHTML = ''; // Clear existing previews

    const dataTransfer = new DataTransfer();

    this.previousFiles.forEach((file, index) => {
      dataTransfer.items.add(file);

      const imgWrapper = document.createElement('div');
      imgWrapper.className = 'img-wrapper position-relative d-inline-block m-2';

      const img = document.createElement('img');
      img.src = URL.createObjectURL(file);
      img.className = 'img-thumbnail';
      img.style.height = '100px';
      img.style.width = '100px';
      img.dataset.index = index;

      const cropIcon = document.createElement('div');
      cropIcon.innerHTML = `
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-crop" viewBox="0 0 16 16">
      <path d="M3.5.5A.5.5 0 0 1 4 1v13h13a.5.5 0 0 1 0 1h-2v2a.5.5 0 0 1-1 0v-2H3.5a.5.5 0 0 1-.5-.5V4H1a.5.5 0 0 1 0-1h2V1a.5.5 0 0 1 .5-.5m2.5 3a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v8a.5.5 0 0 1-1 0V4H6.5a.5.5 0 0 1-.5-.5"/>
      </svg>
      `;
      cropIcon.className = 'crop-icon position-absolute top-0 end-0';
      cropIcon.style.cursor = 'pointer';
      cropIcon.onclick = (e) => this.openCropModal(e, file, index);

      const removeBtn = document.createElement('div');
      removeBtn.innerHTML = '&times;';
      removeBtn.className = 'btn-delete position-absolute top-0 end-0';
      removeBtn.style.padding = '0px';
      removeBtn.onclick = () => this.removeImage(index);

      imgWrapper.appendChild(img);
      imgWrapper.appendChild(removeBtn);
      imgWrapper.appendChild(cropIcon);
      preview.appendChild(imgWrapper);
    });

    // Attach updated files back to the input element
    this.imgInputTarget.files = dataTransfer.files;
  }

  openCropModal(event, file, index) {
    const modal = document.getElementById('crop-modal');
    const image = document.getElementById('crop-image');
    const cropButton = document.getElementById('crop-button');

    // Reset the modal content
    image.src = URL.createObjectURL(file);

    // Show modal
    const modalInstance = new bootstrap.Modal(modal);
    modalInstance.show();

    // Initialize cropper
    if (this.cropper) {
      this.cropper.destroy(); // Destroy previous cropper instance
    }

    this.cropper = new Cropper(image, {
      aspectRatio: this.currentAspectRatio,
      viewMode: 1,
      dragMode: 'move',
      rotatable: true,
      checkOrientation: true,
      cropBoxResizable: true,
      autoCropArea: 1,
      minContainerHeight: 400,
      minContainerWidth: 400,
      minCanvasWidth: 400,
      minCanvasHeight: 400,
      background: false
    });

    // Handle crop button click
    cropButton.onclick = () => {
      const canvas = this.cropper.getCroppedCanvas();
      const croppedImage = canvas.toDataURL();

      // Create a new File object for the cropped image
      const croppedFile = this.dataURLtoFile(croppedImage, file.name);
      
      // Replace old file with cropped file
      this.previousFiles[index] = croppedFile;
      this.renderPreview();

      // Hide modal
      modalInstance.hide();
    };

    document.querySelectorAll('.aspect-ratio-buttons .btn').forEach((button) => {
      button.onclick = (e) => {
        const aspectRatio = e.target.getAttribute('data-aspect-ratio');
        this.currentAspectRatio = aspectRatio === 'free' ? NaN : parseFloat(aspectRatio);
        this.cropper.setAspectRatio(this.currentAspectRatio);
      };
    });
  }

  dataURLtoFile(dataurl, filename) {
    const arr = dataurl.split(',');
    const mime = arr[0].match(/:(.*?);/)[1];
    let bstr = atob(arr[1]);
    let n = bstr.length;
    let u8arr = new Uint8Array(n);
    while (n--) {
      u8arr[n] = bstr.charCodeAt(n);
    }
    return new File([u8arr], filename, { type: mime });
  }
}
