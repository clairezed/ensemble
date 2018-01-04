class @ApplicationMenu

  constructor: () ->

    # elements for open/close right menu
    @$rightMenuOpen    = $("[data-display-menu='open']")
    @$rightMenuClose   = $("[data-display-menu='close']")
    @$rightMenu        = $("[data-is-menu]")

    # bind events
    @bindEvents()

  
  # Events 
  bindEvents: () ->
    self = this

    # open or close right menu on click on burger btn
    @$rightMenuOpen.on 'click', () -> 
      self.$rightMenu.toggleClass 'open'  

    # close right menu on click on close btn
    @$rightMenuClose.on 'click', () -> 
      self.$rightMenu.removeClass 'open'