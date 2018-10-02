 (function() {
  var RECAPTCHA_SITE_KEY = 'reCaptcha-key-of-your-site';
  var RECAPTCHA_THEME = 'white';
  
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

  document.body.appendChild(div);
  
  var meta = document.createElement('meta');
  
  meta.setAttribute('name', 'viewport');
  meta.setAttribute('content', 'width=device-width, initial-scale=0.88, maximum-scale=1, user-scalable=0');
  
  //iPhone SE
  //meta.setAttribute('content', 'width=device-width, initial-scale=0.88, maximum-scale=1, user-scalable=0');
  
  //iPhone 8 plus
  //approximately meta.setAttribute('content', 'width=device-width, initial-scale=1.06, maximum-scale=1.5, user-scalable=0');
  
  document.head.appendChild(meta);
  
  showCaptcha(div);
  }
  
  function showCaptcha(el) {
  try {
  grecaptcha.render(el, {
                    'sitekey': RECAPTCHA_SITE_KEY,
                    'theme': RECAPTCHA_THEME,
                    'callback': captchaSolved,
                    'hl': 'pt-BR',
                    'expired-callback': captchaExpired,
                    });
  
  window.webkit.messageHandlers.reCaptcha.postMessage(["didLoad"]);
  } catch (_) {
    window.setTimeout(function() { showCaptcha(el) }, 50);
  }
  }
  
  function captchaSolved(response) {
  window.webkit.messageHandlers.reCaptcha.postMessage(["didSolve", response]);
  }
  
  function captchaExpired(response) {
  window.webkit.messageHandlers.reCaptcha.postMessage(["didExpire"]);
  }
  
  waitReady();
  })();

