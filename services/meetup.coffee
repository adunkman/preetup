request = require "request"

middleware = module.exports = (req, res, next) ->
   data = req.session.authorization

   req.services or= {}
   req.services.meetup =
      get: (uri, options, callback) ->
         if arguments.length is 2
            callback = options
            options = {}

         options.qs = {} unless options.qs
         options.qs.access_token = data.access_token
         options.url = "https://api.meetup.com#{uri}"

         request options, (error, response, data) ->
            if error then callback error
            else if response.statusCode >= 400 then callback response
            else callback null, JSON.parse data

   next()
