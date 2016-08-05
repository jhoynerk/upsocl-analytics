myApp = angular.module('upsocl.controllers', [])

myApp.controller('CampaignListController', function($scope, $state, $window, Campaign) {
  $scope.campaigns = Campaign.query();
})

myApp.controller('CampaignUrlViewController', function($scope, $stateParams, Reactions, Url) {
  $scope.date = { startDate: moment().subtract(2, "year"), endDate: moment() };
  $scope.opts = run_datepicker();
  $scope.reactions = Reactions.query();
  $scope.$watch('date', function(newDate) {
    var startDate = newDate.startDate.format('YYYY-MM-DD');
    var endDate = newDate.endDate.format('YYYY-MM-DD');
      $scope.url = Url.get({ id: $stateParams.id, startDate: startDate, endDate: endDate }, function(data){
        class_updated_at(data.created_at);
        draw_graphics($stateParams.id, data.stadistics);
        $('#daterange').data('daterangepicker').setStartDate(moment().startOf("year"));
        $('#daterange').data('daterangepicker').setEndDate(moment());
        $scope.datePicker.date = {startDate: null, endDate: null};
      });
  }, false);
})


myApp.controller('CampaignAllUrlViewController', function($scope, $stateParams, CampaignFull, Reactions) {
  $scope.reactions = Reactions.query();
});


function WithAjaxCtrl(DTOptionsBuilder, DTColumnBuilder) {
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
        .withPaginationType('full_numbers');
    vm.dtColumns = [
        DTColumnBuilder.newColumn('title').withTitle('Título'),
        DTColumnBuilder.newColumn('visitas').withTitle('Visitas'),
        DTColumnBuilder.newColumn('shares').withTitle('Shares'),
        DTColumnBuilder.newColumn('comments').withTitle('Comments'),
        DTColumnBuilder.newColumn('likes').withTitle('Likes'),
        DTColumnBuilder.newColumn('Divertido').withTitle('Divertido'),
        DTColumnBuilder.newColumn('Indiferente').withTitle('Indiferente'),
        DTColumnBuilder.newColumn('Sorprendido').withTitle('Sorprendido'),
        DTColumnBuilder.newColumn('Molesto').withTitle('Molesto'),
        DTColumnBuilder.newColumn('Entusiasmado').withTitle('Entusiasmado')
    ];
};

myApp.controller('WithAjaxCtrl', WithAjaxCtrl);

myApp.controller('ReactionsController', function($scope, $http, $stateParams, Reactions, ReactionData) {
  $scope.reactions = Reactions.query();
  $scope.url_path = $stateParams.url;
  if ($stateParams.url != null) {
    $scope.reactions_url = ReactionData.query( { url: $stateParams.url, post_id: $stateParams.post_id } );
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

