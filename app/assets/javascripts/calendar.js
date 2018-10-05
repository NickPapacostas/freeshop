$(document).ready(function() {
	$('#calendar').fullCalendar({
	  events: function(start, end, timezone, callback) {
	    $.ajax({
	      url: '/appointments',
	      dataType: 'json',
	      success: function(appointments) {
	        callback(appointments.map(function(appointment) {
	        	const backgroundColor = appointment.full ? 'red': '#39A778'
            return {
            	title: '' + appointment.people_count,
            	start: appointment.datetime,
            	backgroundColor: backgroundColor
            }
	        }));
	      }
	    });
	  }
	});
})