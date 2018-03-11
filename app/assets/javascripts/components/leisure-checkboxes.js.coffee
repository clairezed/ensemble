class @LeisureCheckboxes

  constructor: () ->

    checkActiveCategory=  () ->
      activeLeisureCategories = $('[data-is-leisure-input]').filter(":checked").parents('[data-leisure-row]').map(->
        activeLeisureCategory = $(this).data('leisure-row')
        return $("[data-leisure-category='#{activeLeisureCategory}']")
      )
      $("[data-leisure-category]").removeClass('active')
      for leisureCategory in activeLeisureCategories
        leisureCategory.addClass('active')

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
      checkActiveCategory()

    $("[data-toggle-up]").on 'click', ->
      # hide leisure blocks
      $(this).parents('[data-leisure-row]').removeClass('toggled')
      # remove leisure category toggled class
      currentCategory = $(this).data('toggle-up')
      $("[data-leisure-category='#{currentCategory}']").removeClass('toggled')
      checkActiveCategory()