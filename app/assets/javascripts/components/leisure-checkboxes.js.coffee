class @LeisureCheckboxes

  constructor: () ->
    console.log "LeisureCheckboxes"
    $("[data-toggle-leisures]").on 'click', ->
      # Manage category class ---------------------------
      $("[data-toggle-leisures]").not(this).removeClass('toggled')
      $(this).toggleClass('toggled')
      # display category leisures -----------------------
      currentCategory = $(this).data('toggle-leisures')
      currentLeisureBlock = $("[data-leisure-row='#{currentCategory}']")
      $("[data-leisure-row]").not(currentLeisureBlock[0]).removeClass('toggled')
      currentLeisureBlock.toggleClass('toggled')

    $("[data-toggle-up]").on 'click', ->
      console.log "[data-toggle-up]"
      # hide leisure blocks
      $(this).parents('[data-leisure-row]').removeClass('toggled')
      # remove leisure category toggled class
      currentCategory = $(this).data('toggle-up')
      $("[data-toggle-leisures='#{currentCategory}']").removeClass('toggled')