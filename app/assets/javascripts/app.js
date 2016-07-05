var app = angular.module('upsocl',[
  'ngResource',
  'upsocl.controllers',
  'upsocl.services',
  'daterangepicker',
  'ui.router'
])

app.config(function($stateProvider) {
  $stateProvider.state('campaigns', {
    url: '/',
    templateUrl: 'index_view',
    controller: 'CampaignListController'
  }).state('viewCampaignUrl', { //state for showing single movie
    url: '/campaign/urls/:id',
    templateUrl: 'show_view',
    controller: 'CampaignUrlViewController'
  }).state('viewReactions', {
    url: '/reactions?url&post_id',
    params: {
        url: null,
        post_id: null
    },
    templateUrl: 'view_reactions',
    controller: 'ReactionsController'
  })
}).run(function($state) {
  $state.go('campaigns');
});
