var app = angular.module('myApp', []);

var apiKey = 'MDIwMDU2MTI2MDE0Mzg2MDA5ODk1ODZmOQ001', 
nprUrl = 'http://api.npr.org/query?id=61&fields=relatedLink,title,byline,text,audio,image,pullQuote,all&output=JSON',
rest = 'http://localhost/v2-lt-1.0-SNAPSHOT/ws/rest/empMgmtRestService/getLastLoggedInTime/token/rrr/user/uuu/isMobile/rrr';
app.controller('PlayerController', function($scope, $http) {
  // Hidden our previous section's content
  // construct our http request

  $http({
    method: 'JSONP',
    url: nprUrl + '&apiKey=' + apiKey + '&callback=JSON_CALLBACK'
  }).success(function(data, status) {
    $scope.programs = data.list.story;
  }).error(function(data, status) {
    // Some error occurred
  });
});



app.controller('MyController', function($scope) {
  $scope.person = { name: "Ari Lerner" };
  var updateClock = function() {
    $scope.clock = new Date();
  };
  var timer = setInterval(function() {
    $scope.$apply(updateClock);
  }, 1000);
  
});

app.controller('DemoController', function($scope) {
  $scope.counter = 0;
  $scope.add = function(amount) { $scope.counter += amount; };
  $scope.subtract = function(amount) { $scope.counter -= amount; };
});

app.controller('RelatedController', function($scope, $http) {
  // Hidden our previous section's content
  // construct our http request
 $http.get(rest).
  .success(function(data, status) {
    $scope.programs = data.list.story;
  }).error(function(data, status) {
    // Some error occurred
  });
});