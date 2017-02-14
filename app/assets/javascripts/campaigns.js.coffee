# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#campaign-logo .jq-fileupload').fileupload(
    dataType: 'json',
    add: (event, data)->
      data.context = $('#campaign-logo').append('<div class="uploading"></div>');
      data.submit()
    done: (event, data)->
      image_url = data.result.logo_image.figure.url
      data.context.find('.image').html('<img src="' + image_url + '" alt="Campaign Logo" />')
      data.context.find('.uploading').remove();
  )

  $('.save_and_preview').on('click', (e)->
    e.preventDefault()
    formId = $(@).data('form-id')
    $('form#' + formId).submit()
  )

  $('.school-images-upload .jq-fileupload').fileupload(
    dataType: 'script'
    paramName: 'campaign_photo[image]'
    sequentialUploads: true
    maxNumberOfFiles: 5
    maxFileSize: 10000000 # 10MB
    acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
    getNumberOfFiles: ->
      $('ul#uploaded-images li').length
    add: (e, data)->
      $('.school-images-upload ul').append('<li class="uploading"></li>')
      data.submit()
  )
  $('.school-images-upload').on('click', 'li', (event)->
    url = $(@).data('delete-path')
    $.post(url, { _method: 'delete' })
  )

  # State Transition submission (#show)
  $('input[type=submit][name=status_transition]').on('click', (e)->
    terms = $(@).closest('form').find('.campaign_terms_of_service input[type=checkbox]')

    if (terms.length > 0 && !terms.prop('checked'))
      alert('You must accept the terms of service to perform this action.')
      false
  )

  # Lazybox
  $('a[rel*=lazybox]').lazybox({
    modal: true
  })

  # Slides
  $('#slides').slidesjs({
    width: 225,
    height: 225,
    navigation: false,
    pagination: false
  })
