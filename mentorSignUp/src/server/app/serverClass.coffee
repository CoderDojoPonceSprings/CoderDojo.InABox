express = require 'express'
sg = require 'sendgrid-nodejs'
clientConfiguration = require './clientConfiguration'
serverConfiguration = require './serverConfiguration'

createServer = ->
  app = express()

  app.configure ->   
    app.use '/app', express.static('../../client/app')
    app.use express.bodyParser()
    app.use app.router

    port = process.env.PORT || 8081

    app.listen port

  app.get '/clientConfiguration', (req, res) ->    
    res.send clientConfiguration

  app.post '/submit', (req, res) ->
    return unless req.body?
    signup = req.body
    html = signup.html
    delete signup.html
    signup = JSON.stringify signup, null, 4
    header = serverConfiguration.emailToHostHeaderFormat req
    text = header + signup
    htmlToHost = header + html

    from = serverConfiguration.emailFrom

    mail = new sg.Email({
      to: serverConfiguration.emailTo
      from: req.body.email
      subject: serverConfiguration.emailToHostSubjectFormat req
      text: text
      html: htmlToHost
    })

    headerText = serverConfiguration.emailToVolunteerTextFormat req
    headerHtml = serverConfiguration.emailToVolunteerHtmlFormat req
    text = headerText + signup 
    html = headerHtml + html

    # NOTE: you have to modify the files: option manually
    mailForVolunteer = new sg.Email({
      to: req.body.email
      from: from
      subject: serverConfiguration.emailToVolunteerSubject
      text: text
      html: html
      files: 'CoderDojoPonceSprings-BackgroundCheckAuthorization.pdf': __dirname + '/../../client/app/content/CoderDojoPonceSprings-BackgroundCheckAuthorization.pdf'
    })

    sender = new sg.SendGrid 'azure_087394ee528ccb83063ec69cc1b4f2cf@azure.com', 'jpzmaq95'
    
    sender.send mail, (success, err) ->
      if success
        console.log('Email sent')
      else
        console.log(err)

    sender.send mailForVolunteer, (success, err) ->
      if success
        console.log('Email sent to volunteer')
      else
        console.log(err)

    res.send {status: 200, message: 'Success'}

  return app

module.exports = createServer