# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.User = Backbone.Model.extend
  getId: -> parseInt(@get('id'), 10)
  getName: -> @get('name')

window.Users = Backbone.Collection.extend({})