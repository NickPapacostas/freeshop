window.chartColors = {
  red: 'rgb(255, 99, 132)',
  orange: 'rgb(255, 159, 64)',
  yellow: 'rgb(255, 205, 86)',
  green: 'rgb(75, 192, 192)',
  blue: 'rgb(54, 162, 235)',
  purple: 'rgb(153, 102, 255)',
  grey: 'rgb(201, 203, 207)'
};

var initChart = function() {
  var data = $.ajax({
    url: '/admin/dashboard/by_day',
    dataType: 'json',
    success: function(totals) {
      chartData = totals.map(function(total) {
        return {x: total[0], y: total[1]}
      })
      var config = chartConfig(chartData)
      var ctx = document.getElementById('canvas').getContext('2d');
      window.myChart = new Chart(ctx, config);
    }
  })
}

var chartConfig = function(data) {
  var color = Chart.helpers.color;
  return {
    type: 'bar',
    data: {
      datasets: [{
        label: 'Items checked out',
        backgroundColor: color(window.chartColors.blue).alpha(0.5).rgbString(),
        borderColor: window.chartColors.blue,
        fill: false,
        data: data
      }]
    },
    options: {
      onClick: function(evt) {
         chartClick(evt)
      },
      responsive: true,
      title: {
        display: true,
        text: 'Items Taken By Day'
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
        }]
      }
    }
  };

}

var chartClick = function(event) {
  var activePoint = myChart.getElementAtEvent(event)[0];
  var data = activePoint._chart.data;
  var datasetIndex = activePoint._datasetIndex;
  var label = data.datasets[datasetIndex].label;
  var value = data.datasets[datasetIndex].data[activePoint._index];
  $('#top-for-day-table > tbody > tr').remove();

  $.ajax({
    url: '/admin/dashboard/top_for_day?date=' + value.x,
    dataType: 'json',
    success: function(items_and_counts) {
      if (items_and_counts.length) {
        $('#top-for-day').removeClass('d-invisible')
        $('#top-items-date').text(value.x)
      } else {
        $('#top-for-day').addClass('d-invisible')
      }

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

window.onload = function() {
  initChart();
};
