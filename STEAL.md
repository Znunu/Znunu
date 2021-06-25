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
