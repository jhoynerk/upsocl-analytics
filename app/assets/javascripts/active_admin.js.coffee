#= require active_admin/base
#= require chosen.jquery.min
$ ->

  $('.chosen-input').chosen
    allow_single_deselect: true
    no_results_text: 'Sin resultados'
    width: "50%"

  load_chosen = ->
    $('.chosen-input').chosen
      allow_single_deselect: true
      no_results_text: 'Sin resultados'
      width: "50%"

  $('.has_many_add').on 'click', ->
    setTimeout load_chosen, 100

  $("#page_stadistic_url_id, #country_stadistic_url_id").chosen
    allow_single_deselect: true
    no_results_text: 'Sin resultados'
    width: "100%"


  $('.panel_urls').each (index) ->
    url = $(this).find('ol > li > input').val()
    button = '<a class="button open" data-url="' + url + '"> ' + url + ' </a>'
    $(this).append(button)
    $('.panel_urls > ol:first-child').hide()
    return

  $('.panel_urls').delegate 'a.open', 'click', ->
    $(this).hide()
    panel = $(this).parent().children('ol')
    $(this).parent().append('<a class="button close" data-url="' + $(this).data('url') + '" > cerrar </a>')
    panel.show()
    return

  $('.panel_urls').delegate 'a.close', 'click', ->
    $(this).hide()
    panel = $(this).parent().children('ol')
    button = '<a class="button open" data-url="' + $(this).data('url') + '"> ' + $(this).data('url') + ' </a>'
    $(this).parent().append(button)
    panel.hide()
    return


