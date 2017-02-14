# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('form#new_donation').on('submit', (event)->
    amount = parseFloat($(@).find('#donation_amount_authorized').val()).toFixed(2)
    confirm('Submit your donation of $' + amount + '?')
  )
