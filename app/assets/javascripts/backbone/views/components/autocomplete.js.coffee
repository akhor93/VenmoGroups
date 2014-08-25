VenmoGroups.Views.Components ||= {}

class VenmoGroups.Views.Components.AutoCompleteView extends Backbone.View
  template: JST['backbone/templates/components/autocomplete']

  initialize: ->
    @friends_arr_original = JSON.parse(JSON.stringify(@options.friends_arr))

  render: =>
    @$el.html(@template({
      user: @options.user.toJSON()
    }))
    @attachAutocomplete()
    return this

  split: ( val ) ->
    return val.split( /,\s*/ )
  extractLast: ( term ) ->
    return @split( term ).pop()
  removeObjByDisplayName: ( arr, obj ) ->
    for i in [0..arr.length] by 1
      if arr[i].display_name == obj.display_name
        arr.splice(i,1)
        return false

  attachAutocomplete: ->
    that = this
    # Overrides default filter to look at display name
    $.ui.autocomplete.filter = (array, term) ->
      matcher = new RegExp( $.ui.autocomplete.escapeRegex( term ), "i" )
      return $.grep(array
        (value) ->
          return matcher.test( value.display_name || value.username)
      );
    @$( "#members-input" )
      # don't navigate away from the field on tab when selecting an item
      .bind( "keydown"
        (event) ->
          if event.keyCode == $.ui.keyCode.TAB &&
              $( this ).autocomplete( "instance" ).menu.active
            event.preventDefault()
      )
      .autocomplete({
        minLength: 1
        source: (request, response ) ->
          # delegate back to autocomplete, but extract the last term
          response( $.ui.autocomplete.filter(
            that.options.friends_arr, that.extractLast( request.term ) ) )
        focus: (event, ui ) ->
          return false
        select: (event, ui) ->
          # Remove the user once used
          that.removeObjByDisplayName( that.options.friends_arr, ui.item )
          memberbox = new VenmoGroups.Views.Components.MemberBoxView({
            user: ui.item
          })
          $('#venmo-onebox-names').append(memberbox.render().el);
          this.value = ""
          # attach handler
          return false
      })
      .autocomplete( "instance" )._renderItem = ( ul, item ) ->
        return $( "<li>" )
          .append( "<a>" + item.display_name + "<br>" + item.first_name + "</a>" )
          .appendTo( ul )