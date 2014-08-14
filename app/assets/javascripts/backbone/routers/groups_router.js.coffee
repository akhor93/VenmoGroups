class VenmoGroups.Routers.GroupsRouter extends Backbone.Router
  initialize: (options) ->
    @groups = options.groups
    @user = options.user
    @friends = options.friends
    @friends_arr = options.friends_arr

  routes:
    'groups/edit/:id': 'editGroup'
    'groups/new': 'editGroup'
    'groups/.*' : 'index'

  editGroup: (id) ->
    @view = new VenmoGroups.Views.Groups.EditView({
      collection: @groups
      friends_arr: @friends_arr
    })
    $('#main-content').html(@view.render({ id: id }).el)

  index: ->
    @view = new VenmoGroups.Views.Groups.IndexView({
      collection: @groups
      user: @user
      friends: @friends
    })
    $('#main-content').html(@view.render().el)