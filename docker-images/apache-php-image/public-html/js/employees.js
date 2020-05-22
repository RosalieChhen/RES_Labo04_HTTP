$(function(){

    function loadEmployees(){
        $.getJSON( "/api/employees/", function( employees ) {
            $('#employees tbody').empty();
            $.each( employees, function( id, employee ) {
                $("#employees tbody").append('<tr><td>' + employee.firstName + '</td><td>' + employee.lastName + '</td><td>' + employee.gender + '</td><td>' + employee.email + '</td><td>' + employee.salary + '</td></tr>')
            });
        });
    }

    loadEmployees();
    setInterval(loadEmployees, 5000);

});