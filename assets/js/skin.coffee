$(document).ready () ->
   selector = "body.event-slides .slide"
   slideCount = $(selector).length
   currentIndex = 0

   advanceSlide = () ->
      $($(selector)[currentIndex]).fadeOut () ->
         $($(selector)[++currentIndex]).fadeIn();

         if currentIndex is slideCount - 1 then currentIndex = 0
         window.setTimeout advanceSlide, 10000

   if slideCount > 0
      $(selector).hide();
      advanceSlide()
