# This defines the behavior of the donation bar and buttons for campaing show
# pages located in app/views/campaigns/_donation_progress and
# app/views/campaigns/_donation_buttons

donationBar =
  goal: null
  funded: null
  donate: null
  newProgress: null
  bar: null
  timer: null
  resetDelay: 500
  init: (goal, donate, bar) ->
    @goal = parseFloat($(goal).data("goal"))
    @funded = parseFloat($(goal).data("funded"))
    @donate = parseFloat($(donate).data("amount") or $.trim($(donate).val()))
    @bar = bar
    @newProgress = @computeProjectedProgress()
    $(@bar).css width: @newProgress + "%"
    clearTimeout @timer  if @timer

  computeProjectedProgress: ->
    newProgress = (((@funded + @donate) / @goal) * 100).toFixed(2)
    Math.min 100, newProgress

  reset: ->
    self = this
    @timer = setTimeout(->
      $(self.bar).css width: "0%"
    , @resetDelay)

$ ->
  $('div.donation a.donate-amount').on('mouseover', (e)->
    donationBar.init('#goal-amount', this, 'div.donation-bar')
  )

  $('#new_donation_formlet input[type=submit]').on('mouseover', (e)->
    donationBar.init('#goal-amount', '#donation_amount_authorized', 'div.donation-bar')
  )

  $('div.donation a.donate-amount').on('mouseout', (e)->
    donationBar.reset()
  )

  $('#new_donation_formlet input[type=submit]').on('mouseout', (e)->
    donationBar.reset()
  )

  $('#donation_amount_authorized').on('keyup', (e)->
    donationBar.init('#goal-amount', this, 'div.donation-bar')
  )
