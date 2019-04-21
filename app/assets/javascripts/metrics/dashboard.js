window.chartColors = {
  red: 'rgb(255, 99, 132)',
  orange: 'rgb(255, 159, 64)',
  yellow: 'rgb(255, 205, 86)',
  green: 'rgb(75, 192, 192)',
  blue: 'rgb(54, 162, 235)',
  purple: 'rgb(153, 102, 255)',
  grey: 'rgb(201, 203, 207)'
};

var initChart = function(url, chartConfig, callback) {
  var data = $.ajax({
    url: url,
    dataType: 'json',
    success: callback
  })
}

var itemChartConfig = function(data) {
  var color = Chart.helpers.color;
  return {
    type: 'bar',
    data: {
      datasets: [{
        label: 'Items',
        backgroundColor: color(window.chartColors.blue).alpha(0.5).rgbString(),
        borderColor: window.chartColors.blue,
        fill: false,
        data: data
      }]
    },
    options: {
      onClick: function(evt) {
         itemChartClick(evt)
      },
      responsive: true,
      title: {
        display: true,
        text: 'Items (click a bar for details)'
      },
      scales: {
        xAxes: [{
          type: 'time',
          time: {
            unit: 'day'
          },
          display: true,
          scaleLabel: {
            display: true,
            labelString: 'Date'
          },
          ticks: {
            major: {
              fontStyle: 'bold',
              fontColor: '#FF0000'
            }
          }
        }],
        yAxes: [{
          display: true,
          scaleLabel: {
            display: true,
            labelString: 'value'
          }
        }],
        // tooltips: {
        //   callbacks: {
        //     label: function(tooltipItem, data) {
        //       var label = data.datasets[tooltipItem.datasetIndex].label || '';

        //       if (label) {
        //         label = moment.
        //       }
        //       label += Math.round(tooltipItem.yLabel * 100) / 100;
        //       return label;
        //     }
        //   }
        // }
      }
    }
  };

}

var itemChartClick = function(event) {
  var activePoint = itemChart.getElementAtEvent(event)[0];
  var data = activePoint._chart.data;
  var datasetIndex = activePoint._datasetIndex;
  var label = data.datasets[datasetIndex].label;
  var value = data.datasets[datasetIndex].data[activePoint._index];
  $('#top-for-day-table > tbody > tr').remove();

  $.ajax({
    url: '/metrics/dashboard/top_for_day?date=' + value.x,
    dataType: 'json',
    success: function(items_and_counts) {
      if (items_and_counts.length) {
        $('#top-for-day').removeClass('d-invisible')
        $('#top-items-date').text(value.x)
      } else {
        $('#top-for-day').addClass('d-invisible')
      }

      $('#top-items-total').text("Total: " + value.y);
      items_and_counts.map(function(item_and_count) {
        var rowHTML = '<tr>'
        rowHTML += '<td>' + item_and_count[0] + '</td>'
        rowHTML += '<td>' + item_and_count[1] + '</td>'
        rowHTML += '</td>'
        rowHTML += '</tr>'
        $('#top-for-day-table > tbody').append(rowHTML)
      });
    }
  })
}




var appointmentChartConfig = function(data) {
  var color = Chart.helpers.color;
  return {
    type: 'bar',
    data: {
      datasets: [
      {
        label: 'Appointments',
        backgroundColor: color(window.chartColors.blue).alpha(0.5).rgbString(),
        borderColor: window.chartColors.blue,
        fill: false,
        data: data.appointments
      },{
        label: 'Attendees',
        backgroundColor: color(window.chartColors.orange).alpha(0.5).rgbString(),
        borderColor: window.chartColors.orange,
        fill: false,
        data: data.attendees
      }]
    },
    options: {
      onClick: function(evt) {
         appointmentChartClick(evt)
      },
      responsive: true,
      title: {
        display: true,
        text: 'Appointments and Attendees'
      },
      scales: {
        xAxes: [{
          type: 'time',
          time: {
            unit: 'day'
          },
          display: true,
          scaleLabel: {
            display: true,
            labelString: 'Date'
          },
          ticks: {
            major: {
              fontStyle: 'bold',
              fontColor: '#FF0000'
            }
          }
        }],
        yAxes: [{
          display: true,
          scaleLabel: {
            display: true,
            labelString: 'value'
          }
        }],
        // tooltips: {
        //   callbacks: {
        //     label: function(tooltipItem, data) {
        //       var label = data.datasets[tooltipItem.datasetIndex].label || '';

        //       if (label) {
        //         label = moment.
        //       }
        //       label += Math.round(tooltipItem.yLabel * 100) / 100;
        //       return label;
        //     }
        //   }
        // }
      }
    }
  };

}

var appointmentChartClick = function(event) {
  var activePoint = appointmentChart.getElementAtEvent(event)[0];
  var data = activePoint._chart.data;
  var datasetIndex = activePoint._datasetIndex;
  var label = data.datasets[datasetIndex].label;
  var value = data.datasets[datasetIndex].data[activePoint._index];
  // $('#top-for-day-table > tbody > tr').remove();

  // $.ajax({
  //   url: '/metrics/dashboard/top_for_day?date=' + value.x,
  //   dataType: 'json',
  //   success: function(items_and_counts) {
  //     if (items_and_counts.length) {
  //       $('#top-for-day').removeClass('d-invisible')
  //       $('#top-items-date').text(value.x)
  //     } else {
  //       $('#top-for-day').addClass('d-invisible')
  //     }

  //     $('#top-items-total').text("Total: " + value.y);
  //     items_and_counts.map(function(item_and_count) {
  //       var rowHTML = '<tr>'
  //       rowHTML += '<td>' + item_and_count[0] + '</td>'
  //       rowHTML += '<td>' + item_and_count[1] + '</td>'
  //       rowHTML += '</td>'
  //       rowHTML += '</tr>'
  //       $('#top-for-day-table > tbody').append(rowHTML)
  //     });
  //   }
  // })
}





window.onload = function() {
  if (document.getElementById('item-chart')) {
    var itemChart = initChart('/metrics/dashboard/items', itemChartConfig, function(totals) {
      chartData = totals.map(function(total) {
        return {x: total[0], y: total[1]}
      })
      var config = itemChartConfig(chartData)
      var ctx = document.getElementById('item-chart').getContext('2d');
      window.itemChart = new Chart(ctx, config);
    });

    var appointmentChart = initChart('/metrics/dashboard/appointments', appointmentChartConfig, function(appointmentsAndAttendees) {
      var dateAndCountToXY = function(dateAndCount) { return {x: dateAndCount[0], y: dateAndCount[1], stack: dateAndCount[0]} }
      console.log(appointmentsAndAttendees, appointmentsAndAttendees.appointments )
      var appointments = appointmentsAndAttendees.appointments.map(dateAndCountToXY)
      var attendees = appointmentsAndAttendees.attendees.map(dateAndCountToXY)

      var config = appointmentChartConfig({appointments: appointments, attendees: attendees})
      var ctx = document.getElementById('appointments-chart').getContext('2d');
      window.appointmentChart = new Chart(ctx, config);
    });
  }
};
