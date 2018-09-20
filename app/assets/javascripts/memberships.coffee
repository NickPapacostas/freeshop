
ready = ->
  console.log('tablin!')
  $('#memberships-datatable').dataTable
    columnDefs: [
      {className: "text-center", "targets": "_all"}
    ],
    processing: true
    serverSide: true
    ajax: $('#memberships-datatable').data('source')
    pagingType: 'full_numbers'
    columns: [
      {data: 'id'}
      {data: 'first_name'}
      {data: 'last_name'}
      {data: 'email'}
    ]

$(document).ready(ready)
$(document).on('page:load', ready)