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
    mail = new sg.Email({
      to: 'josh.gough@versionone.com'
      from: 'josh.gough@versionone.com'
      subject: 'test mail',
      text: JSON.stringify req.body
    })
    sender = new sg.SendGrid 'azure_087394ee528ccb83063ec69cc1b4f2cf@azure.com', 'jpzmaq95'
    sender.send mail, (success, err) ->
      if success
        console.log('Email sent')
      else
        console.log(err)

    res.send {status: 200, message: 'Success'}

  return app

module.exports = createServer