request = require "request"
express = require "express"
app = module.exports = express.createServer()

clientId = process.env.MEETUP_CLIENT_ID or "set-env-variable"
clientSecret = process.env.MEETUP_CLIENT_SECRET or "set-env-variable"
redirectUri = process.env.MEETUP_REDIRECT_URI or "set-env-variable"

oauth = "https://secure.meetup.com/oauth2"
authUrl = "#{oauth}/authorize"
accessUrl = "#{oauth}/access"

app.get "/login", (req, res) ->
   returnUri = req.query.redirectUri or "/"
   redirect = encodeURIComponent "#{redirectUri}?redirectUri=#{encodeURIComponent(returnUri)}"
   res.redirect "#{authUrl}?client_id=#{clientId}&response_type=code&redirect_uri=#{redirect}"

app.get "/login_callback", (req, res, next) ->
   code = req.query.code
   error = req.query.error
   returnUri = decodeURIComponent(req.query.redirectUri) or "/"
   redirect = "#{redirectUri}?redirectUri=#{encodeURIComponent(returnUri)}"
   return next error if error

   things =
      method: "POST"
      url: accessUrl
      form:
         client_id: clientId
         client_secret: clientSecret
         grant_type: "authorization_code"
         redirect_uri: redirect
         code: code

   request things, (error, response, data) ->
      if error then return next error
      if response.statusCode >= 400 then return next response

      req.session.authorization = JSON.parse data
      res.redirect returnUri

app.get "/logout", (req, res, next) ->
   req.session.destroy()
   res.redirect req.query.redirectUri or "/"

app.get "/code", (req, res) -> res.send req.session.authorization