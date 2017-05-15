myApp = angular.module('upsocl.controllers.url', [])

myApp.controller('UrlListController', function($scope, $state, $http, $window,
	Url, Tags, User, Users, Agencies, UrlFilter) {

  $scope.tags = Tags.query();
  $scope.users = Users.query();
  $scope.agencies = Agencies.query();
  $scope.filters = {};
  $scope.loading = false;
  $scope.filters['filter_date_range'] = 1;
  $scope.pagePerValues = [10,20,30];
  $scope.filters['paginate_regs'] = $scope.pagePerValues[0];
  $scope.filters['paginate_page'] = 1;
  $scope.page_title = "Lista de Articulos"
  $scope.model_name = "Articulos"

  $scope.user = User.get(function(data){
    setTimeout(function(){
      $('ul.nav.nav-tabs li').on('click', function(){
        $currentTab = $(this);
        $dateFilter = $currentTab.data('dateFilter');
        $currentTab.addClass('active');
        $currentTab.siblings().removeClass('active');
      })

      $('.chosen-input').chosen({
        allow_single_deselect: true,
        no_results_text: 'Sin resultados',
        width: "100%"
      })
      $('[data-toggle="tooltip"]').tooltip();
    }, 500);
  });

  $scope.changeDateRange = function(opt){
    $scope.filters['filter_date_range'] = opt
    $scope.filters['paginate_page'] = 1;
    $scope.searchTags();
  }

  $scope.searchTags = function(){
    var ids = $('.chosen-input').val();
    $scope.loading = true;
    $http.post('/urls/filter_by_tag.json', $scope.filters).then( function(response) {
      $scope.urls = response.data.urls;
      $scope.paginate = response.data.paginate;
      $scope.loading = false;
      setTimeout(function(){
      $('[data-toggle="tooltip"]').tooltip();
    }, 500);
    })
  };
  $scope.paginatePages = function(){
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

  $scope.firstRegPage = function(){
    var isEndPage = ($scope.paginate.last_page || $scope.paginate.first_page);
    return ($scope.paginate.first_page)? $scope.paginate.current_page : (($scope.paginate.current_page-1) * $scope.filters.paginate_regs)
  }

  $scope.lastRegPage = function(){
    var lastReg = Number($scope.filters.paginate_regs) + (($scope.paginate.first_page) ? 0 : $scope.firstRegPage()) ;
    return (lastReg > $scope.paginate.count) ? $scope.paginate.count : lastReg;
  }

  $scope.toPage = function(page){
    $scope.filters['paginate_page'] = page;
    $scope.searchTags();
  }

  $scope.lastPage = function(){
    $scope.toPage($scope.paginate.total_pages)
  }

  $scope.firstPage = function(){
    $scope.toPage(1)
  }

  $scope.nextPage = function(){
    var nextPage = ($scope.filters['paginate_page'] + 1);
    var navigateTo = (nextPage > $scope.paginate.total_pages)? $scope.paginate.total_pages : nextPage
    $scope.toPage(navigateTo)
  }

  $scope.prevPage = function(){
    var nextPage = ($scope.filters['paginate_page'] -1);
    var navigateTo = (nextPage < 1)? 1 : nextPage
    $scope.toPage(navigateTo);
  }

  $scope.searchTags();


})
