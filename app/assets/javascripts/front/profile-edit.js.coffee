class @ProfileEdit

  constructor: () ->
    console.log "ProfileEdit"
    citySelect = new Select2Ajax()

    # Image ----------------------------------------
    # Affichage du nom du fichier choisi 
    # dans le bouton de téléchargement d'une image
    $('[data-file-field="picture"]').on 'change', ->
      filename = $('[data-file-field="picture"]')[0].files[0].name
      $(this).parents('form').find('[data-is-label-title]').text(filename)