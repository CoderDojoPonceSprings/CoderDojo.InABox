express = require 'express'

createServer = ->
  app = express()

  app.configure ->   
    app.use '/app', express.static('../../client/app')
    app.use app.router

    port = process.env.PORT || 8081

    app.listen port

  return app

module.exports = createServer