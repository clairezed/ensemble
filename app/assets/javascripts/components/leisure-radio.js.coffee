class @LeisureRadio

  constructor: () ->

    checkActiveCategory=  () ->
      activeLeisureCategory = $('[data-is-leisure-input]').filter(":checked").parents('[data-leisure-row]').data('leisure-row')
      $("[data-leisure-category]").removeClass('active')
      $("[data-leisure-category='#{activeLeisureCategory}']").addClass('active')
    

    checkActiveCategory()

    $("[data-leisure-category]").on 'click', ->
      # Manage category class ---------------------------
      $("[data-leisure-category]").not(this).removeClass('toggled')
      $(this).toggleClass('toggled')
      # display category leisures -----------------------
      currentCategory = $(this).data('leisure-category')
      currentLeisureBlock = $("[data-leisure-row='#{currentCategory}']")
      $("[data-leisure-row]").not(currentLeisureBlock[0]).removeClass('toggled')
      currentLeisureBlock.toggleClass('toggled')
      # Check classActive
      checkActiveCategory()

    $("[data-toggle-up]").on 'click', ->
      console.log "[data-toggle-up]"
      # hide leisure blocks
      $(this).parents('[data-leisure-row]').removeClass('toggled')
      # remove leisure category toggled class
      currentCategory = $(this).data('toggle-up')
      $("[data-leisure-category='#{currentCategory}']").removeClass('toggled')
      # Check classActive
      checkActiveCategory()
