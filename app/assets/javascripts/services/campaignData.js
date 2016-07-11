myApp = angular.module('upsocl.services', [])

myApp.factory('Campaign', function($resource) {
  return $resource('/campaigns/:id.json');
}).factory('Url', function($resource) {
  return $resource('/urls/:id.json');
}).factory('Reactions', function($resource) {
  return $resource('/reactions.json');
}).factory('ReactionData', function($resource) {
  return $resource('/data_reactions.json', { method: 'GET', isArray: false });
});

