{each, flatten, pluck, where, map, groupBy, clone} = require 'underscore'

to_email = 'tacos@kokopelli.mx'
if process.env.NODE_ENV isnt 'production'
  to_email = 'm@reaktivo.com'

module.exports = (app) ->

  SendGrid = require('sendgrid').SendGrid
  mailer = new SendGrid(process.env.SENDGRID_USERNAME, process.env.SENDGRID_PASSWORD)

  _items = flatten pluck(app.locals.events.categories, 'items'), true
  allItems = {}
  each _items, (item) ->
    allItems[item.id] = item

  item = (id) -> where(allItems, {id}).shift()

  app.get '/', (req, res) ->
    res.render 'pages/menu', title: 'Kokopelli'

  app.get '/menu', (req, res) ->
    res.render 'pages/menu', title: 'Kokopelli'

  app.get '/location', (req, res) ->
    res.render 'pages/location', title: 'Kokopelli'

  app.get '/events', (req, res) ->
    res.render 'pages/events', title: 'Kokopelli'

  app.get '/events/success', (req, res) ->
    res.render 'pages/events_success', title: 'Kokopelli'

  buildLocals = (locals) ->
    locals = clone locals
    realTotal = 0
    each locals.items, (amount, id) ->
      amount = parseInt amount or 0
      {name} = allItems[id]
      locals.items[id] = {amount, name}
    locals

  sendMail = (to, from, html) ->
    params = { to, from, html, subject: "Orden de Kokopelli" }
    mailer.send params, (success, message) ->
      console.log("Email success: #{success}")

  app.post '/events', (req, res) ->
    locals = buildLocals req.body
    app.render 'events/email', locals, (err, html) ->
      if process.env.NODE_ENV isnt 'production'
        console.log(locals)
        console.log(html)
      sendMail to_email, locals.info.email, html
      sendMail locals.info.email, to_email, html
      res.render "pages/events_success", title: 'Kokopelli'




    res.send req.body