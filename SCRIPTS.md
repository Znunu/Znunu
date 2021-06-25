## Script for setting a background image on Discord

- Pick a background image
- Upload it to either Discord or Imgur
- Copy the direct link to the image
- Replace {image} in the script below, with your link
```js
img="{image}",document.getElementsByTagName("body")[0].addEventListener("mouseup",()=>{window.setTimeout(()=>{for(opening=document.querySelector('section[aria-label="Channel header"] ~ div'),opening.setAttribute("style","background-image: url("+img+"); background-size: cover;"),i=0;i<4;i++)opening.firstElementChild.className.includes("newMessagesBar")?opening=opening.childNodes[1]:opening=opening.childNodes[0],opening.setAttribute("style","background-color: transparent")},0)});
```
- Open the console in the chrome inspector
- Run the script
- The background image will stay until you reload your browser or client

## Downloading images of the sticker store or sticker archive

- Open the page with the sticker package you wish to download e.g. [this page](https://store.line.me/stickershop/product/3172/en)
- Copy and paste the following script, then run it with enter
```js
function goTo(e){element=document.createElement("a"),element.setAttribute("href",e),element.style.display="none",document.body.appendChild(element),element.click()}for(child of(urls="",children=document.getElementsByClassName("FnStickerList")[0].children,children))bgStyle=child.getElementsByClassName("FnPreview")[0].style.backgroundImage,url=/sticker\/(.*)\/android/.exec(bgStyle)[1],urls=urls+url+"_";urls=urls.slice(0,-1),console.log(urls),goTo("https://stickershop.line-scdn.net/?images="+urls);
```
- You'll be taken to a new page, with an "404" error
- Open the console again and run
```js
function download(e,t){element=document.createElement("a"),element.setAttribute("href",t),element.setAttribute("download",e),element.style.display="none",document.body.appendChild(element),element.click(),document.body.removeChild(element)}function loop(){setTimeout(()=>{download("sticker"+counter,"https://stickershop.line-scdn.net/stickershop/v1/sticker/"+images[counter]+"/android/sticker.png"),counter++,counter<images.length?loop():(console.log("Success"),counter=0)},100)}counter=0,images=/\?images=(.*)/.exec(window.location.href)[1].split("_"),counter=0,loop();
```
- The stickers will download

## Convert 12 H time to 24 H in discord

- Copy, paste and run
```js
setInterval(
    () => {
        var messages = document.getElementsByClassName("timestampInline-yHQ6fX")
        for (var message of messages) {
            prevText = message.firstElementChild.lastChild.textContent.split(" ")
            var time = new Date(message.firstElementChild.dateTime)
            if (prevText.length > 1) {
                var newFormat = `${prevText[0]} at ${time.getHours().toString().padStart(2, "0")}:${time.getMinutes().toString().padStart(2, "0")}`
                message.firstElementChild.lastChild.textContent = newFormat
            }
        }
        console.log("Redrawing TimeFormat")
    },
    1000
)

```

## Like every post on Facebook, LindedIn, etc

- For use with TamperMonkey
```js
// ==UserScript==
// @name         Init/Start/Stop Autoliker
// @grant        none
// @run-at       context-menu
// ==/UserScript==


"use strict"
if (typeof window.wasInit == "undefined") {
    window.autoLiker = {
        counter: 0,
        toRun: true,
        timeOut: 1000,
        query: "",

        sleep: function(ms) {
            return new Promise((res) => setTimeout(res, ms))
        },

        run: async function() {
            if (this.query == "") {
                console.log("Please set a target")
                return 0
            }

            this.toRun = true
            let lastLen = 0
            console.log("%cStarted!", "color: green; font-size: 2em")

            while (this.toRun) {
                await this.sleep(this.timeOut)
                window.scrollBy(0, 100000)
                const likes = document.querySelectorAll(this.query)
                console.log("New cache: " + likes.length)

                if (likes.length == lastLen) {
                    console.log("Reached end")
                    this.stop()
                }

                lastLen = likes.length
                for (; this.counter < likes.length; this.counter++) {
                    const i = this.counter

                    await this.sleep(this.timeOut)
                    console.log("Clicked: " + i)
                    likes[i].click()
                }
            }
            return 1
        },

        setTarget: function(target) {
            switch (target.toLowerCase()) {
                case "facebook":
                    this.query = '[aria-label="Like"]:not([href])'
                    break
                case "linkedin":
                    this.query = '.react-button__trigger[aria-pressed="false"]'
                    break
                default:
                    console.log("Target not supported")
                    return
            }
            console.log("New target assigned")
        },

        stop: function() {
            if (!this.toRun) {
                console.log("Nothing to stop")
                return
            }
            this.toRun = false
            console.log("Stopping...")
        },

        reset: function() {
            this.counter = 0
        },

        start: function() {
            this.run().then((res) => {
                if (res == 1) console.log("%cStopped!", "color: red; font-size: 2em;")
                window.isRunning = false
            })
        },
    }
    const url = window.location.href.toLocaleLowerCase()
    if (url.includes("facebook")) {
        window.autoLiker.setTarget("facebook")
    } else if (url.includes("linkedin")) {
        window.autoLiker.setTarget("linkedin")
    }
    window.isRunning = false
    window.wasInit = true
    console.log("%cInitialized!", "color: blue; font-size: 2em")
} else {
    if (!window.isRunning) {
        window.autoLiker.start()
        window.isRunning = true
    } else {
        window.autoLiker.stop()
    }
}
```



