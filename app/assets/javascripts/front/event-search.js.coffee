class @EventSearch

  constructor: () ->
    console.log "EventSearch"
    citySelect  = new Select2Ajax()
    rangePicker = new RangePicker()
    leisureCheckboxes = new LeisureCheckboxes()

    $('[data-date-clear]').on 'click', =>
      rangePicker.clear()

