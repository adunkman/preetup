$(document).ready () ->
   selector = "body.event-slides .slide"
   slideCount = $(selector).length
   currentIndex = 0

   advanceSlide = () ->
      previous = currentIndex % slideCount
      current = ++currentIndex % slideCount
      next = (current + 1) % slideCount

      loadTweet $(selector)[next]

      $($(selector)[previous]).fadeOut () ->
         $($(selector)[current]).fadeIn();
         window.setTimeout advanceSlide, 10000

   if slideCount > 0
      $(selector).hide()
      loadTweet $(selector)[1]
      advanceSlide()

loadTweet = (slide) ->
   tweetContainer = $(".tweet", slide)

   if tweetContainer.length
      handle = tweetContainer.data("twitter-handle").replace("@", "")
      twitterUrl = "http://api.twitter.com/1/statuses/user_timeline.json?screen_name=#{handle}&count=1&include_rts=1&include_entities=1&callback=?"

      $.getJSON twitterUrl, (tweets) ->
         $(".message", tweetContainer).text(replaceEntities(tweets[0]))

replaceEntities = (tweet) ->
   return "" unless tweet
   if tweet.entities.urls.length
      textParts = []
      index = 0

      for entity in tweet.entities.urls
         textParts.push tweet.text.substring(index, entity.indices[0])
         textParts.push entity.display_url
         index = entity.indices[1]

      textParts.push tweet.text.substring(index)
      return textParts.join("")
   else
      return tweet.text