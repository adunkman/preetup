async = require "async"
express = require "express"
app = module.exports = express.createServer()

app.get "/events", (req, res, next) ->
   if res.locals().authenticated
      req.services.meetup.get "/2/events.json?member_id=self", (error, data) ->
         return next error if error
         res.render "event/list", data
   else
      res.redirect "/login?redirectUri=/events"

app.get "/:orgname/events/:id", (req, res, next) ->
   if res.locals().authenticated
      async.parallel {
         rsvps: (done) ->
            req.services.meetup.get "/2/rsvps.json?event_id=#{req.params.id}&page=1000&rsvp=yes&fields=other_services", done
         event: (done) ->
            req.services.meetup.get "/2/event/#{req.params.id}.json?fields=survey_questions", done
         profiles: (done) ->
            req.services.meetup.get "/2/profiles?group_urlname=#{req.params.orgname}&page=1000", done
      }, (error, data) ->
         return next error if error
         data.rsvps = data.rsvps[0].results
         data.event = data.event[0]

         profiles = {}
         for profile in data.profiles[0].results
            profiles[profile.member_id] = profile
         data.profiles = profiles

         res.render "event/slides", data
   else
      res.redirect "/login?redirectUri=/#{req.params.orgname}/events/#{req.params.id}"