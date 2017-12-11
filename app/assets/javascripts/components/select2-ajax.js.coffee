class @Select2Ajax

  constructor: () ->
    $autocompleteInput = $('[data-is-ajax-select2]')
    path = $autocompleteInput.data('path')

    specificOptions = {
      ajax:
        url: path
        dataType: 'json'
        data: (params) ->
          query =
            by_val: params.term
        processResults: (data) ->
          { results: data }
    }
    return new Select2Simple($autocompleteInput, specificOptions)
