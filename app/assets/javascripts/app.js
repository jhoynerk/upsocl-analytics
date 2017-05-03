var app = angular.module('upsocl',[
  'ngResource',
  'upsocl.controllers',
  'upsocl.services',
  'daterangepicker',
  'ui.router',
  'datatables',
  'localytics.directives'
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
  }).state('viewCampaignVideo', { //state for showing single movie
    url: '/campaign/videos/:id',
    templateUrl: 'facebook_posts_view',
    controller: 'CampaignVideoViewController'
  }).state('viewAllCampaignUrl', { //state for showing single movie
    url: '/campaigns',
    templateUrl: 'show_all_view',
    controller: 'CampaignAllUrlViewController'
  }).state('viewReactions', {
    url: '/reactions?url&post_id&publico',
    params: {
        url: null,
        post_id: null
    },
    templateUrl: 'view_reactions',
    controller: 'ReactionsController'
  });
}).run(function($state) {
  $state.go('campaigns');
});
