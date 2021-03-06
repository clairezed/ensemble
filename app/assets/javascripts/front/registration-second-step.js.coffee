class @RegistrationSecondStep

  constructor: () ->
    # console.log "RegistrationSecondStep"
    citySelect = new Select2Ajax()
    languageSelect = new Select2Simple($('[data-is-select2="languages"]'))
    fileUploader = new AvatarFileUploader()
    leisureCheckboxes = new LeisureCheckboxes()

    # birthdate picker -----------------------------------------------------
    datepickerOptions =
      maxDate: 'today'
      allowInput: true
      altInput: true
      altFormat: 'd/m/Y'
      dateFormat: "Y-m-d"
      clickOpens: false


    #TODO clean
    birthdateDatepicker = new DatePicker($('[data-date-picker="birthdate"]'), datepickerOptions)

    $('[data-toggle-picker]').on 'click', ->
      birthdateDatepicker.toggle()
    $('.flatpickr-input').on 'blur', ->
      date = this.value
      birthdateDatepicker.setDate(date, false, "d.m.Y")

    
    # # Image -------------------------------------------------------------
    # # Affichage du nom du fichier choisi 
    # # dans le bouton de téléchargement d'une image
    # $('[data-file-field="picture"]').on 'change', ->
    #   filename = $('[data-file-field="picture"]')[0].files[0].name
    #   $(this).parents('form').find('[data-is-label-title]').text(filename)
