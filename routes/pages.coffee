{each, flatten, pluck, where, map, groupBy, clone} = require 'underscore'



module.exports = (app) ->
  
  SendGrid = require('sendgrid').SendGrid
  mailer = new SendGrid(app.locals.sendgrid.username, app.locals.sendgrid.password)
  
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
  
  buildLocals = (locals) ->
    locals = clone locals
    realTotal = 0
    each locals.items, (amount, id) ->
      amount = parseInt amount or 0
      {price, name} = allItems[id]
      total = price * amount
      locals.items[id] = {amount, total, name, price}
      realTotal += total
        
    locals.total = realTotal
    locals
    
  sendMail = (to, from, html) ->
    params =
      to: to
      from: from
      subject: 'Order de Kokopelli'
      html: html
    mailer.send params, (success, message) -> 
      console.log("Email success: #{success}")
    
  app.post '/events', (req, res) ->
    locals = buildLocals req.body
    app.render 'events/email', locals, (err, html) ->
      sendMail 'tacos@kokopelli.mx', locals.info.email, html
      sendMail locals.info.email, 'tacos@kokopelli.mx', html
      res.redirect "/events"
    
    
        
        
    res.send req.body