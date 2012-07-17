rest = require "restless"

middleware = module.exports = (req, res, next) ->
   data = req.session.authorization

   req.services or= {}
   req.services.meetup = 
      get: (uri, options, callback) ->
         if arguments.length is 2
            callback = options
            options = {}

         options.query = {} unless options.query
         options.query.access_token = data.access_token
         options.parser = rest.parsers.json

         url = "https://api.meetup.com#{uri}"
         
         rest.get url, options, callback
   
   next()