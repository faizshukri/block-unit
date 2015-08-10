angular.module 'app', ['ngResource', 'ngRoute', 'ngCookies', 'LocalStorageModule', 'ui.bootstrap']
  .config [ '$routeProvider', ($routeProvider) ->
    $routeProvider
      .when "/",
        templateUrl: "main/main.html"
        controller: "MainCtrl"
  ]