class @TimePicker

  DEFAULT_OPTIONS:
    enableTime: true
    noCalendar: true
    dateFormat: "H:i"
    time_24hr: true

  constructor: ($input = $("[data-is-timepicker]"), options = {}) ->
    @$input = $input
    @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)

    return @$input.flatpickr(@options)