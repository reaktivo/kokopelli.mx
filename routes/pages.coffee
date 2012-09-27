module.exports = (app) ->
  
  app.get '/', (req, res) ->
    res.render 'pages/menu', title: 'Express'
    
  app.get '/menu', (req, res) ->
    res.render 'pages/menu', title: 'Kokopelli'
    
    
  app.get '/location', (req, res) ->
    res.render 'pages/location', title: 'Kokopelli'