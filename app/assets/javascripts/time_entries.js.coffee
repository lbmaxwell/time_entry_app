# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#time_entry_task_id').change ->
    task_id = $('#time_entry_task_id :selected').val()
    $.post('/is_task_direct', {task_id: task_id}, null, "script")

  $(document).ready(
    totalTime = document.getElementById("time_entry_seconds").value
    totalTimeMinutes = parseInt(totalTime / 60)
    totalTimeSeconds = (totalTime % 60)

    document.getElementById("minutes").value = totalTimeMinutes
    document.getElementById("time_entry_seconds").value = totalTimeSeconds
  )
