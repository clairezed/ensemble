class @DatePicker

  DEFAULT_OPTIONS:
    locale: 'fr'
    altInput: true
    altFormat: 'd/m/Y'
    # minDate: 'today'
    # dateFormat: 

  constructor: ($input = $("[data-is-datepicker]"), options = {}) ->
    @$input = $input
    @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)

    return @$input.flatpickr(@options)