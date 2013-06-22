// Generated by CoffeeScript 1.6.2
(function() {
  var app, checklist, selectedItems;

  checklist = function(items) {
    var id, item, skills, _i, _len;

    id = 0;
    skills = [];
    for (_i = 0, _len = items.length; _i < _len; _i++) {
      item = items[_i];
      skills.push({
        name: item,
        id: id++,
        checked: false
      });
    }
    return skills;
  };

  selectedItems = function(items) {
    var item, selected, _i, _len;

    selected = [];
    for (_i = 0, _len = items.length; _i < _len; _i++) {
      item = items[_i];
      if (item.checked) {
        selected.push({
          name: item.name,
          id: item.id
        });
      }
    }
    return selected;
  };

  app = angular.module('mentorSignUp', ['ui.bootstrap', 'mongolab']);

  app.config([
    '$routeProvider', function($routeProvider) {
      $routeProvider.when('/', {
        templateUrl: 'partials/form.html',
        controller: 'FormController'
      });
      $routeProvider.when('/thankyou', {
        templateUrl: 'partials/thankyou.html',
        controller: 'ThankyouController'
      });
      $routeProvider.when('/signups', {
        templateUrl: 'partials/signups.html',
        controller: 'SignupsController'
      });
      return $routeProvider.otherwise({
        redirectTo: '/'
      });
    }
  ]);

  app.controller('FormController', [
    '$rootScope', '$scope', '$location', 'Signup', '$http', function($rootScope, $scope, $location, Signup, $http) {
      $scope.form = {
        email: '',
        firstName: '',
        lastName: '',
        company: '',
        title: '',
        zip: '',
        expertise: '',
        other: '',
        kidExperience: false,
        tshirtSize: 'Medium',
        backgroundCheck: false
      };
      $scope.mentorSkills = checklist(['Arduino / Raspberry Pi / Hardware hacking', 'CSS', 'HTML5', 'JavaScript', 'Node.js', 'Scratch', 'Python', 'Ruby', 'PHP', 'Java', 'C#', 'Robotics']);
      $scope.additionalSkill = '';
      $scope.additionalSkills = [];
      $scope.additionalSkillAdd = function() {
        if ($scope.additionalSkill === '') {
          return;
        }
        $scope.additionalSkills.push({
          name: $scope.additionalSkill,
          checked: true
        });
        return $scope.additionalSkill = '';
      };
      $scope.additionalSkillRemove = function(index) {
        return $scope.additionalSkills.splice(index, 1);
      };
      $scope.additionalSkillAddDisabled = function() {
        return $scope.additionalSkill === '';
      };
      $scope.volunteerOffers = checklist(['Mentoring kids on technology', 'Leading a 4-week exploration on a topic', 'Donating or reimaging computers', 'Reaching out to local schools to tell them about CoderDojo Ponce Springs', 'Supporting events as a volunteer']);
      $scope.availability = checklist(['Sat June 29, 2 - 5 PM', 'Sat July 13, 2 - 5 PM', 'Sat July 27, 2 - 5 PM', 'Sat August 10, 2 - 5 PM', 'Sat August 24, 2 - 5 PM']);
      $scope.tshirtSizes = ['Small', 'Medium', 'Large', 'X-Large', 'XX-Large'];
      $scope.tshirtSizeSelect = function(tshirtSize) {
        return $scope.form.tshirtSize = tshirtSize;
      };
      return $scope.submit = function() {
        var html,
          _this = this;

        $scope.form.mentorSkills = selectedItems($scope.mentorSkills);
        $scope.form.volunteerOffers = selectedItems($scope.volunteerOffers);
        $scope.form.submitDate = new Date();
        $scope.form.additionalSkills = $scope.additionalSkills;
        html = document.getElementById('message').innerHTML;
        return Signup.save($scope.form, function(signup) {
          $rootScope.signup = signup;
          signup.html = html;
          $http({
            url: '/submit',
            method: 'POST',
            data: signup
          });
          return $location.path('/thankyou');
        });
      };
    }
  ]);

  app.controller('ThankyouController', [
    '$rootScope', '$scope', function($rootScope, $scope) {
      return $scope.name = "" + $rootScope.signup.firstName;
    }
  ]);

  app.controller('SignupsController', [
    '$rootScope', '$scope', 'Signup', function($rootScope, $scope, Signup) {
      var queryAll, queryOnlyMissingSomething, refreshList;

      queryAll = {
        f: JSON.stringify({
          id: 1,
          firstName: 1,
          lastName: 1,
          email: 1,
          backgroundCheckAuthorizationReceivedDate: 1,
          backgroundCheckPassedDate: 1
        }),
        s: JSON.stringify({
          backgroundCheckAuthorizationReceivedDate: 1,
          backgroundCheckPassedDate: 1,
          firstName: 1
        })
      };
      queryOnlyMissingSomething = angular.copy(queryAll);
      queryOnlyMissingSomething.q = JSON.stringify({
        $or: [
          {
            backgroundCheckAuthorizationReceivedDate: null
          }, {
            backgroundCheckPassedDate: null
          }
        ]
      });
      $scope.refreshAll = function() {
        return $scope.signups = Signup.query(queryAll);
      };
      $scope.refreshOnlyMissingSomething = function() {
        return $scope.signups = Signup.query(queryOnlyMissingSomething);
      };
      $scope.refreshOnlyMissingSomething();
      refreshList = function(updatedItem) {
        var index, item, _i, _len, _ref, _results;

        _ref = $scope.signups;
        _results = [];
        for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
          item = _ref[index];
          if (item._id.$oid === updatedItem._id.$oid) {
            _results.push($scope.signups[index] = updatedItem);
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      };
      $scope.isBackgroundCheckAuthorizationReceived = function(signup) {
        return signup.backgroundCheckAuthorizationReceivedDate != null;
      };
      $scope.backgroundCheckAuthorizationReceived = function(signup) {
        return signup.updateSafe({
          backgroundCheckAuthorizationReceivedDate: new Date()
        }, refreshList);
      };
      $scope.backgroundCheckAuthorizationReset = function(signup) {
        return signup.updateSafe({
          backgroundCheckAuthorizationReceivedDate: null
        }, refreshList);
      };
      $scope.isBackgroundCheckPassed = function(signup) {
        return signup.backgroundCheckPassedDate != null;
      };
      $scope.backgroundCheckPassed = function(signup) {
        return signup.updateSafe({
          backgroundCheckPassedDate: new Date()
        }, refreshList);
      };
      return $scope.backgroundCheckReset = function(signup) {
        return signup.updateSafe({
          backgroundCheckPassedDate: null
        }, refreshList);
      };
    }
  ]);

}).call(this);
