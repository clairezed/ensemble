class @RangePicker

  DEFAULT_OPTIONS:
    locale: 'fr'
    mode:   'range'
    altInput: true
    altFormat: 'j/m/Y'
    # dateFormat: 

  constructor: ($input = $("[data-is-rangepicker]"), options = {}) ->
    @$input = $input
    @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)

    @$input.flatpickr(@options)