var Chance = require('chance');
var chance = new Chance();

var express = require('express');
var app = express();

app.get('/', function(req, res){
    var val = req.query.maxNb;
    var dateTime = new Date();
    console.log(dateTime);
    res.send(generateEmployees(val == undefined ? 10 : val))
});

app.listen(3000, function(){
    console.log('Accepting HTTP requests on port 3000.');
});

function generateEmployees(maxNb){
    var numberOfEmployees = chance.integer({
        min: 0,
        max: maxNb
    });

    var employees = [];

    for(var i = 0; i < numberOfEmployees; ++i){
        var gender = chance.gender()
        employees.push({
            firstName: chance.first({
                gender: gender
            }),
            lastName: chance.last(),
            gender: gender,
            email: chance.email(),
            salary: chance.euro()
        });
    }

    console.log(employees);

    return employees;
}