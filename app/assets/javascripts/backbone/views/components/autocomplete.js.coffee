VenmoGroups.Views.Components ||= {}

class VenmoGroups.Views.Components.AutoCompleteView extends Backbone.View
  template: JST['backbone/templates/components/autocomplete']

  initialize: ->
    @source = JSON.parse(JSON.stringify(@options.source))
    @selected = []

  render: =>
    @$el.html(@template())
    if @model
      @appendExistingMembers()
    @attachAutocomplete()
    return this

  appendExistingMembers: =>
    members = JSON.parse(@model.get('members'))
    for m in members
      @source = @source.filter (user) -> 
        user.id isnt m.toString()
      memberbox = new VenmoGroups.Views.Components.MemberBoxView({
        user: @options.friends[m]
      })
      @$('#venmo-onebox-names').append(memberbox.render().el);

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
          return matcher.test( value.display_name || value.username || value.name)
      );
    $.ui.autocomplete.prototype._resizeMenu = ->
      ul = this.menu.element
      ul.outerWidth(this.element.outerWidth())
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
            that.source, that.extractLast( request.term ) ) )
        focus: (event, ui ) ->
          return false
        select: (event, ui) ->
          # Remove the user once used
          that.removeObjByDisplayName( that.source, ui.item )
          if ui.item.type == 'group'
            members = JSON.parse ui.item.members
            for m in members
              memberbox = new VenmoGroups.Views.Components.MemberBoxView({
                user: that.options.friends[m]
              })
              $('#venmo-onebox-names').append(memberbox.render().el);
          else
            memberbox = new VenmoGroups.Views.Components.MemberBoxView({
              user: ui.item
            })
            $('#venmo-onebox-names').append(memberbox.render().el);
          this.value = ""
          # attach handler
          return false
      })
      .autocomplete( "instance" )._renderItem = ( ul, item ) ->
        elem = $( "<li class='grey-border-bottom font-18'>" )
        if item.type == 'group'
          member_ids = JSON.parse(item.members)
          member_img_text = ''
          for m in member_ids
            member_img_text += "<img src='" + that.options.friends[m].profile_picture_url + "' class='img-circle profile-pic' />"
          elem.append( item.name + " <span class='grey-small-text'>(" + item.num_members_text + ')</span>' )
            .append( '<div style="width: 100%;">' + member_img_text + '</div>' )
        else
          elem.append( "<img src='" + item.profile_picture_url + "' class='img-circle profile-pic margin-right-10' />" + item.display_name )
        return elem.appendTo( ul )