# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  timerid = undefined
  $('form#school_search_remote').children('#query').bind('keyup', ->
    clearTimeout(timerid)
    form = this.form

    timerid = setTimeout(->
      $.get($(form).attr('action'), $(form).serialize(), null, 'script')
    , 500
    )
  )
