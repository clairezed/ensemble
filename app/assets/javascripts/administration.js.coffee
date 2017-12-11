#= require rails-ujs
#= require jquery
#= require popper
#= require bootstrap

#= require vendor/bootstrap-datepicker 
#= require vendor/redactor.min

#= require select2/dist/js/select2.full.min
#= require_tree ./vendor/locales

#= require ./components/flash-messages
#= require ./components/select2-simple
#= require ./components/select2-ajax
#= require ./components/event-form

#= require_tree ./admin

$ ->
  $(".datepicker").datepicker(format: 'dd/mm/yyyy', language: 'fr', autoclose: true)
  $('.tooltip_bottom').tooltip(placement: 'bottom')

  #Submenu
  $('body .submenu > a').on 'click', (e) ->
    e.preventDefault()
    $submenuContainer = $(this).parent()
    $submenuContainer.toggleClass 'open'
    if $submenuContainer.hasClass 'open' then $(this).next().slideDown 200 else $(this).next().slideUp 200
    return