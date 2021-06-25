# Introduction
Downloading an image from chrome is usually as simple as "Save image as..." from the context menu.
However, when this isn't the case then a few different approaches exist depending on the problem.


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
- Locate the svg element
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
    svgURL = new XMLSerializer().serializeToString(svg);
    download('data:image/svg+xml; charset=utf8, ' + encodeURIComponent(svgURL), 'image.svg')
}


```

## Headers
```js

function download(file, filename) {
    var a = document.createElement("a");
    element.style.display = "none";
    a.download = filename;
    a.href = file;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(element);
}
```


