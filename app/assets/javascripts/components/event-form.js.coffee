class @EventForm

  constructor: () ->
    console.log "EventForm"
    citySelect = new Select2Ajax()
    start_datepicker = new DatePicker($('[data-date-picker="start"]'))
    start_timepicker = new TimePicker($('[data-time-picker="start"]'))
    end_datepicker = new DatePicker($('[data-date-picker="end"]'))
    end_timepicker = new TimePicker($('[data-time-picker="end"]'))
    wysiwyg = new QuillWysiwyg()
    # # Image ----------------------------------------
    # # Affichage du nom du fichier choisi 
    # # dans le bouton de téléchargement d'une image
    # $('[data-file-field="picture"]').on 'change', ->
    #   filename = $('[data-file-field="picture"]')[0].files[0].name
    #   $(this).parents('form').find('[data-is-label-title]').text(filename)


