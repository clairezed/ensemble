class @QuillWysiwyg

  DEFAULT_OPTIONS:
    modules: {
        toolbar: [
          ['bold', 'italic'],
          ['link'],
          [ { list: 'ordered' }, { list: 'bullet' }]
        ]
    },
    placeholder: '',
    theme: 'snow'

  constructor: (
      inputSelector='[data-is-wysiwyg="quill"]', 
      options = {}
    ) ->

    @options = $.extend(true, {}, @DEFAULT_OPTIONS, options)
    @inputSelector = inputSelector

    quill = new Quill(inputSelector, @options)

    $form = $(@inputSelector).parents('form')

    $form.on 'submit', (e) ->
      console.log "submit form !"
      # console.log quill.root.innerHTML
      # console.log quill.getText()
      # console.log quill.getContents()
      # Populate hidden form on submit
      $description = $('[data-is-hidden-field="description"]')
      quillContent = quill.root.innerHTML
      $description.val(quill.root.innerHTML)
      console.log $description.html()
      # e.preventDefault()
      # false


    # quill = new Quill('#editor-container',
    #   modules: toolbar: [
    #     [
    #       'bold'
    #       'italic'
    #     ]
    #     [
    #       'link'
    #       'blockquote'
    #       'code-block'
    #       'image'
    #     ]
    #     [
    #       { list: 'ordered' }
    #       { list: 'bullet' }
    #     ]
    #   ]
    #   placeholder: 'Compose an epic...'
    #   theme: 'snow')

