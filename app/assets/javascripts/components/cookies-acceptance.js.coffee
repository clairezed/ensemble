class @CookiesAcceptance

  constructor: () ->
    console.log "cooky"
    @cookiesAcceptanceButton = document.querySelector('[data-is-accept-cookies]')
    @cookiesBannerContainerSelector = '[data-is-cookie-banner]'
    @addListener(@cookiesAcceptanceButton) if @cookiesAcceptanceButton

  addListener: (target) =>
    console.log "addListener"
    console.log target
    # Support for IE < 9
    if target.attachEvent
      target.attachEvent('onclick', @setCookie)
    else
      target.addEventListener('click', @setCookie, false)

  setCookie: =>
    Cookies.set 'cookies_ok_ensemble', true,
      path: '/'
      expires: 365
    container = document.querySelector(@cookiesBannerContainerSelector)
    container.parentNode.removeChild container