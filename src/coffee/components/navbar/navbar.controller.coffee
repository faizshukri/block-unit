angular.module "app"
  .controller "NavbarCtrl", ['$scope', ($scope) ->
    $scope.date = new Date()
  ]