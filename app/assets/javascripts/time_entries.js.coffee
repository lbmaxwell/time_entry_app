# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#time_entry_task_id').change ->
    task_id = $('#time_entry_task_id :selected').val()
    $.post('/is_number_processed_enabled', {task_id: task_id}, null, "script")
