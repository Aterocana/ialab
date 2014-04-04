var express = require("express");
var http = require("http");
var https = require("https");
var fs = require("fs");
var _ = require("underscore");
//var request = require("request");

// configure app
var app = express();
var server = require("http").createServer(app);
app.configure(function() {
    app.set("port", 4000);
    app.use(express.logger("dev"));
    app.use(express.cookieParser());
    app.use(express.urlencoded())
    app.use(express.json())
    app.use(express.methodOverride());
    app.use(express.session({
        secret: "phanes"
    }));
    app.use(express.static(__dirname + "/../app"));
    app.use(app.router);
    app.use(function(req, res, next) {
        res.header("Access-Control-Allow-Headers", "Content-Type, Authorization, Content-Length, X-Requested-With");
        res.header("Access-Control-Allow-Methods", "GET,PUT,POST,DELETE,OPTIONS");
        res.header("Access-Control-Allow-Origin", "*");
        res.header("Access-Control-Allow-Credentials", "TRUE");
        // intercept OPTIONS method
        if (req.method === "OPTIONS") {
            res.send(200);
        } else {
            next();
        }
    });
});
app.configure("development", function() {
    app.use(express.errorHandler());
});
app.enable("trust proxy");
server.listen(app.get("port"), function() {
    console.log("Server started on port", app.get("port"));
});