App.Kokopelli = 
  
  init: ->
    @tacos = $('.tacos > *').map -> $ @
    @currentTaco = 0
    # do @nextTaco
  
  nextTaco: ->
    @tacos[@currentTaco].removeClass 'active'
    @currentTaco += 1
    if @currentTaco >= @tacos.length
      @currentTaco = 0
    @tacos[@currentTaco].addClass 'active'
    setTimeout (=> do @nextTaco), 5000
    
do App.Kokopelli.init