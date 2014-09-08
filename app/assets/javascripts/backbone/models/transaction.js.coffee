class VenmoGroups.Models.Transaction extends Backbone.Model
  paramRoot: 'transaction'
  urlRoot: '/transactions'

  defaults: {
    'members': new Array()
    'action': 'pay'
    'amount': 0
    'note': ''
    'total': 0
    'num_people': 0
  }

  initialize: (options) ->
    if options.group
      @set('members', options.group.members)
    @calculateNumPeople()
    @on('change:amount', @calculateTotal, this)
    @on('change:members', @calculateTotal, this)
    @on('change:members', @calculateNumPeople, this)

  calculateTotal: ->
    @set('total', @get('amount') * @get('members').length)

  calculateNumPeople: ->
    @set_members_as_array()
    @set('num_people', @get('members').length)

  set_members_as_array: ->
    if typeof @get('members') == 'string'
      @set('members', JSON.parse(@get('members')))

  validation:
    action:
      required: true
    members: (value, attr, computedState) ->
      if value.length == 0
        return 'Add Friends or Groups'
    amount:
      min: 0.01
    note:
      required: true

class VenmoGroups.Collections.TransactionsCollection extends Backbone.Collection
  model: VenmoGroups.Models.Transaction
  url: '/transactions'