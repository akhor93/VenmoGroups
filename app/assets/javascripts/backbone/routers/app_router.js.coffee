class VenmoGroups.Routers.AppRouter extends Backbone.Router
  initialize: (options) ->
    @groups = options.groups
    @user = options.user
    @friends = options.friends
    @friends_arr = options.friends_arr
    @transactions = options.transactions

  routes:
    'groups/edit/:id': 'groupEdit'
    'groups/new': 'groupNew'
    'groups/:action/:id': 'transactionNew'
    'groups/.*' : 'groupIndex'
    '.*': 'index'

  groupEdit: (id) ->
    @renderSideView()
    @view = new VenmoGroups.Views.Groups.EditView({
      collection: @groups
      friends: @friends
      friends_arr: @friends_arr
      id: id
    })
    $('#main-content').html(@view.render().el)

  groupNew: ->
    @renderSideView()
    @view = new VenmoGroups.Views.Groups.NewView({
      collection: @groups
      friends_arr: @friends_arr
    })
    $('#main-content').html(@view.render().el)

  groupIndex: ->
    @renderSideView()
    @view = new VenmoGroups.Views.Groups.IndexView({
      collection: @groups
      user: @user
      friends: @friends
    })
    $('#main-content').html(@view.render().el)

  transactionNew: (action, id) ->
    @renderSideView()
    @view = new VenmoGroups.Views.Transactions.NewView({
      collection: @transactions
      group: @groups.get(id)
      friends: @friends
      action: action
    })
    $('#main-content').html(@view.render().el)

  index: ->
    @renderSideView()
    @mainview = new VenmoGroups.Views.Transactions.IndexView({
      collection: @transactions
      groups: @groups
      user: @user
      friends: @friends
    })
    
    $('#main-content').html(@mainview.render().el)
    

  renderSideView: ->
    @sidebar = new VenmoGroups.Views.Components.SideBarView({
      user: @user
    })
    $('#sidebar').html(@sidebar.render().el)