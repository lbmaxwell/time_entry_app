# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#no_end_date').change ->
    if($('#no_end_date').is(':checked'))
#      $('#assignment_end_date_1i').attr('hidden', true)
#      $('#assignment_end_date_2i').attr('hidden', true)
#      $('#assignment_end_date_3i').attr('hidden', true)
      $('#assignment_end_date_1i').attr('disabled', true)
      $('#assignment_end_date_2i').attr('disabled', true)
      $('#assignment_end_date_3i').attr('disabled', true)
    else
#      $('#assignment_end_date_1i').attr('hidden', false)
#      $('#assignment_end_date_2i').attr('hidden', false)
#      $('#assignment_end_date_3i').attr('hidden', false)
      $('#assignment_end_date_1i').attr('disabled', false)
      $('#assignment_end_date_2i').attr('disabled', false)
      $('#assignment_end_date_3i').attr('disabled', false)
