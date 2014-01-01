var sys = require('sys')
var exec = require('child_process').exec;
var fs = require("fs");
var port = 8080;
var express = require("express");

var app = express();
var rootDirectory = "<%= @root_directory %>"
app.use(app.router);
var bowerJson = rootDirectory+"/puppet/environments/bower.json";

app.get("/environments", function(request, response) {
    printEnvironments(response);
});

app.get("/environments/((\\w+))", function(request, response){
    printJsonFile(response, rootDirectory+"/puppet/environments/"+request.params[0]+"/.bower.json");
});

app.post("/environments", function(request, response) {
    updateModules(response);
});

app.get("/servers", function(request, response) {
    printManagedServers(response);
});

app.listen(port);
function printManagedServers(response) {
    fs.readdir("/var/lib/puppet/ssl/ca/signed", function(err, files) {
        if(err) {
            writeError(response, err);
        } else {
            response.writeHeader(200, {"Content-Type": "application/json"});
            response.write(JSON.stringify(files.map(function(source) {return source.replace(".pem", "")}), null, 4));
            response.end();
        }
    });
}

function printEnvironments(response) {
    fs.readFile(bowerJson, "binary", function(err, data) {
        if(err) {
            writeError(response, err)
        } else {
            response.writeHeader(200, {"Content-Type": "application/json"});
            response.write(JSON.stringify(JSON.parse(data).dependencies, null, 4), "binary");
            response.end();
        }
    });    
}

function updateModules(response) {
    exec(rootDirectory+"/puppet/scripts/update-modules.sh", function(error, stdout, stderr) {
        if(error) {
            writeError(response, error)
        } else {
            response.writeHeader(200, {"Content-Type": "text/plain"});
            response.write(stdout);
            response.end();
        }
    });   
}

function printJsonFile (response, file) {
    fs.readFile(file, "binary", function(err, file) {
        if(err) {
            writeError(response, err)
        } else {
            response.writeHeader(200, {"Content-Type": "application/json"});
            response.write(JSON.stringify(JSON.parse(file), null, 4), "binary");
            response.end();
        }
    })
}

function writeError(response, error) {
    response.writeHeader(500, {"Content-Type": "text/plain"});
    response.write(error + "\n");
    response.end(); 
}