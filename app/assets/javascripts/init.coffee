$ ->
  # enable chosen js
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'

$ ->
  $('#membership_modal .membership_close').on('click', ->
    $('#membership_modal').removeClass('active'))


  $('.membership_search').on('click', ->
    $('#membership_modal').addClass('active')
    $('#membership_modal #memberships-datatable tr').on('click', ->
      membershipId = $(this).find('div.membership-id').data('id')
      $('#appointment_membership_id').val(membershipId)
      $('#membership_modal').removeClass('active') ))

$(document).on "fields_added.nested_form_fields", (event, param) ->
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'
