#= require rails-ujs
#= require jquery
#= require popper
#= require bootstrap

#= require js-cookie/src/js.cookie
#= require select2/dist/js/select2.full.min
#= require flatpickr/dist/flatpickr.min
#= require flatpickr/dist/l10n/fr
#= require quill/dist/quill.min
#= require handlebars/dist/handlebars.min

#= require ./components/flash-messages
#= require ./components/cookies-acceptance
#= require ./components/select2-simple
#= require ./components/select2-ajax
#= require ./components/event-form
#= require ./components/sms-confirmation
#= require ./components/range-picker
#= require ./components/date-picker
#= require ./components/time-picker
#= require ./components/quill-wysiwyg

#= require_tree ./front


$ ->
  new CookiesAcceptance()
  $('.tooltip_bottom').tooltip(placement: 'bottom')