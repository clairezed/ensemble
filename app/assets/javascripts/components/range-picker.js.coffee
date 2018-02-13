class @RangePicker

  DEFAULT_OPTIONS:
    mode:   'range'
    locale: 'fr'
    onClose: (selectedDates, dateStr, instance)->
      if !!dateStr
        selectedDates.push(selectedDates[0]) if selectedDates.length == 1
        instance.setDate(selectedDates)
    # onChange: (selectedDates, dateStr, instance)->
    #   console.log "hey"
    #   if !!dateStr
    #     console.log "ho"
    #     $('[data-date-close]').show()
    #   else
    #     $('[data-date-close]').hide()

  constructor: ($input = $("[data-is-rangepicker]"), options = {}) ->
    @$input = $input
    @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)

    return @$input.flatpickr(@options)

