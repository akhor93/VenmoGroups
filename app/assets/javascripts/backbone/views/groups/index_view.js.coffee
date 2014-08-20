VenmoGroups.Views.Groups ||= {}

class VenmoGroups.Views.Groups.IndexView extends Backbone.View
  template: JST['backbone/templates/groups/index']

  initialize: () ->
    @listenTo( @collection, 'add', @addOne )

  addAll: () =>
    @collection.each(@addOne)

  addOne: (group) =>
    view = new VenmoGroups.Views.Groups.GroupView({
      model: group
      friends: @options.friends
    })
    @$('#groups-accordion').prepend(view.render().el)

  render: =>
    @$el.html(@template())
    @addAll()

    return this