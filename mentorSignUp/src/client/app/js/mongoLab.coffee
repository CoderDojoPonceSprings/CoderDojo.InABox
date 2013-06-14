# This is a module for cloud persistance in mongolab - https://mongolab.com
angular.module("mongolab", ["ngResource"]).factory "Signup", ($resource) ->
  options = {
    apiKey: "bWK-cL1WKkJF6yyunAhSjhszvkkTTOlM"
    update:
      method: "PUT"
  }
  Signup = $resource "https://api.mongolab.com/api/1/databases/coderdojosignup/collections/signups/:id", options
  Signup::update = (cb) ->
    Signup.update
      id: @_id.$oid
    , angular.extend({}, this,
      _id: `undefined`
    ), cb

  Signup::destroy = (cb) ->
    Signup.remove
      id: @_id.$oid
    , cb