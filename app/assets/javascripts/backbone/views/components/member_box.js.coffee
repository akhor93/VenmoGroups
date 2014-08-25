VenmoGroups.Views.Components ||= {}

class VenmoGroups.Views.Components.MemberBoxView extends Backbone.View
  template: JST['backbone/templates/components/memberbox']

  tagName: 'div'

  events: {
    'click .onebox-x': 'destroy'
  }

  destroy: =>
    @undelegateEvents()
    @$el.removeData().unbind()
    @remove
    Backbone.View.prototype.remove.call(this)

  render: =>
    @$el.addClass('member-box')
    @$el.attr('data-userid',@options.user.id)
    @$el.html(@template({
      user: @options.user
    }))
    return this