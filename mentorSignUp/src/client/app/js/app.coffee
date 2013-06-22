checklist = (items) ->
  id = 0
  skills = []
  for item in items
    skills.push {
      name: item
      id: id++
      checked: false
    }
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
  $routeProvider.when('/signups', {templateUrl: 'partials/signups.html', controller: 'SignupsController'})
  $routeProvider.otherwise({redirectTo: '/'})
]

app.controller 'FormController', ['$rootScope', '$scope', '$location', 'Signup', '$http',
($rootScope, $scope, $location, Signup, $http) ->
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
    tshirtSize: 'Medium'
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

  $scope.additionalSkill = ''
  $scope.additionalSkills = []

  $scope.additionalSkillAdd = ->
    return if $scope.additionalSkill is ''
    $scope.additionalSkills.push {name: $scope.additionalSkill, checked: true}
    $scope.additionalSkill = ''
  
  $scope.additionalSkillRemove = (index) ->
    $scope.additionalSkills.splice index, 1

  $scope.additionalSkillAddDisabled = ->
    return $scope.additionalSkill is ''

  $scope.volunteerOffers = checklist [
    'Mentoring kids on technology'
    'Leading a 4-week exploration on a topic'
    'Donating or reimaging computers'
    'Reaching out to local schools to tell them about CoderDojo Ponce Springs'
    'Supporting events as a volunteer'    
  ]

  $scope.availability = checklist [
    'Sat June 29, 2 - 5 PM'
    'Sat July 13, 2 - 5 PM'
    'Sat July 27, 2 - 5 PM'
    'Sat August 10, 2 - 5 PM'
    'Sat August 24, 2 - 5 PM'
  ]

  $scope.tshirtSizes = [
    'Small'
    'Medium'
    'Large'
    'X-Large'
    'XX-Large'
  ]

  $scope.tshirtSizeSelect = (tshirtSize) ->
    $scope.form.tshirtSize = tshirtSize

  $scope.submit = ->
    $scope.form.mentorSkills = selectedItems $scope.mentorSkills
    $scope.form.volunteerOffers = selectedItems $scope.volunteerOffers
    $scope.form.submitDate = new Date()
    $scope.form.additionalSkills = $scope.additionalSkills

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

app.controller 'SignupsController',  ['$rootScope', '$scope', 'Signup', ($rootScope, $scope, Signup) ->
  queryAll = 
    f: JSON.stringify {
      id:1
      firstName:1
      lastName:1
      email:1
      backgroundCheckAuthorizationReceivedDate:1
      backgroundCheckPassedDate:1
    }
    s: JSON.stringify {
      backgroundCheckAuthorizationReceivedDate:1
      backgroundCheckPassedDate:1
      firstName:1
    }
  
  queryOnlyMissingSomething = angular.copy queryAll
  queryOnlyMissingSomething.q = JSON.stringify $or: [ 
    { backgroundCheckAuthorizationReceivedDate: null }, { backgroundCheckPassedDate: null } 
  ]

  $scope.refreshAll = ->
    $scope.signups = Signup.query queryAll

  $scope.refreshOnlyMissingSomething = ->
    $scope.signups = Signup.query queryOnlyMissingSomething

  $scope.refreshOnlyMissingSomething()

  refreshList = (updatedItem) ->
    for item, index in $scope.signups        
      if item._id.$oid is updatedItem._id.$oid
        $scope.signups[index] = updatedItem    

  $scope.isBackgroundCheckAuthorizationReceived = (signup) -> signup.backgroundCheckAuthorizationReceivedDate?
  
  $scope.backgroundCheckAuthorizationReceived = (signup) -> 
    signup.updateSafe backgroundCheckAuthorizationReceivedDate: new Date(), refreshList
  
  $scope.backgroundCheckAuthorizationReset = (signup) ->
    signup.updateSafe backgroundCheckAuthorizationReceivedDate: null, refreshList

  $scope.isBackgroundCheckPassed = (signup) -> signup.backgroundCheckPassedDate?
  
  $scope.backgroundCheckPassed = (signup) -> signup.updateSafe backgroundCheckPassedDate: new Date(), refreshList
  
  $scope.backgroundCheckReset = (signup) -> signup.updateSafe backgroundCheckPassedDate: null, refreshList
]