class @EventSearch

  constructor: () ->
    # console.log "EventSearch"
    citySelect  = new Select2Ajax()
    rangePicker = new RangePicker($("[data-is-rangepicker]"), {
      position: "below"
      onChange: (selectedDates, dateStr, instance)->
        if !!dateStr
          $('[data-date-close]').removeClass('disabled')
        else
          $('[data-date-close]').addClass('disabled')
      })
    leisureCheckboxes = new LeisureCheckboxes()


    $('[data-date-clear]').on 'click', =>
      rangePicker.clear()
    $('[data-date-close]').on 'click', =>
      rangePicker.close()
      $('[data-date-close]').addClass('disabled')

