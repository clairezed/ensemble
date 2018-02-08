# Affiche le message flash pendant 3 secondes.
#  - content : html, ou texte si type renseigne
#  - type : si renseigne, doit être "success", "warning", "error" ou "danger"
@flash = (content, type) ->
  content = "<span class=\"alert alert-#{type}\">#{content}</span>" if type?
  $('#flash').clearQueue().hide().html(content).fadeIn('slow').delay(5000).fadeOut('slow')


$(document).ajaxComplete (event, request) ->
  data = $.parseJSON(request.getResponseHeader('X-Message'))
  if data
    message = decodeURIComponent(escape(data.message))
    flash(message, data.type)