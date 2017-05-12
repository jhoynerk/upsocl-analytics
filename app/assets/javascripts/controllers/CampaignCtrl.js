myApp = angular.module('upsocl.controllers', [])

myApp.controller('CampaignListController', function($scope, $state, $http, $window, Campaign, Tags, User, Users, Agencies, CampaignFilter) {
  $scope.tags = Tags.query();
  $scope.users = Users.query();
  $scope.agencies = Agencies.query();
  $scope.filters = {};
  $scope.loading = false;
  $scope.filters['filter_date_range'] = 1;
  $scope.pagePerValues = [10,20,30];
  $scope.filters['paginate_regs'] = $scope.pagePerValues[0];
  $scope.filters['paginate_page'] = 1;
  $scope.page_title = "Lista de Campañas"
  $scope.model_name = "Campañas"

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
    $http.post('/campaigns/filter_by_tag.json', $scope.filters).then( function(response) {
      $scope.campaigns = response.data.campaigns;
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
    var lastReg = (($scope.paginate.first_page)? 0 : $scope.firstRegPage()) + Number($scope.filters.paginate_regs);
    return (lastReg>$scope.paginate.count)? $scope.paginate.count : lastReg;
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

myApp.controller('CampaignUrlViewController', function($scope, $stateParams, Reactions, Url, UrlUpdateStadistics, User) {
  $scope.date = { startDate: moment().subtract(2, "year"), endDate: moment() };
  $scope.opts = run_datepicker();
  $scope.user = User.get();
  $scope.reactions = Reactions.query();
  $scope.$watch('date', function(newDate) {
    var startDate = newDate.startDate.format('YYYY-MM-DD');
    var endDate = newDate.endDate.format('YYYY-MM-DD');
      Url.get({ id: $stateParams.id, startDate: startDate, endDate: endDate }, function(data){
        class_updated_at(data.created_at);
        draw_graphics($stateParams.id, data.stadistics);
        $('#daterange').data('daterangepicker').setStartDate(moment().startOf("year"));
        $('#daterange').data('daterangepicker').setEndDate(moment());
        $scope.url = data
        if($scope.datePicker != void 0){
          $scope.datePicker.date = {startDate: null, endDate: null};
        }
      });
  }, false);

  $scope.update_stadistics = function(){
    var $btn = $('.btn-stadistic-update').button('loading');
    var startDate = $scope.date.startDate.format('YYYY-MM-DD');
    var endDate = $scope.date.endDate.format('YYYY-MM-DD');
    UrlUpdateStadistics.get({id: $stateParams.id, startDate: startDate, endDate: endDate}, function(data){
        class_updated_at(data.created_at);
        draw_graphics($stateParams.id, data.stadistics);
        $('#daterange').data('daterangepicker').setStartDate(moment().startOf("year"));
        $('#daterange').data('daterangepicker').setEndDate(moment());
        $scope.url = data
        if($scope.datePicker != void 0){
          $scope.datePicker.date = {startDate: null, endDate: null};
        }
        $btn.button('reset');
    });
  }

})

myApp.controller('CampaignVideoViewController', function($scope, $sce, $stateParams, Reactions, Video, VideoUpdateStadistics, User) {
  $scope.date = { startDate: moment().subtract(2, "year"), endDate: moment() };
  $scope.opts = run_datepicker();
  $scope.user = User.get();
  $scope.reactions = Reactions.query();
  $scope.$watch('date', function(newDate) {
    var startDate = newDate.startDate.format('YYYY-MM-DD');
    var endDate = newDate.endDate.format('YYYY-MM-DD');
    Video.get({ id: $stateParams.id, startDate: startDate, endDate: endDate }, function(data){
      class_updated_at(data.created_at);
      $('#daterange').data('daterangepicker').setStartDate(moment().startOf("year"));
      $('#daterange').data('daterangepicker').setEndDate(moment());
      $scope.detailFrame = $sce.trustAsResourceUrl(data.url_video)
      $scope.video = data
      if($scope.datePicker != void 0){
        $scope.datePicker.date = {startDate: null, endDate: null};
      }
    });
  }, false);

  $scope.update_stadistics = function(){
    var $btn = $('.btn-stadistic-update').button('loading');
    VideoUpdateStadistics.get({id: $stateParams.id}, function(data){
      class_updated_at(data.created_at);
      $('#daterange').data('daterangepicker').setStartDate(moment().startOf("year"));
      $('#daterange').data('daterangepicker').setEndDate(moment());
      $scope.detailFrame = $sce.trustAsResourceUrl(data.url_video);
      $scope.video = data;
      $btn.button('reset');
    });
  }
})


myApp.controller('CampaignAllUrlViewController', function($scope, $stateParams, User) {
  $scope.user = User.get();
});


function WithAjaxCtrl($scope, DTOptionsBuilder, DTColumnBuilder, Tags) {
  $scope.options = Tags.query();
  var vm = this;
  vm.options = {
      aoColumnDefs: [
          {
            sType: "numeric",
            aTargets: 0,
            bSortable: false
          }
      ]
  };
  vm.dtOptions = DTOptionsBuilder.fromSource('/campaigns_full.json')
      .withPaginationType('full_numbers')
      .withLanguageSource('/assets/spanish.json')
  vm.dtColumns = [
      DTColumnBuilder.newColumn('title').withTitle('Título').renderWith(function(data, type, full) {
          return '[<a target="_blank" href="'+ full.link +'">Sitio</a>] <a href="/#/campaign/urls/'+ full.id +'" target="_blank" >' + full.title + '</a>';
      }),
      DTColumnBuilder.newColumn('id').withTitle('id').notVisible(),
      DTColumnBuilder.newColumn('visitas').withTitle('Visitas'),
      DTColumnBuilder.newColumn('shares').withTitle('Shares'),
      DTColumnBuilder.newColumn('comments').withTitle('Comments'),
      DTColumnBuilder.newColumn('likes').withTitle('Likes'),
      DTColumnBuilder.newColumn('Divertido').withTitle('<a class="title-link" href="#" data-title="Divertido"><img width="20px" src="/uploads/reaction/avatar/5/risa.png"></a>'),
      DTColumnBuilder.newColumn('Indiferente').withTitle('<a class="title-link" href="#" data-title="Indiferente"> <img width="20px" src="/uploads/reaction/avatar/4/normal.png"></a>'),
      DTColumnBuilder.newColumn('Sorprendido').withTitle('<a class="title-link" href="#" data-title="Sorprendido"> <img width="20px" src="/uploads/reaction/avatar/3/sorprende.png"></a>'),
      DTColumnBuilder.newColumn('Molesto').withTitle('<a class="title-link" href="#" data-title="Molesto"> <img width="20px" src="/uploads/reaction/avatar/2/molesta.png"></a>'),
      DTColumnBuilder.newColumn('Entusiasmado').withTitle('<a class="title-link" href="#" data-title="Entusiasmado"> <img width="20px" src="/uploads/reaction/avatar/1/enamora.png"></a>'),
      DTColumnBuilder.newColumn('Total').withTitle('Total').renderWith(function(data, type, full) {
          return full.Divertido + full.Indiferente + full.Sorprendido + full.Molesto + full.Entusiasmado ;
      }),
  ];
  $scope.selected = function(tags){
    vm.dtOptions = DTOptionsBuilder.fromSource('/campaigns_full.json?tags='+tags)
      .withPaginationType('full_numbers')
      .withLanguageSource('/assets/spanish.json')
  };
};

myApp.controller('WithAjaxCtrl', WithAjaxCtrl);

myApp.controller('ReactionsController', function($scope, $http, $stateParams, Reactions, ReactionData) {
  $scope.reactions = Reactions.query();
  $scope.url_path = $stateParams.url;
  if ($stateParams.url != null) {
    $scope.reactions_url = ReactionData.query( { url: $stateParams.url, post_id: $stateParams.post_id, publico: $stateParams.publico } );
  }
  $scope.new_vote = true;
  $scope.vote = null;
  $scope.addVote = function(reaction_id, url_path){
    if($scope.new_vote == true && url_path != null){
      $http({
        url: '/votes.json', 
        method: "GET",
        params: {reaction_id: reaction_id, url_path: url_path}
      }).then(function(response) {
        $scope.reactions_url = response.data;
      });
      $scope.new_vote = false;
      $scope.vote = reaction_id;
    }else{
      $http({
        url: '/change_vote.json',
        method: "GET",
        params: { reaction_id: reaction_id, url_path: url_path, before_vote: $scope.vote }
      }).then( function(response) {
        $scope.reactions_url = response.data;
        $scope.vote = reaction_id;
      })
    }

  };

});

myApp.controller('MyUser',function($scope, User) {
    $scope.user = User.get();
});

