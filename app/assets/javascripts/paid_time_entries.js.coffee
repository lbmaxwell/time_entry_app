# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#paid_time_entry_effective_date').datepicker({dateFormat: 'yy-mm-dd' })

  $('#paid_time_entry_team_id').change ->
    team_id = $('#paid_time_entry_team_id :selected').val()
    $.post('/users_for_team_paid_time_entry', {team_id: team_id}, null, "script")
