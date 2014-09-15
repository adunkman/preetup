module.exports = (req, res, next) ->
   res.local "authenticated", req.session.authorization?.access_token?
   next()
