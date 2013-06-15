express = require 'express'
sg = require 'sendgrid-nodejs'

createServer = ->
  app = express()

  app.configure ->   
    app.use '/app', express.static('../../client/app')
    app.use express.bodyParser()
    app.use app.router

    port = process.env.PORT || 8081

    app.listen port

  app.post '/submit', (req, res) ->
    return unless req.body?
    signup = req.body
    html = signup.html
    delete signup.html
    signup = JSON.stringify signup, null, 4
    header = "#{req.body.firstName} #{req.body.lastName} <#{req.body.email}> just signed up to volunteer with CoderDojo Ponce Springs!\n\n"
    text = header + signup
    html = header + html

    from = 'josh.gough@versionone.com'

    mail = new sg.Email({
      to: 'josh.gough@versionone.com'
      from: from
      subject: 'test mail'
      text: text
      html: html
    })

    header = "Thank you #{req.body.firstName} #{req.body.lastName} for volunteering with CoderDojo Ponce Springs! Please remember to fill out the attached background check authorization form and return it to us (instructions within document) so you can get started!\n\nHere is a copy of the information you submitted to us:\n\n"
    text = header + signup 
    html = header + html

    mailForVolunteer = new sg.Email({
      to: req.body.email
      from: from
      subject: 'Confirmation of CoderDojo Ponce Springs sign up received'
      text: text
      html: html
      #files:
      #  'CoderDojoPonceSprings-BackgroundCheckAuthorization.pdf': __dirname + '../../client/app/content/CoderDojoPonceSprings-BackgroundCheckAuthorization.pdf'
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