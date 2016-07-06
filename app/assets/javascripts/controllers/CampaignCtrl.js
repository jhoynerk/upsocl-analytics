myApp = angular.module('upsocl.controllers', [])

myApp.controller('CampaignListController', function($scope, $state, $window, Campaign) {
  $scope.campaigns = Campaign.query();
})

myApp.controller('CampaignUrlViewController', function($scope, $stateParams, Url) {
  $scope.date = { startDate: moment().subtract(2, "year"), endDate: moment() };
  $scope.opts = run_datepicker();
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

myApp.controller('ReactionsController', function($scope, $http, $stateParams, Reactions, ReactionData) {
  $scope.reactions = Reactions.query();
  $scope.url_path = $stateParams.url;
  if ($stateParams.url != null) {
    $scope.reactions_url = ReactionData.query( { url: $stateParams.url, post_id: $stateParams.post_id } );
  }
  $scope.if_vote = false;
  $scope.addVote = function(reaction_id, url_path){
    if($scope.if_vote == false && url_path != null){
      $http({
        url: '/votes.json', 
        method: "GET",
        params: {reaction_id: reaction_id, url_path: url_path}
      }).then(function(response) {
        $scope.reactions_url = response.data;
      });
      $scope.if_vote = true;
    }
  };

});

