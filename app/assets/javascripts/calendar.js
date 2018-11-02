$(document).ready(function() {
	function colorForPeopleCount(count, full) {
		if (full) {
			return 'red'
		} else if (count > 0) {
			return '#e49b2e'
		} else {
			return '#39A778'
		}
	}
	if ($('#calendar').length) $('#calendar-loader').removeClass('hide')
	$('#calendar').fullCalendar({
		defaultView: 'month',
		businessHours: {
		  // days of week. an array of zero-based day of week integers (0=Sunday)
		  dow: [ 4, 5, 6 ], // Monday - Thursday

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
	  	$('#timeslot_modal').addClass('active')
	  	$('#current-timeslot').text(calEvent.start.format('ddd D MMM - H:mm'))
	  	$('.appointment_form_datetime').text(calEvent.start.format('ddd D MMM - H:mm'))
	  	document.getElementById('appointment_datetime').value = calEvent.start.toString()
	    $('#timeslot-appointments-table > tbody > tr').remove();

	    $.ajax({
	      url: '/appointments/by_datetime?datetime=' + calEvent.start.toISOString(),
	      dataType: 'json',
	      success: function(appointments) {
	      	if (appointments.length) {
	  				$('#timeslot-view').removeClass('d-invisible')
	      	} else {
	      		$('#timeslot-view').addClass('d-invisible')
	      	}

	        appointments.map(function(appointment) {
	        	var rowHTML = '<tr>'
	        	rowHTML += '<td>' + appointment.name + '</td>'
	        	rowHTML += '<td>' + appointment.people_count + '</td>'
	        	rowHTML += '<td>' + appointment.membership_people_count + '</td>'
        		rowHTML += '<td><a href="' + appointment.show_link + '" class="btn btn-primary"> view </a>'
	        	if (appointment.checkout_link) {
	        		rowHTML += '<a href="' + appointment.checkout_link + '" class="btn"> checkout </a>'
	        	}
	        	rowHTML += '</td'


	        	rowHTML += '</tr>'
       			$('#timeslot-appointments-table > tbody').append(rowHTML)


	        });
	      }
	    });
	  },
 		eventMouseOver:	function( event, jsEvent, view ) {

 		}
	});


	$('#todays-appointments').fullCalendar({
		defaultView: 'listDay',
	  events: function(start, end, timezone, callback) {
	    $.ajax({
	      url: '/appointments/by_day?date=' + start.toString(),
	      dataType: 'json',
	      success: function(timeslots) {
	        callback(timeslots.map(function(timeslot) {
	        	var backgroundColor = colorForPeopleCount(timeslot.people_count, timeslot.full)
	        	var title;
	        	if (timeslot.people_count > 0) title = timeslot.people_count + " people"
	        	if (!title) {
	        		title = "No appointments"
	        	}
            return {
            	title: title,
            	start: timeslot.datetime,
            	backgroundColor: backgroundColor
            }
	        }));
	      }
	    });
	  },
	  eventClick: function(calEvent, jsEvent, view) {
	  	$('#current-timeslot').text(calEvent.start.format('ddd D MMM YY - H:mm'))
	  	$('#appointment_datetime').val(calEvent.start.toString())
	    $('#timeslot-appointments-table > tbody > tr').remove();
	    $.ajax({
	      url: '/appointments/by_datetime?datetime=' + calEvent.start.toISOString(),
	      dataType: 'json',
	      success: function(appointments) {
	      	if (appointments.length) {
	  				$('#timeslot-view').removeClass('d-invisible')
	      	} else {
	      		$('#timeslot-view').addClass('d-invisible')
	      		$('#create-checkout').removeClass('d-invisible')

	      	}

	        appointments.map(function(appointment) {
	        	var rowHTML = '<tr>'
	        	rowHTML += '<td>' + appointment.name + '</td>'
	        	rowHTML += '<td>' + appointment.people_count + '</td>'
        		rowHTML += '<td><a href="' + appointment.show_link + '" class="btn btn-primary"> view </a>'
	        	if (appointment.checkout_link) {
	        		rowHTML += '<a href="' + appointment.checkout_link + '" class="btn"> checkout </a>'
	        	}
	        	rowHTML += '</td'


	        	rowHTML += '</tr>'
       			$('#timeslot-appointments-table > tbody').append(rowHTML)


	        });
	       }
	    });
	  }
	});
})