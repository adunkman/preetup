express = require "express"
app = module.exports = express.createServer()

app.get "/", (req, res) -> 
   res.render "about/preetup"

app.get "/events", (req, res, next) ->
   req.services.meetup.get "/2/events.json?member_id=self", (error, data) ->
      return next error if error
      res.render "about/events", data