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
    'transactions/new/:action/:id': 'transactionNew'
    'transactions/new/.*': 'transactionNew'
    '.*': 'index'

  groupEdit: (id) ->
    @renderSideView()
    @group = @groups.get(id)
    @view = new VenmoGroups.Views.Groups.EditView({
      model: @group
      collection: @groups
      friends: @friends
      friends_arr: @friends_arr
    })
    $('#main-content').html(@view.render().el)
    @onebox = new VenmoGroups.Views.Components.AutoCompleteView({
      user: @user
      source: @friends_arr
      model: @group
      friends: @friends
    });
    $('#members-input').html(@onebox.render().el)

  groupNew: ->
    @renderSideView()
    @view = new VenmoGroups.Views.Groups.NewView({
      collection: @groups
    })
    $('#main-content').html(@view.render().el)
    @onebox = new VenmoGroups.Views.Components.AutoCompleteView({
      user: @user
      source: @friends_arr
    });
    $('#members-input').html(@onebox.render().el)

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
    group = if id then @groups.get(id) else null
    @view = new VenmoGroups.Views.Transactions.NewView({
      collection: @transactions
      group: group
      action: action
    })
    $('#main-content').html(@view.render().el)
    @onebox = new VenmoGroups.Views.Components.AutoCompleteView({
      user: @user
      source: @groups.toJSON().concat(@friends_arr)
      friends: @friends
    });
    $('#targets-input').html(@onebox.render().el)

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