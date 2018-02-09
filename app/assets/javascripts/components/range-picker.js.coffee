class @RangePicker

  DEFAULT_OPTIONS:
    locale: 'fr'
    mode:   'range'
    altInput: true
    altFormat: 'j/m/Y'
    onClose: (selectedDates, dateStr, instance)->
      if !!dateStr
        selectedDates.push(selectedDates[0]) if selectedDates.length == 1
        instance.setDate(selectedDates)

  constructor: ($input = $("[data-is-rangepicker]"), options = {}) ->
    @$input = $input
    @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)

    return @$input.flatpickr(@options)