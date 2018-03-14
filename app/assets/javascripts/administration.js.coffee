#= require rails-ujs
#= require jquery
#= require popper
#= require bootstrap

#= require vendor/bootstrap-datepicker 
#= require vendor/redactor.min

#= require jquery-fileupload/basic
#= require jquery-fileupload/vendor/tmpl
#= require select2/dist/js/select2.full.min
#= require flatpickr/dist/flatpickr.min
#= require flatpickr/dist/l10n/fr
#= require quill/dist/quill.min
#= require handlebars/dist/handlebars.min
#= require ion-rangeslider/js/ion.rangeSlider.min
#= require chart.js/dist/Chart.bundle.min

#= require_tree ./vendor/locales

#= require ./components/flash-messages
#= require ./components/select2-simple
#= require ./components/select2-ajax
#= require ./components/event-form
#= require ./components/range-picker
#= require ./components/date-picker
#= require ./components/time-picker
#= require ./components/quill-wysiwyg
#= require ./components/picture-uploader
#= require ./components/file-uploader
#= require ./components/avatar-file-uploader
#= require ./components/participants-count-slider
#= require ./components/leisure-checkboxes
#= require ./components/leisure-radio

#= require_tree ./admin

$ ->
  $(".datepicker").datepicker(format: 'dd/mm/yyyy', language: 'fr', autoclose: true)
  $('.tooltip_bottom').tooltip(placement: 'bottom')

  #Submenu
  $('body .submenu > a').on 'click', (e) ->
    e.preventDefault()
    $submenuContainer = $(this).parent()
    $submenuContainer.toggleClass 'open'
    if $submenuContainer.hasClass 'open' then $(this).next().slideDown 200 else $(this).next().slideUp 200
    return

  $('#sidebar-collapse-btn').on 'click', (event) ->
    event.preventDefault()
    $("#app").toggleClass("sidebar-open")