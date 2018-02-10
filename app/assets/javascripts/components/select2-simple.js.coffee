class @Select2Simple

  DEFAULT_OPTIONS:
    debug: true
    placeholder: "Rechercher..."
    language: {
      errorLoading: ->
        return 'Les résultats ne peuvent pas être chargés.'
      inputTooLong: (args) ->
        overChars = args.input.length - args.maximum
        return "Supprimez #{overChars} caractère#{if overChars > 1 then 's' else ''}"
      inputTooShort: (args) ->
        remainingChars = args.minimum - args.input.length
        return "Saisissez au moins #{remainingChars} caractère#{if remainingChars > 1 then 's' else ''}"
      loadingMore: ->
        return 'Chargement de résultats supplémentaires…'
      maximumSelected: (args) ->
        return 'Vous pouvez seulement sélectionner ' + args.maximum + ' élément' + (args.maximum > 1) ? 's' : ''
      noResults: ->
        return 'Aucun résultat trouvé'
      searching: ->
        return 'Recherche en cours…'
      }

  constructor: ($input, options = {}) ->
    @$input = $input
    @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)
    return @$input.select2(@options)


