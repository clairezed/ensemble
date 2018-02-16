class @UserReporter

  constructor: () ->
    @$modal = $("[data-is-modal='report']")
    @$triggerReportButton = $("[data-new-report-path]")

    # Modal new report -----------------------------
    $(document)
      .on "ajax:success", "[data-trigger-new-report]", (e, data, status, xhr) =>
        data = e.detail[0]
        success = data.success
        if success is true
          $("[data-is-report-modal='content']").html(data.html)
          @$modal.modal('show')
        else
          console.log data
      .on "ajax:error", "[data-sms-confirmation-form]", (e, xhr, status, error)  =>
        console.log e.detail
        flash("Une erreur s'est produite. Veuillez réessayer ultérieurement", 'danger')
    
    # Formulaire de creation report, dans la modal
    $(document)
      .on "ajax:success", "[data-report-form]", (e, data, status, xhr) =>
        data = e.detail[0]
        success = data.success
        if success is true
          @$modal.modal('hide')
          flash("L'utilisateur a bien été bloqué", 'success')
          window.location.reload()
        else
          html = data.html
          $("[data-is-report-modal='content']").html(data.html)
      .on "ajax:error", "[data-report-form]", (e, xhr, status, error)  =>
        console.log e.detail
        flash("Une erreur s'est produite. Veuillez réessayer ultérieurement", 'danger')