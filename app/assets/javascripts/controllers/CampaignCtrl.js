myApp = angular.module('upsocl.controllers', [])

myApp.controller('CampaignListController', function($scope, $state, $http, $window, Campaign, Tags, User, CampaignFilter) {
  $scope.campaigns = Campaign.query();
  $scope.tags = Tags.query();
  $scope.user = User.get(function(data){
    setTimeout(function(){
      $('.chosen-input').chosen({
        allow_single_deselect: true,
        no_results_text: 'Sin resultados',
        width: "100%"
      })
    }, 500);
  });

  $scope.searchTags = function(){
    var ids = $('.chosen-input').val()
    $http.post('/campaigns/filter_by_tag.json', {tags_ids: ids}).then( function(response) {
      $scope.campaigns = response.data;
    })
  };

})

myApp.controller('CampaignUrlViewController', function($scope, $stateParams, Reactions, Url, User) {
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
})

myApp.controller('CampaignVideoViewController', function($scope, $stateParams, Reactions, Video, User) {
  $scope.date = { startDate: moment().subtract(2, "year"), endDate: moment() };
  $scope.opts = run_datepicker();
  $scope.user = User.get();
  $scope.reactions = Reactions.query();
  $scope.$watch('date', function(newDate) {
    var startDate = newDate.startDate.format('YYYY-MM-DD');
    var endDate = newDate.endDate.format('YYYY-MM-DD');
      Video.get({ id: $stateParams.id, startDate: startDate, endDate: endDate }, function(data){
        class_updated_at(data.created_at);
        // draw_graphics($stateParams.id, data.stadistics);
        $('#daterange').data('daterangepicker').setStartDate(moment().startOf("year"));
        $('#daterange').data('daterangepicker').setEndDate(moment());
        $scope.video = data
        if($scope.datePicker != void 0){
          $scope.datePicker.date = {startDate: null, endDate: null};
        }
      });
  }, false);
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

