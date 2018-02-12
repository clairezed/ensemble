class @FileUploader

  DEFAULT_OPTIONS:
    scope: $(document)
    template:
      modal: """
      <div class="modal fade">
        <div class="modal-dialog" role="document">
          <div class="modal-content" data-is-modal-content>
          </div>
      </div>
    """
    templateSelector:
      upload:   '[data-template="AttachmentUpload"]'
      download: '[data-template="AttachmentDownload"]'
    selectors: 
      listAnchor:   "[data-is-doc-upload-anchor]"
      modalContent: '[data-is-modal-content]'
      modalNew:        '[data-is-modal="attachment"]'

  constructor:  (options = {}) ->
    # console.log "init!"
    @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)
    @fileInput = $("[data-doc-upload]")
    @$modalEditContainer = $(@options.template.modal)
    @$modalNewContainer = $(@options.selectors.modalNew)
    @csrfToken = $('meta[name="csrf-token"]').attr('content')

    @loadMedias()
    @initFileUpload()
    @bindEvents()



  bindEvents: =>
    # Attachement deletion ---------------------------------------
    @options.scope
      .on "ajax:success", "[data-delete-attachment]", (e, data, status, xhr) =>
        detail = e.detail
        data = detail[0]
        @getMediaNode(data['id']).remove()
      .on "ajax:error", "[data-delete-attachment]", (e, xhr, status, error)  =>
        # errors = JSON.parse(xhr.responseText)['errors']
        # console.log errors
        flash("Une erreur s'est produite. Veuillez réessayer ultérieurement", 'danger')

    # # Attachement edit modal ---------------------------------------
    # @options.scope
    #   .on "ajax:success", "[data-edit-attachment]", (e, data, status, xhr) =>
    #     detail = e.detail
    #     data = detail[0]
    #     # console.log data
    #     @$modalEditContainer.find(@options.selectors.modalContent).html(data)
    #     @$modalEditContainer.modal('show')
    #   .on "ajax:error", "[data-delete-attachment]", (e, xhr, status, error)  =>
    #     # console.log error
    #     # console.log xhr
    #     flash("Une erreur s'est produite. Veuillez réessayer ultérieurement", 'danger')
    
    # # Attachement update form ---------------------------------------
    # @options.scope
    #   .on "ajax:success", "[data-is-form='update-attachment']", (e, data, status, xhr) =>
    #     console.log data
    #     currentNode = @getMediaNode(data['id'])
    #     compiledTemplate = @compileTemplate(data, 'download')
    #     currentNode.replaceWith(compiledTemplate)
    #     @$modalEditContainer.modal('hide')
    #   .on "ajax:error", "[data-is-form='update-attachment']", (e, xhr, status, error)  =>
    #     # console.log error
    #     # console.log xhr
    #     flash("Une erreur s'est produite. Veuillez réessayer ultérieurement", 'danger')

  loadMedias: =>
    # console.log "loadMedias"
    url = $(@options.selectors.listAnchor).data('list-url')
    # console.log url
    if !!url # Si new_record, pas d'ajout de médias
      $.get(url, {}, null, 'json'
      ).done((items) =>
        # console.log(items)
        for item in items
          @prependNode(
            template: 'download', 
            data: item
          )
      ).fail((error) =>
        # console.log error
        flash("Une erreur s'est produite. Veuillez réessayer ultérieurement", 'danger')
      )

  initFileUpload: =>
    # need to specify formData : https://stackoverflow.com/questions/26633538/jquery-file-upload-post-and-nested-route-getting-no-route-matches-patch
    @fileUpload = @fileInput.fileupload(
      dataType: 'json'
      type: 'POST'
      autoUpload: false
      filesContainer: $("[data-is-media-list]")
      # formData: [
      #   {name: '_method', value: 'post' },
      #   { name: 'authenticity_token', value: @csrfToken }
      # ]
      add: (e, data) =>
        # console.log "add"
        # console.log data
        @renderModal(data) if @preValidate(data)
      progress: (e, data) ->
        if data.context
          progress = parseInt(data.loaded / data.total * 100, 10)
          data.context.find('.bar').css('width', progress + '%')
      done: (e, data) =>
        # console.log "done"
        # console.log data
        $(data.context).remove() # on enleve la vignette de chargement
        data.context = @prependNode(
          template: 'download', 
          data: data.result
        )
      fail: (e, data) =>
        # console.log "fail"
        # console.log data.jqXHR
        if data.jqXHR.status is 424 # pb de type de média
          @cancelUpload(data.jqXHR.responseText)
        else
          errorsArray = JSON.parse(data.jqXHR.responseText).errors
          @displayError(errorsArray[0])
      )


  # Rendering ---------------------------------------------------------
  renderModal: (data) =>
    @populateForm(data.files[0])
    @$modalNewContainer.modal('show')
    $("[data-is-modal-submit]").off('click').on 'click', =>
      @submitForm(data)

  compileTemplate: (data, templateSelector) =>
    template = $(@options.templateSelector[templateSelector]).html()
    return Handlebars.compile(template)(data)

  prependNode: (args = {}) ->
    compiledTemplate = @compileTemplate(args['data'], args['template'])
    return $(compiledTemplate).prependTo(@options.selectors.listAnchor)

  getMediaNode: (id) ->
    $("[data-is-doc-download='#{id}']")


  # Failure management --------------------------------------------
  cancelUpload: (message) =>
    @$modalNewContainer.modal('hide')
    @displayError(message)

  displayError: (message) =>
    $("[data-is-doc-upload]").remove()
    flashAjaxError(message)

  # Form ---------------------------------------------------------
  preValidate: (data) =>
    file = data.files[0]
    maxFileSize = 1024 * 1024 * 8 # 8MB
    # validation format
    unless !!@getFormat(file.type)
      flashAjaxError("Le format de votre fichier n'est pas autorisé")
      return false
    # validation taille
    if file.size > maxFileSize
      flashAjaxError("Votre fichier dépasse la taille maximum")
      return false
    return true

  populateForm: (file) =>
    format = @getFormat(file.type)
    $("[data-is-ta-attribute='custom_file_name']").val(file.name)
    $("[data-is-ta-attribute='title']").val("")

  submitForm: (data) =>
    data.formData= [
        {name: '_method', value: 'post' },
        { name: 'authenticity_token', value: @csrfToken },
        { name: 'asset_event_attachment[title]', value: ($("[data-is-ta-attribute='title']").val() || '') },
        { name: 'asset_event_attachment[custom_file_name]', value: ($("[data-is-ta-attribute='custom_file_name']").val() || '') }

      ]
    data.context = @prependNode(
      template: 'upload', 
      data: data.files[0]
    )
    data.submit()
    @$modalNewContainer.modal('hide')
    return false
  
  getFormat: (type) =>
    switch type
      when "application/pdf" \
        then 'document'
      else null

