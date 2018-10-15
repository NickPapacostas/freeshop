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
	$('#calendar').fullCalendar({
		defaultView: 'month',
	  events: function(start, end, timezone, callback) {
	  	var month = moment().month(start.month() + 1).format("M");
	  	var year  = start.year();
	  	if (month == "1") { year += 1 }

	  	console.log(month, year)
	    $.ajax({
	      url: '/appointments/by_month?month=' + month + '&year=' + year,
	      dataType: 'json',
	      success: function(timeslots) {
	      	console.log(timeslots)
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
	      	}

	        appointments.map(function(appointment) {
	        	console.log(appointment)
	        	var rowHTML = '<tr>'
	        	rowHTML += '<td>' + appointment.name + '</td>'
	        	rowHTML += '<td>' + appointment.people_count + '</td>'

	        	if (appointment.checkout_link) {
	        		rowHTML += '<td><a href="' + appointment.checkout_link + '" class="btn"> checkout </a></td>'
	        	}

	        	if (appointment.destroy_link) {
	        		rowHTML += '<td><a href="' + appointment.destroy_link + '" class="btn btn-error"> cancel </a></td>'
	        	}

	        	if (!appointment.destroy_link && !appointment.checkout_link) {
	        		rowHTML += '<td> Completed </td>'
	        	}

	        	rowHTML += '</tr>'
	        	console.log(rowHTML)
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
	        	var backgroundColor = timeslot.full ? 'red': '#39A778'
	        	var title = timeslot.appointments.map(function(a) { return a.name }).join(" ")
	        	if (!title.length) {
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
	      	}

	        appointments.map(function(appointment) {
	        	console.log(appointment)
	        	var rowHTML = '<tr>'
	        	rowHTML += '<td>' + appointment.name + '</td>'
	        	rowHTML += '<td>' + appointment.people_count + '</td>'
	        	rowHTML += '<td><a href="' + appointment.checkout_link + '"> checkout </a></td>'
	        	rowHTML += '</tr>'
	        	console.log(rowHTML)
       			$('#timeslot-appointments-table > tbody').append(rowHTML)


	        });
	      }
	    });
	  }
	});
})