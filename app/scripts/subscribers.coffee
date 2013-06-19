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

$.fn.clearInputs = ->
  a = this.serializeArray()
  $.each a, ->
    this.value = ''
  $(this)

Subscriber = Backbone.Model.extend

  validate: (attrs) ->
    errorMessages = []
    emailRegex = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
    errorMessages.push "name can't be blank" if !attrs.name
    errorMessages.push "email doesn't seem to be a real email" if !attrs.email.match(emailRegex)
    if errorMessages.length > 0 then errorMessages else null


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
      <div class="avatar-name"><%= get('name') %></div>
  '''

  render: ->
    @$el.html @template(@model)
    this

window.subscribers = subscribers = new Subscribers()

$ ->
  window.indexView = indexView = new IndexView collection: subscribers

  subscribers.fetch()

  $('form button[type="submit"]').bind 'click', (evt) ->
    evt.preventDefault()

    attrs = $(this).parent('form').serializeObject()
    subscriber = new Subscriber attrs
    subscriber.on 'invalid', (model, error) -> $('.subscriber-errors').show().html error.join(", ")

    subscribers.create subscriber,
      wait: true
      success: (model, resp) ->
        $(':input', 'form').val('')
        $('.subscriber-errors').show().html "Success!"
      error: (model, resp) ->
        console.log(resp)
        code = JSON.parse(resp.responseText).error
        message = if code is 11000 then "Email has already been submitted." else "There was an unknown error."
        $('.subscriber-errors').show().html message
