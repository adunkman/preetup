$(document).ready () ->
   selector = "body.event-slides .slide"
   slideCount = $(selector).length
   currentIndex = 0

   advanceSlide = () ->
      previous = currentIndex % slideCount
      current = ++currentIndex % slideCount

      $($(selector)[previous]).fadeOut () ->
         $($(selector)[current]).fadeIn();
         window.setTimeout advanceSlide, 10000

   if slideCount > 0
      $(selector).hide();
      advanceSlide()
