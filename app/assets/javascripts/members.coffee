$ ->
  $('#members-datatable').dataTable
    columnDefs: [
      {className: "text-center", "targets": "_all"}
    ],
    processing: true
    serverSide: true
    ajax: $('#members-datatable').data('source')
    pagingType: 'full_numbers'
    columns: [
      {data: 'id'}
      {data: 'first_name'}
      {data: 'last_name'}
      {data: 'phone'}
      {data: 'email'}
      {data: 'document_number'}
    ]