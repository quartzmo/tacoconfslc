$.fn.serializeObject = ->
  o = {}
  a = this.serializeArray()
  $.each a, ->
    if (o[this.name])
      if (!o[this.name].push)
        o[this.name] = [o[this.name]]
      o[this.name].push(this.value || '')
    else
      o[this.name] = this.value || ''
  o

Subscriber = Backbone.Model.extend

  validate: (attrs) ->
    return "'name' and 'email' cannot both be blank" unless attrs.name.length > 1 or attrs.email.length > 1

window.Subscribers = Subscribers = Backbone.Collection.extend
  model: Subscriber
  url: "http://#{window.config.api_host}/subscribers"

IndexView = Backbone.View.extend
  el: '.avatars'

  initialize: ->
    @listenTo @collection, 'add', @addSubscriber

  addSubscriber: (model) ->
    view = new ShowView model: model
    @$el.append view.render().el
    true

ShowView = Backbone.View.extend

  className: "avatar"

  template: _.template '''
      <img title="<%= get('name') %>" alt="<%= get('name') %>" src="http://2.gravatar.com/avatar/<%= get('email_hash') %>">
  '''

  render: ->
    @$el.html @template(@model)
    this

window.subscribers = subscribers = new Subscribers()


subscribers.on 'all', (event, model, collection, options) ->
  console.log "Model '#{model.cid}' triggered '#{event}'. Collection length is #{collection.length}."






$ ->
  window.indexView = indexView = new IndexView collection: subscribers

  subscribers.fetch()

  $('form button[type="submit"]').bind 'click', (evt) ->
    evt.preventDefault()

    attrs = $(this).parent('form').serializeObject()
    subscribers.create attrs, wait: true
