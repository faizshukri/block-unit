angular.module 'app', ['ngResource', 'ngRoute', 'ui.bootstrap']
  .config ($routeProvider) ->
    $routeProvider
      .when "/",
        templateUrl: "main/main.html"
        controller: "MainCtrl"

