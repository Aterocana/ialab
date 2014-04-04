"use strict";

angular.module("mmg.controllers", []).
controller("MapCtrl", ["$scope", "$modal", function($scope, $modal) {
    var findEntryGate = function() {
        return _.find($scope.cells, function(cell) {
            return cell.type === "entrygate";
        });
    };
    var computeDirection = function(entryGate) {
        if(entryGate.c === 1) {
            return "east";
        }
        if(entryGate.c === $scope.w) {
            return "west";
        }
        if(entryGate.r === 1) {
            return "north";
        }
        return "south";
    };
    $scope.w = 11;
    $scope.h = 10;
    $scope.time = "1000";
    $scope.types = ["border", "gate", "entrygate", "hill", "lake", "rural", "urban"];
    $scope.selectedType = $scope.types[0];
    $scope.generate = function() {
        if($scope.w && $scope.h) {
            $scope.map = [];
            $scope.cells = [];
            for(var i = 0; i < $scope.h; i++) {
                $scope.map[i] = [];
                for(var j = 0; j < $scope.w; j++) {
                    var type = (!i || !j || i === $scope.h - 1 || j === $scope.w - 1)? "border" : "rural";
                    $scope.cells.push($scope.map[i][j] = new Cell(type, $scope.h - i, j + 1));
                }
            };
        }
    };
    $scope.paint = function(cell) {
        var boundary = (cell.c.isBetween(2, $scope.w - 1) || cell.r.isBetween(2, $scope.h - 1)) &&
            !(cell.c.isBetween(2, $scope.w - 1) && cell.r.isBetween(2, $scope.h - 1));
        //Check to prevent painting a gate or a border on a non-boundary cell
        if(/gate|border/.test($scope.selectedType) && !boundary) {
            toastr.warning(_.sprintf("%s cell type only allowed on boundary slots", $scope.selectedType));
        } else {
            //If painting an entrygate, make sure none exist yet
            if(/entrygate/.test($scope.selectedType) && !!findEntryGate()) {
                toastr.warning("There can only be one entry gate");
                return;
            }
            cell.type = $scope.selectedType;
        }
    };
    $scope.export = function() {
        var entryGate = findEntryGate();
        if(!entryGate) {
            toastr.error("No entry gate specified");
            return;
        }
        var code = ["(deffacts init (create)"];
        code.push(_.sprintf("\t(maxduration %s)", $scope.time));
        code.push("\t(initial_agentstatus");
        code.push("\t\t(pos-r R) (pos-c C)".replace(/R|C/g, function(replacement) {
            return entryGate[replacement.toLowerCase()];
        }));
        code.push(_.sprintf("\t\t(direction %s)", computeDirection(entryGate)));
        code.push("\t)\n)\n");
        code.push("(deffacts initialmap");
        _.each($scope.map, function(row) {
            _.each(row, function(cell) {
                code.push("\t(prior_cell (pos-r R) (pos-c C) (type TYPE))".replace(/R|C|TYPE/g, function(replacement) {
                    var TYPE = cell[replacement.toLowerCase()];
                    return TYPE === "entrygate"? "gate" : TYPE;
                }));
            });
        });
        code.push(")");
        $scope.code = code.join("\n");
        $modal.open({
            templateUrl: "partials/modal.html",
            backdrop: "static",
            keyboard: true,
            scope: this
        });
    };
    $scope.selectAll = function() {
        $("#code").select();
    };
    //runtime
    $scope.generate();
}]);

var Cell = function(type, r, c) {
    return {
        type: type,
        r: r,
        c: c
    };
};

Number.prototype.isBetween = function(a, b) {
    return a <= this && this <= b;
};