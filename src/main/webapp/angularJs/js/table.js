var empid = 1;
        function tableController($scope, $http) {
	
	    $http.get('../ws/rest/empMgmtRestService/getAllEmployees').
        success(function(data) {
            $scope.employees = data;
	    
        });
 
            $scope.newEmployee = {};
 
            $scope.saveRecord = function () {
	     if($scope.newEmployee.id == null){
		$scope.new='yes';
	     }
	    
	    $http.post('../ws/rest/empMgmtRestService/save/employee', $scope.newEmployee ).
		success(function(data) {
		$scope.empId = data.id;
		console.log(' Data posted to server id is '+$scope.empId);
		$scope.newEmployee.id = $scope.empId;
		   
		    if($scope.new == 'yes'){
		    //create
		     console.log(' Create mode');
		    $scope.employees .push($scope.newEmployee);
		    }
		    else{
		    //update
			    $http.get('../ws/rest/empMgmtRestService/getAllEmployees').
				success(function(data) {
				    $scope.employees = data;
				    
				});
		    }
		   
		});
	    
		   
		 $scope.newEmployee = {};
 
            }
 
            $scope.delete = function (id) {
 
                for (i in $scope.employees) {
                    if ($scope.employees[i].id == id) {
                   
                        $scope.newEmployee = {};
                    }
                }
 
            }
 
            $scope.edit = function (id) {
                for (i in $scope.employees) {
                    if ($scope.employees[i].id == id) {
                        $scope.newEmployee = angular.copy($scope.employees[i]);
                    }
                }
            }
        }