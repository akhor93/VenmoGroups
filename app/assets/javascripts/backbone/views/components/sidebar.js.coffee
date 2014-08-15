VenmoGroups.Views.Components ||= {}

class VenmoGroups.Views.Components.SideBarView extends Backbone.View
  template: JST['backbone/templates/components/sidebar']

  render: =>
    @$el.html(@template({
      user: @options.user.toJSON()
    }))

    return this