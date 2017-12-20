class @InvitationsNew

  constructor: () ->
    console.log "InvitationsNew"
    @$userSearchInput = $('[data-is-ajax-select2="user"]')
    @userSPath  = @$userSearchInput.data('path')
    @eventId    = @$userSearchInput.data('event-id')

    @$userSearchInput.on 'keyup', =>
      console.log 'yo'
      $.ajax
        type: 'GET'
        url: @userSPath
        data: 
          by_val: @$userSearchInput.val()
          event_id: @eventId
        dataType: 'script'
        success:  (data) =>  
          console.log 'success'
          # console.log data
          # @displayResults(data)
        error: (data) ->
          console.log "error"
          console.log data

  # displayResults: (data) =>
  #   # si ya des resultats
  #   @$listNode.html('')
  #   if data.length > 0
  #     console.log "results"
  #     for user in data
  #       console.log user
  #       console.log user.user
  #       compiledTemplate = @compileTemplate(user.user, '[data-template="UserCard"]')
  #       console.log compiledTemplate
  #       @$listNode.append(compiledTemplate)
  #   else
  #     console.log "no-result"
  #     @$listNode.append("<p>Pas de résulatt</p>")


  # formatUser: (data) =>
  #   user = data.user
  #   if !user
  #     return data.text
  #   # $user = $('<span>' + user.nickname + '</span>')
  #   # console.log $user
  #   compiledTemplate = @compileTemplate(user, '[data-template="UserCard"]')
  #   console.log compiledTemplate
  #   console.log $(compiledTemplate)
  #   $(compiledTemplate)

  # compileTemplate: (data, templateSelector) =>
  #   template = $(templateSelector).html()
  #   console.log template
  #   return Handlebars.compile(template)(data)

