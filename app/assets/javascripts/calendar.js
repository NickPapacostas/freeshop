$(document).ready(function() {
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
	        	var backgroundColor = timeslot.full ? 'red': '#39A778'
            return {
            	title:  '' + timeslot.people_count,
            	start: timeslot.datetime,
            	backgroundColor: backgroundColor
            }
	        }));
	      }
	    });
	  },
	  eventClick: function(calEvent, jsEvent, view) {
	  	$('#appointment_datetime').val(calEvent.start.toString())

	    $.ajax({
	      url: '/appointments/by_datetime?datetime=' + moment.utc(calEvent.start).valueOf() ,
	      dataType: 'json',
	      success: function(appointments) {
	        appointments.map(function(appointment) {
	        	console.log(appointment)
	        	var rowHTML = '<tr><td>' + appointment.name + '</td><td>' + appointment.people_count + '</td></tr>'
	        	$('#timeslot-appointments-table tr:last').after(rowHTML);

	        });
	      }
	    });
	  },
 		eventMouseOver:	function( event, jsEvent, view ) {

 		} //,
  	// viewRender: function(view, element) {
	  //   $.ajax({
	  //     url: '/appointments/by_month?month=' + view.end.month(),
	  //     dataType: 'json',
	  //     success: function(timeslots) {
	  //     	console.log(timeslots)
	  //       callback(timeslots.map(function(timeslot) {
	  //       	var backgroundColor = timeslot.full ? 'red': '#39A778'
   //          return {
   //          	title:  '' + timeslot.people_count,
   //          	start: timeslot.datetime,
   //          	backgroundColor: backgroundColor
   //          }
	  //       }));
	  //     }
	  //   });
  // }



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