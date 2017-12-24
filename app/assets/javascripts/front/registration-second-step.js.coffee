class @RegistrationSecondStep

  constructor: () ->
    console.log "RegistrationSecondStep"
    citySelect = new Select2Ajax()

    datepickerOptions =
      locale: 'fr'
      maxDate: 'today'
      allowInput: true
      altInput: true
      altFormat: 'd/m/Y'
      dateFormat: "Y-m-d"
      # wrap: true
      # clickOpens: false

    #TODO open on click on icon + clean
    birthdateDatepicker = new DatePicker($('[data-date-picker="birthdate"]'), datepickerOptions)
    console.log "yoyoy"
    $('.flatpickr-input').on 'blur', ->
      console.log 'f blur'
      date = this.value
      console.log $(this).val()
      console.log date
      birthdateDatepicker.setDate(date, false, "d.m.Y")
    # $('.flatpickr-input').on 'focusout', ->
    #   console.log 'f focusout'



    # Image ----------------------------------------
    # Affichage du nom du fichier choisi 
    # dans le bouton de téléchargement d'une image
    $('[data-file-field="picture"]').on 'change', ->
      filename = $('[data-file-field="picture"]')[0].files[0].name
      $(this).parents('form').find('[data-is-label-title]').text(filename)
