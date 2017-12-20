class @Select2Ajax


  constructor: (inputSelector = '[data-is-ajax-select2]', options = {}) ->
    @$autocompleteInput = $(inputSelector)
    path = @$autocompleteInput.data('path')

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
    
    @options = $.extend(true, {}, specificOptions, options)


    return new Select2Simple(@$autocompleteInput, @options)
