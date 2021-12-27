Problem: You've written code that searches for some specific elements, but bs doesn't seem to find them

The best way to find these bugs is to explore the HTML file interactively.
## Method 1
Open the webpage in your favorite browser, then use the console and JS to locate the elements.
The most useful commands, for this purpose, start with `document.query*` or `document.get*`
## Method 2
Download the page, then locate the elements using the python REPL.
```python
import httpx, bs4
document = bs4.BeautifulSoup(httpx.get("https://example.com"))
> enter here
```
## Extra
Note that in general, a webpage has two different modes. The page may be very different, between these two.
The first mode is the raw source. You get this by requesting the page.
The second mode has been processed by JS. You get this with selenium.
Sometimes it makes sense to request the page, save it, then open it with a browser
