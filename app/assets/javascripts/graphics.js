
function draw_graphics(url_id, info){
  make_map_graphic(info.country_stadistics);
  make_pie_charts(info.traffic_stadistics, '#traffic_legend', 'traffic_chart', 'traffic_type');
  make_pie_charts(info.device_stadistics, '#device_legend', 'device_chart', 'device');
  make_bars_chart(info.page_stadistics);
}

function make_map_graphic(info){
  var data = {};
  $('#world-map>*').remove();
  $('.table-country>*').remove();
  $.each(info, function(index, i){
    data[i.code] = i.pageviews;
    $('.table-country').append('<tr><td>'+i.name+'</td><td class="text-center"><span class="label label-primary">'+i.pageviews_percent+'</span></td></tr>');
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
              scale: ["#40D2B4", "#22d6b1", "#128C73"],
              normalizeFunction: 'polynomial'
          }]
      },
  });
}

function make_pie_charts(info, legend_id, canvas_id, label){
  $(legend_id+">*").remove();
  var ctx = document.getElementById(canvas_id).getContext("2d");
  var colors = ["#1ab394", "#1c84c6","#ed5565","#23c6c8","#f8ac59","#9E9E9E"];

  var arr = [];
  $.each(info, function(index, i){
    arr.push({
      value: parseInt(i.pageviews),
      color: colors[index],
      label: i[label]
    });
  });
  var total = totalize(info, 'pageviews');

  var myPieChart = new Chart(ctx).Pie(arr, {
     segmentShowStroke: true,
     segmentStrokeColor: "#fff",
     segmentStrokeWidth: 2,
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

function set_process_data(hash, html_id){
  $(html_id).find('.stat-percent').html(hash.percent+'% <i class="'+hash.html_class+'">');
  $(html_id).find('.progress-bar').removeClass().addClass(hash.progress_class).width(hash.percent+'%');
}

function make_bars_chart(data){
  var arr_pageviews = [];

  $.each(data, function(index, i){
    arr_pageviews.push([moment(i.date).toDate(), parseInt(i.pageviews)])
  });



  $('#total-visits').html(totalize(arr_pageviews, 1));

  set_process_data(progress_percent(arr_pageviews, 1, 'normal'), '#visits-percent');
  var dataset = [
      {
          label: "Paginas Vistas",
          data: arr_pageviews,
          color: "#1ab394",
          bars: {
              show: true,
              align: "center",
              barWidth: 24 * 60 * 60 * 600,
              lineWidth: 0
          }

      }
  ];

  var options = {
      xaxis: {
          mode: "time",
          timeformat: "%d-%b-%Y",
          tickSize: [size_legend(data), "day"],
          tickLength: 0,
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
