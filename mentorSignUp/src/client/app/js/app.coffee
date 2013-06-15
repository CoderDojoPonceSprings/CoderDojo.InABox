checklist = (items) ->
  id = 0
  skills = ((
      name: item
      id: id++
      checked: false
    ) for item in items)
  return skills

selectedItems = (items) ->
  selected = []
  for item in items
    if item.checked then selected.push { name: item.name, id: item.id }
  return selected

app = angular.module("mentorSignUp", ["ui.bootstrap", "mongolab"])

app.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when('/', {templateUrl: 'partials/form.html', controller: 'FormController'})
  $routeProvider.when('/thankyou', {templateUrl: 'partials/thankyou.html', controller: 'ThankyouController'})
  $routeProvider.otherwise({redirectTo: '/'})
]

app.controller "FormController", ["$rootScope", "$scope", "$location", "Signup", "$http", ($rootScope, $scope, $location, Signup, $http) ->
  $scope.form = 
    email: ''
    firstName: ''
    lastName: ''
    company: ''
    title: ''
    zip: ''
    expertise: ''
    otherSkills: ''
    kidExperience: false
    backgroundCheck: false    

  $scope.mentorSkills = checklist [
    'Arduino / Raspberry Pi / Hardware hacking'
    'CSS'
    'HTML5'
    'JavaScript'
    'Node.js'
    'Scratch'
    'Python'
    'Ruby'
    'PHP'
    'Java'
    'C#'
    'Robotics'    
  ]

  $scope.volunteerOffers = checklist [
    'Mentoring kids on technology'
    'Supporting the event as a volunteer'
    'Leading a 4-week exploration on a topic'
    'Donating or reimaging computers'
  ]

  $scope.submit = ->
    $scope.form.mentorSkills = selectedItems $scope.mentorSkills
    $scope.form.volunteerOffers = selectedItems $scope.volunteerOffers
    
    Signup.save $scope.form, (signup) =>
      $rootScope.signup = signup
      $http
        url: '/submit',
        method: 'POST',
        data: $scope.form
      $location.path('/thankyou')
]

app.controller "ThankyouController", ['$rootScope', '$scope', ($rootScope, $scope) ->
  $scope.message = "Thank you #{$rootScope.signup.firstName + ' ' + $rootScope.signup.lastName} for submitting the volunteer signup form. We will contact you soon!"
]