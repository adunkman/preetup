express = require "express"
port = process.env.PORT || 3000
app = express.createServer()

# Settings
app.set "view engine", "jade"
app.set "view options", layout: false

app.configure "development", () ->
   app.use express.logger "dev"
   app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.configure "production", () ->
   app.use express.errorHandler()

# Middleware
app.use require("connect-assets")()
app.use express.static __dirname + "/../public"

# Controllers
app.use require "./about"

# Listen
app.listen port
console.log "preetup booted, listening on #{port}."