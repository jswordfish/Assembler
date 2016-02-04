

function Hello($scope, $http) {
    $http.get('http://localhost/v2-lt-1.0-SNAPSHOT/ws/rest/empMgmtRestService/getLastLoggedInTime/token/rrr/user/uuu/isMobile/rrr').
        success(function(data) {
            $scope.organizations = data;
        });
	
	
	
}