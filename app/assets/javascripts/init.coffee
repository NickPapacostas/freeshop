$ ->
  # enable chosen js
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'

$(document).on "fields_added.nested_form_fields", (event, param) ->
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
