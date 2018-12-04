$(document).ready(function(){
	function colorForPeopleCount(count, full) {
		if (full) {
			return 'red'
		} else if (count > 0) {
			return '#e49b2e'
		} else {
			return '#39A778'
		}
	}

	$('#appointment-change-date').on('click', function(){
		$('#appointment-update-modal').addClass('active')
		initCalendar();
	})

	function initCalendar() {
		if ($('#appointment-update-calendar')) {
			$('#appointment-update-calendar').fullCalendar({
				defaultView: 'month',
				businessHours: {
				  // days of week. an array of zero-based day of week integers (0=Sunday)
				  dow: [3, 4, 5], // Monday - Thursday

				  start: '9:30', // a start time (10am in this example)
				  end: '17:00', // an end time (6pm in this example)
				},
			  events: function(start, end, timezone, callback) {
			  	var month = moment().month(start.month() + 1).format("M");
			  	var year  = start.year();
			  	if (month == "1") { year += 1 }

			    $.ajax({
			      url: '/appointments/by_month?month=' + month + '&year=' + year,
			      dataType: 'json',
			      success: function(timeslots) {
			      	$('#calendar-loader').addClass('hide')
			        callback(timeslots.map(function(timeslot) {
			        	var backgroundColor = colorForPeopleCount(timeslot.people_count, timeslot.full)
			        	var title = timeslot.people_count == "0" ? "None" : timeslot.people_count
		            return {
		            	title:  '' + title,
		            	start: timeslot.datetime,
		            	backgroundColor: backgroundColor
		            }
			        }));
			      }
			    });
			  },
			  eventClick: function(calEvent, jsEvent, view) {
			  	// $('#timeslot_modal').addClass('active')
			  	// $('#current-timeslot').text(calEvent.start.format('ddd D MMM - H:mm'))
			  	// $('.appointment_form_datetime').text(calEvent.start.format('ddd D MMM - H:mm'))
			   //  $('#timeslot-appointments-table > tbody > tr').remove();
			  	document.getElementById('appointment_datetime').value = calEvent.start.toString()
			   	var locArray = window.location.toString().split("/")
			   	var appointmentId = locArray[locArray.length - 1]
			   	document.getElementById('edit_appointment_' + appointmentId).submit()
		 		}
			});
		}

	}



})