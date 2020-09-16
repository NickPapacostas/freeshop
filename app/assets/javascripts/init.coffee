$ ->
  # enable chosen js
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'


$ ->
  $('#membership_modal .membership_close').on('click', ->
    $('#membership_modal').removeClass('active'))

  $('#open-item-modal').on('click', ->
    $('#new_item_modal').addClass('active'))

  $('#new_item_modal .new_item_close').on('click', ->
    $('#new_item_modal').removeClass('active'))

  $('#timeslot_modal .appointment_close').on('click', ->
    $('#timeslot_modal').removeClass('active'))

  $('#timeslot_modal .membership_close').on('click', ->
    $('#timeslot_modal').removeClass('active'))

  $('.membership_search').on('click', ->
    $('#membership_modal').addClass('active')
    # initialization
    $('#membership_modal #memberships-datatable tr').on('click', ->
      membershipNumber = $(this).find('div.membership-id').data('number')
      membershipName = $(this).find('div.membership-id').data('name')
      $('#appointment_membership_id').val(membershipNumber + " - " + membershipName)
      $('#membership_modal').removeClass('active'))

    # once searched
    $('#memberships-datatable_filter > label:nth-child(1) > input:nth-child(1)').on('change', ->
      $('#membership_modal #memberships-datatable tr').on('click', ->
        membershipNumber = $(this).find('div.membership-id').data('number')
        membershipName = $(this).find('div.membership-id').data('name')
        $('#appointment_membership_id').val(membershipNumber + " - " + membershipName)
        $('#membership_modal').removeClass('active'))) )

$(document).on "fields_added.nested_form_fields", (event, param) ->
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'No results matched'

$(document).keydown (e) ->
  if e.key == "Escape"
    $('.modal.active').last().removeClass('active')
  return
