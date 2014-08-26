VenmoGroups.Views.Groups ||= {}

class VenmoGroups.Views.Groups.GroupView extends Backbone.View
  template: JST['backbone/templates/groups/group']

  tagName: 'div'
  
  render: ->
    @$el.addClass('group-container')
    @$el.html(@template({
      group: @model.toJSON()
      friends: @options.friends
    }))
    return this
