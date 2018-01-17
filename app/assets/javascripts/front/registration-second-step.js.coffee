class @RegistrationSecondStep

  constructor: () ->
    console.log "RegistrationSecondStep"
    citySelect = new Select2Ajax()
    languageSelect = new Select2Simple($('[data-is-select2="languages"]'))


    # birthdate picker -----------------------------------------------------
    datepickerOptions =
      maxDate: 'today'
      allowInput: true
      altInput: true
      altFormat: 'd/m/Y'
      dateFormat: "Y-m-d"
      clickOpens: false
      disableMobile: "true"

    #TODO clean
    birthdateDatepicker = new DatePicker($('[data-date-picker="birthdate"]'), datepickerOptions)

    $('[data-toggle-picker]').on 'click', ->
      console.log "click icon"
      birthdateDatepicker.toggle()
    $('.flatpickr-input').on 'blur', ->
      console.log 'f blur'
      date = this.value
      birthdateDatepicker.setDate(date, false, "d.m.Y")


    # Image -------------------------------------------------------------
    # Affichage du nom du fichier choisi 
    # dans le bouton de téléchargement d'une image
    $('[data-file-field="picture"]').on 'change', ->
      filename = $('[data-file-field="picture"]')[0].files[0].name
      $(this).parents('form').find('[data-is-label-title]').text(filename)
