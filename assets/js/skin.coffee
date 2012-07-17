$(document).ready () ->
   selector = "body.slides .rsvp"
   slideCount = $(selector).length
   currentIndex = 0

   advanceSlide = () ->
      $(selector).hide();
      $($(selector)[currentIndex++]).show();
      window.setTimeout advanceSlide, 10000

   advanceSlide()
