# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  # form
  $('#new-attr-btn').click (event) ->
    last_fields = $('.attr-fields:last-of-type')
    new_fields = last_fields.clone()
    now = Date.now()
    new_fields.find('input').each (index, element) ->
      element.value = ""
      element.id = element.id.replace(/\d+/, now)
      element.name = element.name.replace(/\d+/, now)
      console.info element
    last_fields.after new_fields

