# Intro

The connection to the server is initialized. It uses a websocket at `/signalr/connect` to communicate
```html
<script src="/signalr/hubs"></script>
```
It can be accessed as`$.connection.editorHub.server`

<br>

The presenter is initialized. The first option is the slide ID, the second is a token and the third is whether to add ad slides(!)
```html
<script src="/Scripts/presenter.js?v=3"></script>
<script>
   var $$ = new $.Presenter(1721,0,"",false,true);
   ko.applyBindings($$);
   $$.LogAction(11426563);
</script>
```
It can be accessed as`window.$$`

The presenter constructor binds it's `LoadSlides` function to the server object, then calls getSlides on it.
getSlides sends a message through the webhook. The webhook replies with an array of slides as well as the string 'LoadSlides'.
This instructs the server object to call the `LoadSlides` function, passing the array.

Clicking the button for next slide, calls the `ShowNextSlide` function on the presenter

# How to rip slides

## Console tab

Get the current slide or all slides
```js
$$.Slides()[$$.CurrentSlide()]
```
## Network tab
Look for the websocket connection at `/signalr/connect`. Then look for a message orders of magnitude larger than the rest (on of the first messages)




# BIB OS
bib os is a python module which is installed on clients.
The python module connects to a server on a loop.
It gets tasks and sends back the results of them.

## bibos_config.py
This is a python selve like module that controls the config.
One of the things it contains is the adress to connect to.
It sets it own permission such that only root can view it.


