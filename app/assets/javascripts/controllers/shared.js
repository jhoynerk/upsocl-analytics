myApp = angular.module('upsocl.shared', [])

myApp.factory('searchTags', function($http, $parse) {
  return function($scope, model_name) {
    var ids = $('.chosen-input').val();
    var model = $parse(model_name);
    $scope.loading = true;
    $http.post('/'+model_name+'/filter_by_tag.json', $scope.filters).then( function(response) {
      model.assign($scope, response.data.records);
      $scope.paginate = response.data.paginate;
      $scope.loading = false;
      setTimeout(function(){
      $('[data-toggle="tooltip"]').tooltip();
    }, 500);
    })
  }
});

myApp.factory('paginatePages', function() {
  return function($scope) {
   var data = [];
    var checkMin = ($scope.paginate.current_page - 5);
    var checkMax = ($scope.paginate.current_page + 5);
    var min = (checkMin < 1)? 1 : checkMin
    var max = (checkMax > $scope.paginate.total_pages)? $scope.paginate.total_pages : checkMax
    for(var i = min; i <= max; i++) {
      data.push(i);
    }
    return data;
  }
});