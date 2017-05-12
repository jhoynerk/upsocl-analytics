var app = angular.module('upsocl',[
  'ngResource',
  'upsocl.controllers',
  'upsocl.controllers.url',
  'upsocl.services',
  'daterangepicker',
  'ui.router',
  'datatables',
  'localytics.directives'
])

app.filter('arrayToName', function() {
  return function(input) {
    var names = input.map(function(u){return u.name});
    var output = "";
    if(names.length > 0) {output = names.join(', ');}
    return output;
  }
});

app.config(function($stateProvider) {
  $stateProvider.state('campaigns', {
    url: '/',
    templateUrl: 'index_view',
    controller: 'CampaignListController'
  })
  .state('viewCampaignUrl', { //state for showing single movie
    url: '/campaign/urls/:id',
    templateUrl: 'show_view',
    controller: 'CampaignUrlViewController'
  })
  .state('viewCampaignVideo', { //state for showing single movie
    url: '/campaign/videos/:id',
    templateUrl: 'facebook_posts_view',
    controller: 'CampaignVideoViewController'
  })
  .state('viewAllCampaignUrl', { //state for showing single movie
    url: '/campaigns',
    templateUrl: 'show_all_view',
    controller: 'CampaignAllUrlViewController'

  })
  .state('viewReactions', {
    url: '/reactions?url&post_id&publico',
    params: {
        url: null,
        post_id: null
    },
    templateUrl: 'view_reactions',
    controller: 'ReactionsController'
  })
  .state('viewAllUrlCampaign', { //state for showing single movie
    url: '/urls',
    templateUrl: 'url_index_view',
    controller: 'UrlListController'});
})
.run(function($state) {
  $state.go('campaigns');
});
