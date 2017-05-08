myApp = angular.module('upsocl.services', [])

myApp.factory('Campaign', function($resource) {
  return $resource('/campaigns/:id.json');
}).factory('Tags', function($resource) {
  return $resource('/tags.json');
}).factory('CampaignFull', function($resource) {
  return $resource('/campaigns_full.json');
}).factory('User', function($resource) {
  return $resource('/user.json');
}).factory('Url', function($resource) {
  return $resource('/urls/:id.json');
}).factory('UrlUpdateStadistics', function($resource) {
  return $resource('/urls/:id/update_stadistics.json');
}).factory('Video', function($resource) {
  return $resource('/facebook_posts/:id.json');
}).factory('VideoUpdateStadistics', function($resource) {
  return $resource('/facebook_posts/:id/update_stadistics.json');
}).factory('Reactions', function($resource) {
  return $resource('/reactions.json');
}).factory('ReactionData', function($resource) {
  return $resource('/data_reactions.json', { method: 'GET', isArray: false });
}).factory('Tags', function($resource) {
  return $resource('/tags.json', { method: 'GET', isArray: false });
}).factory('Users', function($resource) {
  return $resource('/users.json');
}).factory('Agencies', function($resource) {
  return $resource('/agencies.json');
}).factory('CampaignFilter', function($resource) {
  return $resource('/campaigns.json');
});

