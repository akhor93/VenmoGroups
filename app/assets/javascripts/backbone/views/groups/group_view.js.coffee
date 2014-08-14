VenmoGroups.Views.Groups ||= {}

class VenmoGroups.Views.Groups.GroupView extends Backbone.View
  template: JST['backbone/templates/groups/group']

  events:
    'click .pay' : 'pay'

  tagName: 'tr'

  pay: () ->
    console.log("PAY BUTTON CLICKED")
    return false

  render: ->
    # console.log({group: @model.toJSON()});
    group = @model.toJSON()
    num_members = (JSON.parse(group.members)).length
    num_members_text = num_members + " member"
    if num_members != 1
      num_members_text += 's'
    @$el.html(@template({
      group: group
      friends: @options.friends
      num_members_text: num_members_text
    }))
    return this