(function() {
    var RECAPTCHA_SITE_KEY = 'your_site_key';
    var RECAPTCHA_THEME = 'dark';

    var PAGE_BG_COLOR = '#222';

    function waitReady() {
        if (document.readyState == 'complete')
            documentReady();
        else
            setTimeout(waitReady, 100);
    }

    function documentReady() {
        while (document.body.lastChild)
            document.body.removeChild(document.body.lastChild);

        var div = document.createElement('div');

        div.style.position = 'absolute';
        div.style.top = '50%';
        div.style.left = 'calc(50% - 151px)';

        document.body.style.backgroundColor = PAGE_BG_COLOR;
        document.body.appendChild(div);

        var meta = document.createElement('meta');

        meta.setAttribute('name', 'viewport');
        meta.setAttribute('content', 'width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0');

        document.head.appendChild(meta);

        showCaptcha(div);
    }

    function showCaptcha(el) {
        try {
            grecaptcha.render(el, {
                'sitekey': RECAPTCHA_SITE_KEY,
                'theme': RECAPTCHA_THEME,
                'callback': captchaSolved,
                'expired-callback': captchaExpired,
            });

            window.webkit.messageHandlers.reCaptchaiOS.postMessage(["didLoad"]);
        } catch (_) {
            window.setTimeout(function() { showCaptcha(el) }, 50);
        }
    }

    function captchaSolved(response) {
        window.webkit.messageHandlers.reCaptchaiOS.postMessage(["didSolve", response]);
    }

    function captchaExpired(response) {
        window.webkit.messageHandlers.reCaptchaiOS.postMessage(["didExpire"]);
    }

    waitReady();
 })();
