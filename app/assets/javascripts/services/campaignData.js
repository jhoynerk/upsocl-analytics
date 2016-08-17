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
}).factory('Reactions', function($resource) {
  return $resource('/reactions.json');
}).factory('ReactionData', function($resource) {
  return $resource('/data_reactions.json', { method: 'GET', isArray: false });
});

