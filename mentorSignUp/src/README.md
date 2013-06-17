# How To Build a Cool Email Form with AngularJS, Node.js, Windows Azure, and SendGrid

AngularJS is a hot, open source JavaScript MVC framework for creating web apps from simple to highly sophisticated.
This article shows how to build a simple, yet powerful, email contact form that has some cool bells and whistles.
In it, you'll learn about some of the core capabilities that make AngularJS so powerful and easy to use, like 
repeaters, two-way databinding, directives, services, dependency-injection, and RESTful communication. It also 
uses Node.js on Windows Azure in conjunction with the SendGrid mail service to easily send emails and attach
files.

# Example form: sign up to help kids learn how to code

The company I work for, VersionOne, is sponsoring a new CoderDojo in Atlanta. TODO: complete

# HTML to capture user's email

```html
<div class="control-group">
  <label class="control-label required" for="email">Email</label>
  <div class="controls">
    <input ng-model="form.email" class="input-xlarge" required type="text">
    <p class="help-block">user@example.com</p>
  </div>
</div>
```
Notice that the `input` tag does not have an `id` attribute, but does have an `ng-model` attribute set to 
`form.email`.





