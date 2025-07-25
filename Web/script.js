const output = document.getElementById('output');

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