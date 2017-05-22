function totalize(arr, key){
  return _.reduce(arr, function(memo, num){ return memo + num[key]; }, 0);
}

function date_format(date){
  if (date != null){
    return date.format('YYYY-MM-DD');
  }else {
    return null;
  }

}

function class_updated_at(date){
  var html_class = 'text-navy';
  var text = ' Los datos se actualizan diariamente ';
  var days = moment().diff(date, 'days');

  if (days > 21 && days < 90){
    html_class = 'text-warning';
    text = ' Los datos se esta actualizando mensualmente ';
  }else if( days > 90 ){
    html_class = 'text-danger';
    text = ' Los datos se actualizan cada 6 meses ';
  }
  $('.color_updated_at').addClass(html_class);
  $('#text-updated-at').text(text);
}

function toPercent(total, value){
  return (value * 100) / total
}

function size_legend(arr){
  var limit = 1;
  if (arr.length > 0){
    var date_start = moment(_.first(arr)['date']);
    var date_end = moment(_.last(arr)['date']);
    var diff = date_end.diff(date_start, 'days');

    if(diff > 70){
      limit = 15;
    }else if(diff > 30){
      limit = 5;
    }else if(diff > 20){
      limit = 2;
    }
  }
  return limit;
}

function progress_percent(arr, label, typeData){
  if (arr.length > 1){
    var today = arr[arr.length - 1][label];
    var last_day = arr[arr.length -2][label];
    var html_class;
    var progress_class;

    if (today < last_day){
      html_class = 'text-danger fa fa-level-down';
      progress_class = 'progress-bar progress-bar-danger';
      if (last_day <= 0) { last_day = 1; }
      var percent = ((today - last_day) / last_day) * 100;
    }else{
      html_class = 'text-navy fa fa-level-up';
      progress_class = 'progress-bar';
      if (last_day <= 0) { last_day = 1; }
      var percent = ((today - last_day) / last_day) * 100;
    }
    return {percent: Math.abs(percent.toFixed()), html_class: html_class, progress_class: progress_class}
  }else {
    return {percent: 0, html_class: 'text-navy fa fa-level-up', progress_class: 'progress-bar'}
  }


}

String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
}

function get_report(){
  var pdf = new jsPDF('p', 'in', [17,42]);
   var options = {
      pagesplit: false
  };
  $(".wrapper-content").css('background', '#f3f3f4')
  pdf.addHTML($('.wrapper-content'), 0, 0, options, function(){
      pdf.save("Upsocl Analitycs Report.pdf");
  });
}
