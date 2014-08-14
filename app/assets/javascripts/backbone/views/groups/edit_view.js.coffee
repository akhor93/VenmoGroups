VenmoGroups.Views.Groups ||= {}

class VenmoGroups.Views.Groups.EditView extends Backbone.View
  template: JST['backbone/templates/groups/edit']

  initialize: ->
    @model = new @collection.model()
    @friends_arr_original = JSON.parse(JSON.stringify(@options.friends_arr))

  events:
    'submit #edit-group': 'save'

  save: (e) ->
    that = this
    e.preventDefault()
    e.stopPropagation()

    groupDetails = $(e.currentTarget).serializeObject();
    groupDetails.members = @memberNamesToId(groupDetails.members);
    @model.save(groupDetails, {
      success: (group) ->
        if !groupDetails.id
          that.collection.add(group)
        window.location.hash = "#/groups/"
    });

  memberNamesToId: (member_string) ->
    members_as_venmoid = []
    names = member_string.split(', ')
    for n in names
      for f in @friends_arr_original
        if f.display_name == n
          members_as_venmoid.push(f.id)
          break
    return JSON.stringify(members_as_venmoid)

  render: (options) ->
    that = this;
    if options.id
      that.group = new Group({id: options.id})
      that.group.fetch({
        success: (group)->
          @$el.html(@template(group.toJSON() ))
          @$("form").backboneLink(@model)
          @attachAutocomplete()
          return that
      })
    else
      @$el.html(@template(group: null))
      that.$("form").backboneLink(@model)
      @attachAutocomplete()
      return that

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

          terms = that.split( this.value )
          # remove the current input
          terms.pop()
          # add the selected item
          terms.push( ui.item.display_name )
          # add placeholder to get the comma-and-space at the end
          terms.push( "" )
          this.value = terms.join( ", " )
          return false
      })
      .autocomplete( "instance" )._renderItem = ( ul, item ) ->
        return $( "<li>" )
          .append( "<a>" + item.display_name + "<br>" + item.first_name + "</a>" )
          .appendTo( ul )