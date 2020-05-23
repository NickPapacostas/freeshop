
ready = ->
  $('#memberships-datatable').dataTable
    columnDefs: [
      {className: "text-center", "targets": "_all"}
    ],
    processing: true
    serverSide: true
    ajax: $('#memberships-datatable').data('source')
    pagingType: 'full_numbers'
    columns: [
      {data: 'number'}
      {data: 'first_name'}
      {data: 'last_name'}
    ]

$(document).ready(ready)
$(document).on('page:load', ready)