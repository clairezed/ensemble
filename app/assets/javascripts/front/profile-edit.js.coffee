class @ProfileEdit

  constructor: () ->
    console.log "ProfileEdit"
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
      console.log "click icon"
      birthdateDatepicker.toggle()
    $('.flatpickr-input').on 'blur', ->
      console.log 'f blur'
      date = this.value
      birthdateDatepicker.setDate(date, false, "d.m.Y")
