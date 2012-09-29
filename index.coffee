require 'coffee-script'
require 'colors'

process.env.NODE_ENV = process.env.NODE_ENV || 'development'

global._ = require 'underscore'
http     = require 'http'
express  = require 'express'
app      = express()

(require './config/config') app
(require './config/routes') app

http.createServer(app).listen app.get('port'), ->
  console.log "City listening on port #{app.get 'port'} in #{process.env.NODE_ENV} mode.".green