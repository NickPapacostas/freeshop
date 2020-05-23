$ ->
  table_options =
    columnDefs: [
      {className: "text-center", "targets": "_all"}
    ],
    info: true
    pageLength: 20
    lengthChange: false
    processing: true
    serverSide: true
    ajax: $('#members-datatable').data('source')
    pagingType: 'full_numbers'
    columns: [
      {data: 'membership_id'}
      {data: 'first_name'}
      {data: 'last_name'}
      {data: 'birth_year'}
    ]

  if $('#members-datatable').hasClass('paging')
    table_options.lengthChange = true
    table_options.info = true
    table_options.pageLength = 25

  $('#members-datatable').dataTable table_options