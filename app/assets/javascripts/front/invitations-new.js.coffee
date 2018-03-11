class @InvitationsNew

  constructor: () ->
    # console.log "InvitationsNew"
    @$userSearchInput = $('[data-is-ajax-select2="user"]')
    @userSPath  = @$userSearchInput.data('path')
    @eventId    = @$userSearchInput.data('event-id')

    @$userSearchInput.on 'keyup', =>
      $.ajax
        type: 'GET'
        url: @userSPath
        data: 
          by_val: @$userSearchInput.val()
          event_id: @eventId
        dataType: 'script'
        # success:  (data) =>  
        #   console.log 'success'
        #   # console.log data
        #   # @displayResults(data)
        # error: (data) ->
        #   console.log "error"
        #   console.log data

