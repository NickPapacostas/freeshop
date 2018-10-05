$(document).ready(function() {
	$('#calendar').fullCalendar({
	  events: function(start, end, timezone, callback) {
	    $.ajax({
	      url: '/appointments',
	      dataType: 'json',
	      success: function(appointments) {
	        callback(appointments.map(function(appointment) {
	        	var backgroundColor = appointment.full ? 'red': '#39A778'
            return {
            	title: '' + appointment.people_count,
            	start: appointment.datetime,
            	backgroundColor: backgroundColor
            }
	        }));
	      }
	    });
	  },
	  eventClick: function(calEvent, jsEvent, view) {
	  	$('#appointment_datetime').val(calEvent.start.toString())
	    $(this).css('border-color', 'red');

	  }
	});
})