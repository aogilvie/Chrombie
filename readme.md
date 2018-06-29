# About

This is a Debian based Docker container that contains Chrome (NOT Chromium) and Node.js to run Puppeteer scripts/tests.

### Why does this exist?

There are several projects that open a URL in a headless browser, but this project aims to provide a little extra whilst maintaining it's simplicity.

- It uses Chrome, not Chromium - some more complex features are not available in Chromium headless mode, such as WebRTC.
- This combines Puppeteer, so you can pass a script and write tests not just open a URL.

# Install Guide

- create your puppeteer script (e.g. `webtest.js`) see the following for sample (APIs are @ https://github.com/GoogleChrome/puppeteer/blob/master/docs/api.md)

```
(async() => {

    const browser = await puppeteer.launch({
        args: [
            '--no-sandbox',
            '--disable-setuid-sandbox'
        ],
        headless: true,
        executablePath: '/usr/bin/google-chrome'
    });

    const page = await browser.newPage();

    await page.goto('https://google.com', {waitUntil: 'networkidle2'});

    await page.screenshot({path: '/app/screenshots/screen.png', fullPage: true})

    // Get the "viewport" of the page, as reported by the page.
    const dimensions = await page.evaluate(() => {
        return {
            width: document.documentElement.clientWidth,
            height: document.documentElement.clientHeight,
            deviceScaleFactor: window.devicePixelRatio
        };
    });

    console.log('Dimensions:', dimensions);
    browser.close();

})();
```

- Build the container

`docker build -t my-webtest .`

- Run the docker container

`docker run --rm --name webtest -v $(pwd)/webtest.js:/app/src/index.js my-webtest`

- Taking screenshots:

# NOTE: in your webtest.js you must output screenshots to the correct output dir: "/app/screenshots/<your-filename>"
`docker run --rm --name webtest -v $(pwd)/screenshots:/app/screenshots -v $(pwd)/webtest.js:/app/src/index.js my-webtest`
