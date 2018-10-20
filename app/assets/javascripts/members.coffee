$ ->
  $('#members-datatable').dataTable
    columnDefs: [
      {className: "text-center", "targets": "_all"}
    ],
    info: false
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
      {data: 'phone'}
      {data: 'email'}
      {data: 'document_number'}
    ]