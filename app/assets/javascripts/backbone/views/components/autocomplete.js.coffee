VenmoGroups.Views.Components ||= {}

class VenmoGroups.Views.Components.AutoCompleteView extends Backbone.View
  template: JST['backbone/templates/components/autocomplete']

  events: {
    'remove-memberbox': 'removeMemberbox'
  }

  initialize: ->
    @source = JSON.parse(JSON.stringify(@options.source))

  removeMemberbox: (ev, id) ->
    @source.push(@options.friends[id])
    new_members = @model.get('members').filter (i) ->
      id isnt i
    @model.set('members', new_members)
    $('#memberbox-' + id).remove()

  render: =>
    @$el.html(@template())
    if @options.group
      @appendExistingMembers()
    @attachAutocomplete()
    return this

  appendExistingMembers: =>
    members = @options.group.get('members')
    if @model
      @model.set('members', _.clone members )
    for m in members
      @renderMemberBoxes(@options.friends[m])

  split: ( val ) ->
    return val.split( /,\s*/ )
  extractLast: ( term ) ->
    return @split( term ).pop()

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
          model_members = _.clone that.model.get 'members' 
          if ui.item.type == 'group'
            for m in ui.item.members
              that.renderMemberBoxes(that.options.friends[m])
              model_members.push(m)
          else
            that.renderMemberBoxes(ui.item)
            model_members.push(ui.item.id)
          that.model.set('members', model_members)
          that.$el.trigger('add-memberbox')
          this.value = ""
          return false
      })
      .autocomplete( "instance" )._renderItem = ( ul, item ) ->
        elem = $( "<li class='grey-border-bottom font-18'>" )
        if item.type == 'group'
          member_img_text = ''
          for m in item.members
            member_img_text += "<img src='" + that.options.friends[m].profile_picture_url + "' class='img-circle profile-pic' />"
          elem.append( item.name + " <span class='grey-small-text'>(" + item.num_members_text + ')</span>' )
            .append( '<div style="width: 100%;">' + member_img_text + '</div>' )
        else
          elem.append( "<img src='" + item.profile_picture_url + "' class='img-circle profile-pic margin-right-10' />" + item.display_name )
        return elem.appendTo( ul )

  renderMemberBoxes: (user) ->
    memberbox = new VenmoGroups.Views.Components.MemberBoxView({
      user: user
    })
    @$('#venmo-onebox-names').append(memberbox.render().el);
    @source = @source.filter (friends) ->
      friends.id isnt user.id
