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

app = angular.module('mentorSignUp', ['ui.bootstrap', 'mongolab'])

app.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when('/', {templateUrl: 'partials/form.html', controller: 'FormController'})
  $routeProvider.when('/thankyou', {templateUrl: 'partials/thankyou.html', controller: 'ThankyouController'})
  $routeProvider.otherwise({redirectTo: '/'})
]

app.controller 'FormController', ['$rootScope', '$scope', '$location', 'Signup', '$http', ($rootScope, $scope, $location, Signup, $http) ->
  $scope.form = 
    email: ''
    firstName: ''
    lastName: ''
    company: ''
    title: ''
    zip: ''
    expertise: ''
    other: ''
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

  $scope.form.additionalSkill = ''
  $scope.additionalSkills = []

  $scope.additionalSkillAdd = ->
    console.log $scope.form.additionalSkill
    $scope.additionalSkills.push {name: $scope.form.additionalSkill, checked: true}
  
  $scope.additionalSkillRemove = (index) ->
    $scope.additionalSkills.splice index, 1

  $scope.volunteerOffers = checklist [
    'Mentoring kids on technology'
    'Leading a 4-week exploration on a topic'
    'Donating or reimaging computers'
    'Reaching out to local schools to tell them about CoderDojo Ponce Springs'
    'Supporting events as a volunteer'    
  ]

  $scope.availability = checklist [
    'Sat June 29, 2 - 5 PM'
    'Sat July 14, 2 - 5 PM'
    'Sat July 28, 2 - 5 PM'
    'Sat August 10, 2 - 5 PM'
    'Sat August 24, 2 - 5 PM'
  ]

  $scope.submit = ->
    $scope.form.mentorSkills = selectedItems $scope.mentorSkills
    $scope.form.volunteerOffers = selectedItems $scope.volunteerOffers
    $scope.form.submitDate = new Date()
    delete $scope.form.additionalSkill
    $scope.form.additionalSkills = additionalSkills

    html = document.getElementById('message').innerHTML

    Signup.save $scope.form, (signup) =>
      $rootScope.signup = signup
      signup.html = html
      $http
        url: '/submit',
        method: 'POST',
        data: signup
      $location.path('/thankyou')
]

app.controller 'ThankyouController', ['$rootScope', '$scope', ($rootScope, $scope) ->
  $scope.name = "#{$rootScope.signup.firstName}"
]