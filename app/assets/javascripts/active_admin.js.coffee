#= require active_admin/base
#= require chosen.jquery.min

load_chosen = ->
  $('.chosen-input').each ->
    maxData = $(this).data('maxselected')
    max = if maxData != undefined then maxData else false
    $(this).chosen(
      allow_single_deselect: true
      no_results_text: 'Sin resultados'
      width: '100%'
      max_selected_options: max).bind 'chosen:maxselected', ->
      error = undefined
      span = undefined
      error = $(this).parents('li').find('span.error')
      if error.size() < 1
        span = $('<span class=\'error\'>Usted ha alcanzado el límite para este tipo de etiqueta</span>')
        $(this).parents('li').append span
        return setTimeout((->
          span.remove()
          return
        ), 3000)
      return

$ ->
  load_chosen()

  $('.inputs').delegate '.has_many_add', 'click', ->
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
    $(this).parent().append('<a class="button close" data-url="' + $(this).data('url') + '" > - </a>')
    panel.show()
    return

  $('.panel_urls').delegate 'a.close', 'click', ->
    $(this).hide()
    panel = $(this).parent().children('ol')
    button = '<a class="button open" data-url="' + $(this).data('url') + '"> ' + $(this).data('url') + ' </a>'
    $(this).parent().append(button)
    panel.hide()
    return

  # next
   $('.agencies_countries_panel').each (index) ->
    url = $(this).find('ol > li > select.select_agencia option:selected').text()
    button = '<a class="button open" data-url="' + url + '"> ' + url + ' </a>'
    $(this).append(button)
    $('.agencies_countries_panel > ol:first-child').hide()
    return

  $('.agencies_countries_panel').delegate 'a.open', 'click', ->
    $(this).hide()
    panel = $(this).parent().children('ol')
    $(this).parent().append('<a class="button close" data-url="' + $(this).data('url') + '" > - </a>')
    panel.show()
    return

  $('.agencies_countries_panel').delegate 'a.close', 'click', ->
    $(this).hide()
    panel = $(this).parent().children('ol')
    button = '<a class="button open" data-url="' + $(this).data('url') + '"> ' + $(this).data('url') + ' </a>'
    $(this).parent().append(button)
    panel.hide()
    return


