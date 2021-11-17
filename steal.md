# Introduction
Downloading an image from chrome is usually as simple as "Save image as..." from the context menu.
However, when this isn't the case then a few different approaches exist depending on the problem.


# Techniques
## Covered Image
### Objective
Download [Jas's avatar](https://discord.com/channels/290843998296342529)

### Problem
The image element is covered by other elements

### Solution
- Inspect the image
- Recursively open children until you locate the image url
- If an element branches into multiple children then proceed with the child that keeps the image highlighted
- Choose "Open in new tab" from the image url context menu

![](https://cloud.orz.cx/pub/steal/context.png)

## CSS Background Image
### Objective
Download [Pikasonic's avatar](https://soundcloud.com/pika5onic)

### Problem
The image is set as the CSS background of an element

### Solution
- Inspect the image
- Locate the image url in the "Styles" docker
- Choose "Open in new tab" from the image url context menu

![](https://cloud.orz.cx/pub/steal/cssbg.png)

## Canvas Image
### Objective
Download a frame of [QYS3's animation](https://www.pixiv.net/en/artworks/71093875)

### Problem
The image is rendered by a canvas

### Solution
- Locate the canvas element
- Pass it to "download_canvas_frame"

```js

//Include function download(file, filename)

function download_canvas_frame(canvas) {
    download(canvas.toDataURL(), 'canvas.png')
}

```

## SVG Image
### Objective
Download an frame of [this car](https://lottiefiles.com/64152-car-animation)

### Problem
The image is svg embedded into the page source

### Solution
- Locate the svg element
- Pass it to "download_svg_frame"

```js

//Include function download(file, filename)

function download_svg_frame(svg) {
    var svgURL = new XMLSerializer().serializeToString(svg);
    var blob = new Blob(svgURL, {type: "data:image/svg+xml;"});
    download(URL.createObjectURL(blob), "image.svg")
}


```

## Canvas Video
### Objective
Download a video of [QYS3's animation](https://www.pixiv.net/en/artworks/71093875)

### Problem
The video is rendered by a canvas

### Solution
- Locate the canvas element
- Pass it to "download_canvas"
- Pass duration, fps and bitrate as well
```js

//Include function download(file, filename)

function download_canvas(canvas, duration, {fps = 60, bitrate = 25000000, callback = () => {}} = {}) {
    var stream = canvas.captureStream(fps);
    mediaRecorder = new MediaRecorder(stream, {mimeType: "video/webm; codecs=vp9", bitsPerSecond: bitrate});
    mediaRecorder.ondataavailable = (event) => {
        var blob = new Blob([event.data], {type: "video/webm"});
        download(URL.createObjectURL(blob), "canvas.webm")};
    mediaRecorder.start();
    setTimeout(event => {mediaRecorder.stop(), callback()}, duration);
    return 'Recording...';
}

```
Getting the video to loop perfectly is tricky.
"duration" parameter should not be relied upon for this, as it's somewhat innaccurate.
I recommend recording slightly more than a single loop, then cropping it in a seperate program.


## SVG Video
### Objective
Download a video of [this car](https://lottiefiles.com/64152-car-animation)

### Problem
The image is svg embedded into the page source

### Solution
- Locate the svg element
- Pass it to "download_frame"
- Pass duration, fps and bitrate as well

```js

//Include function download(file, filename)
//Include function download_canvas(file, filename)

function download_svg(svg, duration, {fps = 60, bitrate = 25000000} = {}) {
    var proxy = open("", "", "resizable, width=1, height=1");
    var canvas = proxy.document.createElement('canvas');
    canvas.height = svg.height.baseVal.value;
    canvas.width = svg.width.baseVal.value;
    proxy.document.body.appendChild(canvas);
    var ctx = canvas.getContext('2d');
    (function mirror() {
        addFrameToBuffer(ctx, canvas); // This keeps running forever even after closing window
        requestAnimationFrame(mirror);})();
    return download_canvas(canvas, duration, {fps:fps, bitrate:bitrate, callback:proxy.close});
}

function addFrameToBuffer(ctx, canvas) {
    var svgURL = new XMLSerializer().serializeToString(svg);
    var img = new Image();
    img.onload = () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height);  
      ctx.drawImage(img, 0, 0);};
    img.src = 'data:image/svg+xml; charset=utf8, ' + encodeURIComponent(svgURL); // Can we use blobs instead? What are blobs?
}
```

# Lottie animations
Lottie animations usually hide in a shadow root. Fetch them like so:
```js
document.getElementsByTagName("lottie-player")[index].shadowRoot.querySelector("svg")
```

# Headers
```js

function download(file, filename) {
    var a = document.createElement("a");
    a.style.display = "none";
    a.download = filename;
    a.href = file;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
}
```

https://user-images.githubusercontent.com/61394004/123454693-23ce1b80-d5e1-11eb-9c9f-011216556e02.mov






