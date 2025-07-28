const output = document.getElementById('output');

const nativeStatusEl = document.getElementById("native-status");
const nativeButton = document.getElementById("requestNativePermission");

// Send message to native app
nativeButton.addEventListener("click", () => {
  if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.nativePermission) {
    window.webkit.messageHandlers.nativeChannel.postMessage(REQUEST_NATIVE_PERMISSION);
  }
});

// Receive message from Swift
window.onNativePermissionResponse = function (status) {
  nativeStatusEl.textContent = "Native permission: " + status;
};

document.getElementById('requestPermission').addEventListener('click', () => {
  if (typeof DeviceOrientationEvent.requestPermission === 'function') {
    DeviceOrientationEvent.requestPermission()
      .then(response => {
        if (response === 'granted') {
          window.addEventListener('deviceorientation', event => {
            const x = event.beta?.toFixed(2);
            const y = event.gamma?.toFixed(2);
            const z = event.alpha?.toFixed(2);
            output.innerText = `X: ${x}, Y: ${y}, Z: ${z}`;
          });
        } else {
          output.innerText = 'Permission denied.';
        }
      })
      .catch(err => {
        output.innerText = 'Error: ' + err;
      });
  } else {
    // Fallback for older iOS versions
    window.addEventListener('deviceorientation', event => {
      const x = event.beta?.toFixed(2);
      const y = event.gamma?.toFixed(2);
      const z = event.alpha?.toFixed(2);
      output.innerText = `X: ${x}, Y: ${y}, Z: ${z}`;
    });
  }
});