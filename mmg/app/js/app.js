"use strict";

angular.module("mmg", [
  "ngRoute",
  "mmg.filters",
  "mmg.services",
  "mmg.directives",
  "mmg.controllers",
  "ui.bootstrap"
])
.config(["$routeProvider", function($routeProvider) {
  $routeProvider.when("/", {templateUrl: "partials/map-generator.html", controller: "MapCtrl"});
  $routeProvider.otherwise({redirectTo: "/"});
}]);

_.mixin(_.string.exports());