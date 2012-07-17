rest = require "restless"
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

   data =
      client_id: clientId
      client_secret: clientSecret
      grant_type: "authorization_code"
      redirect_uri: redirect
      code: code

   rest.post accessUrl, { data: data }, (error, data) ->
      console.log error
      return next error if error
      req.session.authorization = data
      res.redirect returnUri

app.get "/logout", (req, res, next) ->
   req.session.destroy()
   res.redirect req.query.redirectUri or "/"

app.get "/code", (req, res) -> res.send req.session.authorization