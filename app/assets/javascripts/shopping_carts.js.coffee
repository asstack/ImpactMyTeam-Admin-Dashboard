# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# TODO: refactor this so can reuse
reloadCart = ->
  productGroups = []

  showShoppingCart = (e) ->
    e.preventDefault()
    items = $('#product-selection li')

    $(@).toggleClass('active')
    $('.products.cart_items').toggleClass('active')

    hideProduct(items);

  $('a.product-selection-button').on('click', showShoppingCart)

  getHeight = (item, productGroup) ->
    groupHeight = productGroup.outerHeight()
    itemHeight = item.height()

    newHeight = groupHeight + itemHeight

  setHeight = (item, productGroup) ->
    newHeight = getHeight(item, productGroup)

    item.css({
      'height': newHeight
      'minHeight': 465
    })

  hideProduct = (parent) ->
    parent.removeClass('active')
    parent.css({'height': 'auto', 'minHeight': 0})

  getProductPosition = () ->
    # minorOffset in place so page does not jump when content is at bottom
    minorOffset = 250
    productTop = $('#product-selection').offset().top - minorOffset
    viewportTop = $(window).scrollTop()
    body = $('html, body')

    if viewportTop < 400
      body.animate({scrollTop: productTop}, 500)



  showProduct = (parent, productGroup) ->

    parent.addClass('active')
    parent.siblings('li').removeClass('active').css({'height': 'auto', 'minHeight': 0})

    variantId = $(productGroup).find('.variant_selector option:selected').val()
    variantField = $(productGroup).find('ul.variant_fields li#item_variant_' + variantId)
    $(variantField).show()
    $(variantField).siblings('li').hide()

  toggleVisibility = (e) ->
    e.preventDefault()

    self = $(@)
    parent = self.closest('li')
    productId = $(@).data('product-id')
    productGroup = self.next('div.product-group')

    if !parent.hasClass('active')
      showProduct(parent, productGroup)
      setHeight(parent, productGroup)
    else
      hideProduct(parent)

    getProductPosition()


  $('ul.products').on('click', '.product-preview', toggleVisibility)

  $('.variant_selector').on('change', ->
    productGroup = $(@).closest('.product-group')
    variantId = $(productGroup).find('.variant_selector option:selected').val()
    variantField = $(productGroup).find('ul.variant_fields li#item_variant_' + variantId)
    $(variantField).show()
    $(variantField).siblings('li').hide()
  )

  $('ul.products').on('click', '.colors .radio', ->
    imageURL = $(@).data('image-url')
    imgTag = $(@).closest('.cart_item').find('.media img')
    console.log(imgTag)
    imgTag.attr('src', imageURL)
  )
  # Add, update, remove cart items
  $('ul.product-fields').on('ajax:beforeSend, ajax:remotipartSubmit', 'form[data-remote]', (event, xhr, settings)->
    container = $(@).closest('.product-group')
    $('<div class="submitting"></div>').hide().appendTo(container).fadeIn()
  ).on('ajax:complete', (event, data, status, xhr)->
    $(@).closest('.product-group').find('.submitting').fadeOut(->
      $(@).remove()
    )
  )

$ ->
  reloadCart()

