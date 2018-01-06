class @ParticipantsCountSlider

  DEFAULT_OPTIONS:
    type: 'double'
    min: 1
    max: 50
    grid: false,
    force_edges: true
    values_separator: ' - '
    onFinish: (data) =>
      @setFinished(data)

  constructor: ($input = $("[data-is-slider]"), options = {}) ->
    @$input = $input
    @$min = $("[data-is-participants='min']")
    @$max = $("[data-is-participants='max']")
    @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)
    @initValues()

    return @$input.ionRangeSlider(@options)

  @setFinished: (data) =>
    console.log "setFinished"
    $("[data-is-participants='min']").val(data.from)
    $("[data-is-participants='max']").val(data.to)

  initValues: =>
    from  = if @$min.val() == '' then 1   else @$min.val()
    to    = if @$max.val() == '' then 10  else @$max.val()
    @options['from'] = from
    @options['to'] = to
    $("[data-is-participants='min']").val(from)
    $("[data-is-participants='max']").val(to)