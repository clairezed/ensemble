class @FileUploader

  DEFAULT_OPTIONS:
    scope: $(document)
    templateSelector:
      upload:   '[data-template="PictureUpload"]'
      download: '[data-template="PictureDownload"]'
    selectors: 
      listAnchor:   "[data-is-media-list]"

  constructor:  (options = {}) ->
    console.log "init!"
    @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)
    @fileInput = $("[data-file-upload]")
    @loadMedias()
    @initFileUpload()
    @bindEvents()



  bindEvents: =>
    # Attachement deletion ---------------------------------------
    @options.scope
      .on "ajax:success", "[data-delete-picture]", (e, data, status, xhr) =>
        console.log "delete success"
        detail = e.detail
        data = detail[0]
        @getMediaNode(data['id']).remove()
      .on "ajax:error", "[data-delete-picture]", (e, xhr, status, error)  =>
        console.log "delete error"
        errors = JSON.parse(xhr.responseText)['errors']
        console.log errors
        flash("Une erreur s'est produite. Veuillez réessayer ultérieurement", 'danger')

  loadMedias: =>
    url = $(@options.selectors.listAnchor).data('list-url')
    console.log "loadMedias url : #{url}"
    if !!url # Si new_record, pas d'ajout de médias
      $.get(url, {}, null, 'json'
      ).done((items) =>
        console.log(items)
        for item in items
          @prependNode(
            template: 'download', 
            data: item
          )
      ).fail((error) =>
        console.log "error"
        console.log error
        # flash("Une erreur s'est produite. Veuillez réessayer ultérieurement", 'danger')
      )

  initFileUpload: =>
    console.log $('meta[name="csrf-token"]').attr('content') 
    # need to specify formData : https://stackoverflow.com/questions/26633538/jquery-file-upload-post-and-nested-route-getting-no-route-matches-patch
    @fileInput.fileupload(
      dataType: 'json'
      type: 'POST'
      autoUpload: false
      filesContainer: $("[data-is-media-list]")
      formData: [
        {name: '_method', value: 'post' },
        { name: 'authenticity_token', value: $('meta[name="csrf-token"]').attr('content')}
      ]
      add: (e, data) =>
        console.log "add"
        @submitForm(data) if @preValidate(data)
      progress: (e, data) ->
        console.log "progress"
        if data.context
          progress = parseInt(data.loaded / data.total * 100, 10)
          data.context.find('.bar').css('width', progress + '%')
      done: (e, data) =>
        console.log "done"
        console.log data
        $(data.context).remove() # on enleve la vignette de chargement
        data.context = @prependNode(
          template: 'download', 
          data: data.result
        )
      fail: (e, data) =>
        console.log "fail"
        console.log data.jqXHR
        if data.jqXHR.status is 424 # pb de type de média
          @cancelUpload(data.jqXHR.responseText)
        else
          errorsArray = JSON.parse(data.jqXHR.responseText).errors
          @displayError(errorsArray[0])
      )

  compileTemplate: (data, templateSelector) =>
    template = $(@options.templateSelector[templateSelector]).html()
    return Handlebars.compile(template)(data)

  prependNode: (args = {}) ->
    compiledTemplate = @compileTemplate(args['data'], args['template'])
    return $(compiledTemplate).prependTo(@options.selectors.listAnchor)

  getMediaNode: (id) ->
    $("[data-is-download='#{id}']")


  # Failure management --------------------------------------------
  cancelUpload: (message) =>
    @displayError(message)

  displayError: (message) =>
    $("[data-is-upload]").remove()
    flash(message, 'danger')

  # Form ---------------------------------------------------------
  preValidate: (data) =>
    file = data.files[0]
    maxFileSize = 1024 * 1024 * 8 # 8MB
    # validation format
    unless !!@getFormat(file.type)
      flash("Le format de votre fichier n'est pas autorisé", 'danger')
      return false
    # validation taille
    if file.size > maxFileSize
      flash("Votre fichier dépasse la taille maximum", 'danger')
      return false
    return true


  submitForm: (data) =>
    console.log "submitForm"
    data.context = @prependNode(
      template: 'upload', 
      data: data.files[0]
    )
    data.submit()
    return false
  
  getFormat: (type) =>
    console.log type
    switch type
      when "image/jpeg", \
        "image/png", \
        "image/gif" \
        then 'picture'
      else null

