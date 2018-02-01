class @AvatarFileUploader extends @FileUploader
  
  DEFAULT_OPTIONS:
    scope: $(document)
    templateSelector:
      upload:   '[data-template="PictureUpload"]'
      download: '[data-template="PictureDownload"]'
    selectors: 
      uploadAnchor:   "[data-is-upload-anchor]"

  constructor:  (options = {}) ->
    # console.log "AvatarFileUploader"
    @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)
    @fileInput = $("[data-file-upload]")
    @initFileUpload()
    @bindEvents()


  initFileUpload: =>
    # console.log 'initFileUpload'
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
        # console.log "add"
        @submitForm(data) if @preValidate(data)
      progress: (e, data) ->
        # console.log "progress"
        if data.context
          progress = parseInt(data.loaded / data.total * 100, 10)
          data.context.find('.bar').css('width', progress + '%')
      done: (e, data) =>
        # console.log "done"
        # console.log data
        data.context = @replaceNode(
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


  replaceNode: (args = {}) ->
    compiledTemplate = @compileTemplate(args['data'], args['template'])
    return $(@options.selectors.uploadAnchor).html(compiledTemplate)


  # Failure management --------------------------------------------

  submitForm: (data) =>
    # console.log "submitForm"
    # console.log data.files[0]
    data.context = @replaceNode(
      template: 'upload', 
      data: data.files[0]
    )
    data.submit()
    return false
