# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  # form
  new_attr_btn_action = (event) -> 
    last_fields = $(this).closest('.os-obj-fields').find('.attr-fields:last-of-type')
    new_fields = last_fields.clone()
    now = Date.now()
    new_fields.find('input').each (index, element) ->
      element.value = ""
      element.id = element.id.replace(/attrs_attributes_\d+/, "attrs_attributes_" + now)
      element.name = element.name.replace(/attrs_attributes\]\[\d+/, "attrs_attributes][" + now)
    last_fields.after new_fields
  
  $('.new-attr-btn').click new_attr_btn_action
    
  $('.new-obj-btn').click (event) ->
    last_fields = $('.os-obj-fields:last-of-type')
    new_fields = last_fields.clone()
    now = Date.now()
    new_fields.find('input').each (index, element) ->
      element.value = ""
      element.id = element.id.replace(/os_objects_attributes_\d+/, "os_objects_attributes_" + now)
      element.name = element.name.replace(/os_objects_attributes\]\[\d+/, "os_objects_attributes][" + now)
    last_fields.after new_fields
    new_fields.find('.new-attr-btn').click new_attr_btn_action