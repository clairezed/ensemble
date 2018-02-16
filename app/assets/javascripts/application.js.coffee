#= require rails-ujs
#= require jquery
#= require popper
#= require bootstrap

#= require jquery-fileupload/basic
#= require jquery-fileupload/vendor/tmpl
#= require js-cookie/src/js.cookie
#= require select2/dist/js/select2.full.min
#= require flatpickr/dist/flatpickr.min
#= require flatpickr/dist/l10n/fr
#= require quill/dist/quill.min
#= require handlebars/dist/handlebars.min
#= require photoswipe/dist/photoswipe.min
#= require photoswipe/dist/photoswipe-ui-default.min
#= require ion-rangeslider/js/ion.rangeSlider.min

#= require ./components/flash-messages
#= require ./components/application-menu
#= require ./components/cookies-acceptance
#= require ./components/select2-simple
#= require ./components/select2-ajax
#= require ./components/event-form
#= require ./components/sms-confirmation
#= require ./components/range-picker
#= require ./components/date-picker
#= require ./components/time-picker
#= require ./components/quill-wysiwyg
#= require ./components/picture-uploader
#= require ./components/file-uploader
#= require ./components/avatar-file-uploader
#= require ./components/photoswipe-gallery
#= require ./components/participants-count-slider
#= require ./components/leisure-checkboxes
#= require ./components/leisure-radio
#= require ./components/welcome-modal
#= require ./components/user-reporter


#= require_tree ./front


$ ->
  new CookiesAcceptance()
  $('.tooltip_bottom').tooltip(placement: 'bottom')
  $('[data-toggle="tooltip"]').tooltip()

  new ApplicationMenu()

  new WelcomeModal()