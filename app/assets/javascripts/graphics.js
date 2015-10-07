function show_country(url_id){

  $.get('/analytics/graphs/'+url_id, function(info){
    make_map_graphic(info.Country);
    make_pie_charts(info.Traffic, '#traffic_legend', 'traffic_chart', 'traffictype');
    make_pie_charts(info.Device, '#device_legend', 'device_chart', 'deviceCategory');
    make_bars_chart(info.Historical)
  });

}

function make_map_graphic(info){
  var data = {};
  $.each(info, function(index, item){
    i = item.table;
    data[i.countryIsoCode] = i.pageviews;
    $('.table-country').append('<tr><td>'+i.country+'</td><td class="text-center"><span class="label label-primary">'+i.pageviews+'</span></td></tr>');
  });

  $('#world-map').vectorMap({
      map: 'world_mill_en',
      backgroundColor: "transparent",
      regionStyle: {
          initial: {
              fill: '#e4e4e4',
              "fill-opacity": 0.9,
              stroke: 'none',
              "stroke-width": 0,
              "stroke-opacity": 0
          }
      },

      series: {
          regions: [{
              values: data,
              scale: ["#1ab394", "#22d6b1"],
              normalizeFunction: 'polynomial'
          }]
      },
  });
}

function make_pie_charts(info, legend_id, canvas_id, label){
  var ctx = document.getElementById(canvas_id).getContext("2d");
  var colors = ["#ed5565", "#1c84c6","#1ab394","#23c6c8","#f8ac59","#9E9E9E"];

  var arr = [];

  $.each(info, function(index, item){
    var i = item.table;
    arr.push({
      value: parseInt(i.pageviews),
      color: colors[index],
      label: i[label]
    });
  });
  var total = totalize(info, 'pageviews');
  console.log()
  var myPieChart = new Chart(ctx).Pie(arr, {
     segmentShowStroke: true,
     segmentStrokeColor: "#fff",
     segmentStrokeWidth: 5 ,
     animationSteps: 100,
     animationEasing: "easeOutBounce",
     animateRotate: true,
     animateScale: false,
     responsive: true,
     legendTemplate: "<ul class=\"<%=name.toLowerCase()%>-legend list-group\"><% for (var i=0; i<segments.length; i++){%><li class=\"list-group-item \"><span class=\"badge \" style=\"color:white;background-color:<%=segments[i].fillColor%>\"><%= toPercent(total, segments[i].value).toFixed(2) %>%</span><%if(segments[i].label){%><%=segments[i].label.capitalize()%><%}%></li><%}%></ul>"

  });
  var legend = myPieChart.generateLegend();
  $(legend_id).append(legend);

}

function make_bars_chart(data){
  var arr_visitors = [];
  var arr_avgtimeonpage = [];
  var i;

  $.each(data, function(index, item){
    var i = item.table
    arr_visitors.push([moment(i.date, 'YYYYMMDD').toDate(), parseInt(i.visitors)])
    arr_avgtimeonpage.push([moment(i.date, 'YYYYMMDD').toDate(), parseInt(i.avgtimeonpage) / 60])
  });

  $('#total-visits').html(totalize(arr_visitors, 1));
  $('#total-time').html((totalize(arr_avgtimeonpage, 1) / arr_avgtimeonpage.length).toFixed() + ' Min');

  var dataset = [
      {
          label: "Paginas Vistas",
          data: arr_visitors,
          color: "#1ab394",
          bars: {
              show: true,
              align: "center",
              barWidth: 24 * 60 * 60 * 600,
              lineWidth: 0
          }

      }, {
          label: "Tiempo Promedio (Min)",
          data: arr_avgtimeonpage,
          yaxis: 2,
          color: "#1C84C6",
          lines: {
              lineWidth: 1,
              show: true,
              fill: true,
              fillColor: {
                  colors: [{
                      opacity: 0.2
                  }, {
                      opacity: 0.2
                  }]
              }
          },
          splines: {
              show: false,
              tension: 0.6,
              lineWidth: 1,
              fill: 0.1
          },
      }
  ];


  var options = {
      xaxis: {
          mode: "time",
          tickSize: [1, "day"],
          tickLength: 0,
          axisLabel: "Date",
          axisLabelUseCanvas: true,
          axisLabelFontSizePixels: 12,
          axisLabelFontFamily: 'Arial',
          axisLabelPadding: 10,
          color: "#d5d5d5"
      },
      yaxes: [{
          position: "left",
          color: "#d5d5d5",
          axisLabelUseCanvas: true,
          axisLabelFontSizePixels: 12,
          axisLabelFontFamily: 'Arial',
          axisLabelPadding: 1
      }, {
          position: "right",
          clolor: "#d5d5d5",
          axisLabelUseCanvas: true,
          axisLabelFontSizePixels: 12,
          axisLabelFontFamily: ' Arial',
          axisLabelPadding: 67
      }
      ],
      legend: {
          noColumns: 1,
          labelBoxBorderColor: "#000000",
          position: "nw"
      },
      grid: {
          hoverable: false,
          borderWidth: 0
      }
  };

  $.plot($("#flot-dashboard-chart"), dataset, options);

}
