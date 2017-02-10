#reCaptchaiOS

Easily integrate reCaptcha into an iOS app.

This is an example project that integrates Google's reCaptcha into an iOS application.  
It uses a WebKit view to load the website hosting the captcha, and replaces the page's content with just the captcha scaled to the screen.

The app's ViewController gets notified when:

 1. The captcha is ready to display
 2. The user has solved the captcha
 3. The captcha has expired
