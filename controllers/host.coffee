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
app.use express.cookieParser()
app.use express.session secret: "b4f78e7b-eb09-413f-9388-988fef16c29c"
app.use require "../middleware/authentication"

# Services
app.use require "../services/meetup"

# Controllers
app.use require "./about"
app.use require "./authentication"
app.use require "./event"

# Listen
app.listen port
console.log "preetup booted, listening on #{port}."