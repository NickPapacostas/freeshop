$(document).ready(function() {
	$('#calendar').fullCalendar({
		defaultView: 'listMonth',
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

	  },
 		eventMouseOver:	function( event, jsEvent, view ) {

 		},

 		viewRender: function(view, element) {
	    // $.ajax({
	    //   url: '/appointments?d=' + view.start.toISOString(),
	    //   dataType: 'json',
	    //   success: function(appointments) {
	    //     callback(appointments.map(function(appointment) {
	    //     	var backgroundColor = appointment.full ? 'red': '#39A778'
     //        return {
     //        	title: '' + appointment.people_count,
     //        	start: appointment.datetime,
     //        	backgroundColor: backgroundColor
     //        }
	    //     }));
	    //   }
	    // });
 		}

	});


	$('#todays-appointments').fullCalendar({
		defaultView: 'listDay',
	  events: function(start, end, timezone, callback) {
	    $.ajax({
	      url: '/appointments/today',
	      dataType: 'json',
	      success: function(timeslots) {
	        callback(timeslots.map(function(timeslot) {
	        	var backgroundColor = timeslot.full ? 'red': '#39A778'
            return {
            	title: timeslot.appointments.map(function(a) { return a.name }).join(" "),
            	start: timeslot.datetime,
            	backgroundColor: backgroundColor
            }
	        }));
	      }
	    });
	  }
	});
})