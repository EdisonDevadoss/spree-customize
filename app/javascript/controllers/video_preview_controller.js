import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['videoInput', 'existingVideo', 'removeVideoCheckbox'];

  preview() {
    const input = this.videoInputTarget;
    const file = input.files[0];

      if(file){
        const videoElement = document.createElement("video");
        videoElement.src = URL.createObjectURL(file);
        videoElement.width = 300;
        videoElement.controls = true;
        videoElement.autoplay =false;

           // Clear previous preview
      const previewContainer = document.getElementById('video-preview');
      previewContainer.innerHTML = "";
      previewContainer.appendChild(videoElement);

      this.hideExistingVideo();

      videoElement.addEventListener("loadeddata", ()=> {
        console.log('add Evnet listener is called');
        this.createThumbnail(videoElement)
      });
    }
  }

  hideExistingVideo(){
    if(this.hasExistingVideoTarget && this.hasRemoveVideoCheckboxTarget){
      this.existingVideoTarget.style.display = 'none';
      this.removeVideoCheckboxTarget.checked = true;
    }
  }

  createThumbnail(videoElement) {
    // Ensure the video is seeked to the start (or any desired timestamp)
    videoElement.currentTime = 0.5; // Capture a frame at 0.5 seconds

    videoElement.addEventListener('seeked', () => {
      const canvas = document.createElement('canvas');
      canvas.width = videoElement.videoWidth;
      canvas.height = videoElement.videoHeight;

      const context = canvas.getContext('2d');
      context.drawImage(videoElement, 0, 0, canvas.width, canvas.height);

      const thumbnail = canvas.toDataURL('image/png');
      
      // Display the thumbnail
      const imgElement = document.createElement('img');
      imgElement.src = thumbnail;
      imgElement.className = 'img-thumbnail mt-2';
      imgElement.style.height = '100px';
      imgElement.style.width = '100px';

      const previewContainer = document.getElementById('video-preview');
      previewContainer.innerHTML = ""; // Clear the video element
      previewContainer.appendChild(imgElement);
    }, { once: true }); // Ensure this event listener is only triggered once

    // Start seeking to trigger the `seeked` event
    videoElement.currentTime = 0.5;
  }
}
