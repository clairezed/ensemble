class @ParticipantsCountSlider

  DEFAULT_OPTIONS:
    min: 1
    max: 50
    grid: false,
    force_edges: true


  constructor: ($input = $("[data-is-slider]"), options = {}) ->
    @$input = $input
    @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)

    return @$input.ionRangeSlider(@options)