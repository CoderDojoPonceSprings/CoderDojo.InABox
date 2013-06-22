// This is a module for cloud persistance in mongolab - https://mongolab.com
angular.module('mongolab', ['ngResource']).
factory('Signup', function ($resource) {
    var Signup = $resource('https://api.mongolab.com/api/1/databases/coderdojosignup/collections/signups/:id', {
        apiKey: 'bWK-cL1WKkJF6yyunAhSjhszvkkTTOlM'
    }, {
        update: {
            method: 'PUT'
        }
    });

    Signup.prototype.update = function (cb) {
        return Signup.update({
                id: this._id.$oid
            },
            angular.extend({}, this, {
                _id: undefined
            }), cb);
    };

    Signup.prototype.updateSafe = function (patch, cb) {
        Signup.get({id:this._id.$oid}, function(signup) {
            for(var prop in patch) {
                signup[prop] = patch[prop];
            }
            signup.update(cb);
        });
    };

    Signup.prototype.destroy = function (cb) {
        return Signup.remove({
            id: this._id.$oid
        }, cb);
    };

    return Signup;
});