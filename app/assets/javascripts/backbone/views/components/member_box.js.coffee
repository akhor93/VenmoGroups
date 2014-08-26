VenmoGroups.Views.Components ||= {}

class VenmoGroups.Views.Components.MemberBoxView extends Backbone.View
  template: JST['backbone/templates/components/memberbox']

  tagName: 'div'

  events: {
    'click .onebox-x': 'destroy'
  }

  destroy: =>
    @$el.trigger('remove-memberbox', @options.user.id)

  render: =>
    @$el.addClass('member-box')
    @$el.attr('data-userid',@options.user.id)
    @$el.attr('id', 'memberbox-' + @options.user.id)
    @$el.html(@template({
      user: @options.user
    }))
    return this