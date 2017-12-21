#= require rails-ujs
#= require jquery
#= require popper
#= require bootstrap

#= require select2/dist/js/select2.full.min
#= require flatpickr/dist/flatpickr.min
#= require flatpickr/dist/l10n/fr
#= require quill/dist/quill.min
#= require handlebars/dist/handlebars.min

#= require ./components/flash-messages
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
  $('.tooltip_bottom').tooltip(placement: 'bottom')

@ajax_accept_cookies = (path) ->
  console.log "ajax_accept_cookies"
  console.log path
  $.ajax
    url: path,
    dataType: "json",
    type: "PUT",
    success: (json) ->
      console.log "success"
      console.log json
      if json.cookies_accepted
        $('#cookies_alert').remove()

