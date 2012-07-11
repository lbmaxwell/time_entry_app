# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#start_date').datepicker({dateFormat: 'yy-mm-dd' })

  $('#end_date').datepicker({dateFormat: 'yy-mm-dd' })

  $('#team').change ->
    team_id = $('#team :selected').val()
    $.post('/users_for_team', {team_id: team_id}, null, "script")
