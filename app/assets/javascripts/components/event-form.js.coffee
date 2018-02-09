class @EventForm

  constructor: () ->
    console.log "EventForm"
    citySelect        = new Select2Ajax()
    start_datepicker  = new DatePicker($('[data-date-picker="start"]'), {minDate: "today"})
    start_timepicker  = new TimePicker($('[data-time-picker="start"]'))
    end_datepicker    = new DatePicker($('[data-date-picker="end"]'), {minDate: "today"})
    end_timepicker    = new TimePicker($('[data-time-picker="end"]'))
    wysiwyg           = new QuillWysiwyg()
    pictureUploader   = new PictureUploader()
    fileUploader      = new FileUploader()
    participantSlider = new ParticipantsCountSlider()
    leisureRadio      = new LeisureRadio()

    $('[data-date-clear="end"]').on 'click', ->
      end_datepicker.clear()
      end_timepicker.clear()

    $('[data-date-clear="start"]').on 'click', ->
      start_datepicker.clear()
      start_timepicker.clear()

