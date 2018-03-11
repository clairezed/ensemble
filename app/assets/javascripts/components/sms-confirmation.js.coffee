class @SmsConfirmation

  constructor: () ->
    console.log "SmsConfirmation"
    @sendSmsSelector = "[data-send-sms-confirmation]"
    @formSelector = "[data-sms-confirmation-form]"

    $(document)
      .on('ajax:success', @sendSmsSelector, (event) =>
        # console.log "success"
        detail = event.detail
        # console.log detail
        xhr = detail[2]
        # console.log xhr
        $(@formSelector).collapse()
      )  
      .on('ajax:error', @sendSmsSelector, (event) =>
        # console.log "error"
        detail = event.detail
        # console.log detail
        xhr = detail[2]
        # console.log xhr
      )

    $(document)
      .on('ajax:success', @formSelector, (event) =>
        # console.log "success form"
        detail = event.detail
        # console.log detail
        xhr = detail[2]
        # console.log xhr
        flash("Votre numéro de téléphone a bien été confirmé", 'success')
        window.location.reload()

      )  
      .on('ajax:error', @formSelector, (event) =>
        # console.log "error form"
        detail = event.detail
        # console.log detail
        xhr = detail[2]
        # console.log xhr
      )