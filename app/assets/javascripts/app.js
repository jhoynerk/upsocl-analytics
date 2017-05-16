var app = angular.module('upsocl',[
  'ngResource',
  'upsocl.shared',
  'upsocl.controllers',
  'upsocl.controllers.url',
  'upsocl.controllers.video',
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
  $stateProvider.state('viewAllUrlCampaign', { 
    url: '/',
    templateUrl: 'url_index_view',
    controller: 'UrlListController'})
  .state('campaigns', {
    url: '/campaigns',
    templateUrl: 'index_view',
    controller: 'CampaignListController'
  })
  .state('viewCampaignUrl', { 
    url: '/campaign/urls/:id',
    templateUrl: 'show_view',
    controller: 'CampaignUrlViewController'
  })
  .state('viewCampaignVideo', {
    url: '/campaign/videos/:id',
    templateUrl: 'facebook_posts_view',
    controller: 'CampaignVideoViewController'
  })
  .state('viewAllCampaignUrl', { 
    url: '/campaigns2',
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
  .state('viewAllVideoCampaign', { 
    url: '/videos',
    templateUrl: 'video_index_view',
    controller: 'VideoListController'});
})
.run(function($state) {
  $state.go('viewAllUrlCampaign');
});
