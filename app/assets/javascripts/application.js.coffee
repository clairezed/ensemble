#= require rails-ujs
#= require jquery
#= require popper
#= require bootstrap

#= require select2/dist/js/select2.full.min

#= require ./components/flash-messages
#= require ./components/select2-simple
#= require ./components/select2-ajax
#= require ./components/event-form

#= require_tree ./front


$ ->
  $('.tooltip_bottom').tooltip(placement: 'bottom')

@ajax_accept_cookies = (path) ->
  $.ajax
    url: path,
    dataType: "json",
    type: "PUT",
    success: (json) ->  
      if json.cookies_accepted
        $('#cookies_alert').remove()

