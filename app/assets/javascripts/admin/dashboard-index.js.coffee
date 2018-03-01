class @DashboardIndex

  constructor: () ->
    @beginAt = undefined
    @endAt = undefined
    @data = undefined
    @ctx = document.getElementById("eventChart").getContext('2d')

    @initEmptyChart()
    @bindFormEvents()
    # data initialization
    $("[data-filter-period-btn]").click()


  initEmptyChart: =>
    @eventsChart = new Chart(@ctx,
      type: 'bar'
      data: {}
      options: 
        scales: 
          yAxes: [
            ticks: beginAtZero: true
          ]
      )

  renderChart: =>
    @eventsChart.data = @data
    @eventsChart.update()

  bindFormEvents: =>
    $(document)
      .on('ajax:success', '[data-filter-period]', (event) =>
        # console.log "success"
        result = event.detail[0]
        @data = result.data
        # console.log @data
        @renderChart()
      )  
      .on('ajax:error', '[data-filter-period]', (event) =>
        console.log "error"
        detail = event.detail
        console.log detail
        xhr = detail[2]
        console.log xhr
      )