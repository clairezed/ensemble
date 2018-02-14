class @WelcomeModal

  constructor: () ->
    @$modal = $("[data-is-modal='welcome']")
    @$modal.modal('show') if @$modal.length > 0
    
    # Formulaire validation numéro de téléphone
    $(document)
      .on "ajax:success", "[data-sms-confirmation-form]", (e, data, status, xhr) =>
        data = e.detail[0]
        success = data.success
        if success is true
          @$modal.modal('hide')
          Cookies.remove('ensemble_welcome_modal')
          flash("Votre numéro de téléphone a bien été confirmé", 'success')
        else
          html = data.html
          $("[data-sms-confirmation-form]").html(html)
      .on "ajax:error", "[data-sms-confirmation-form]", (e, xhr, status, error)  =>
        flash("Une erreur s'est produite. Veuillez réessayer ultérieurement", 'danger')

    # Supprimer cookie si l'utilisateur la ferme (sinon, ouverture intempestive à chaque page..;)
    @$modal.on('hidden.bs.modal', ->
      Cookies.remove('ensemble_welcome_modal')
    )

    