class Timer
  seconds: 0
  minutes: 0
  intervalId: 0

  constructor: (minutes, seconds) ->
    @seconds = seconds
    @minutes = minutes

  start: =>
    if @seconds > 0
      @seconds--
      if @seconds is 0
        @minutePast()
    else if @seconds is 0 and @minutes > 0
      @minutes--
      @seconds = 59
    else
      @_stopInterval()
      @minutePast()
      @timesUp()
      return
    
    $(this).trigger('secondPast')

    if @intervalId is 0
      @_startInterval()
    
  stop: ->
    @_stopInterval()
    @minutes = 0
    @seconds = 0
    @secondPast()

  pause: ->
    @_stopInterval()

  continue: ->
    @_startInterval()

  _stopInterval: ->
    window.clearInterval(@intervalId)

  _startInterval: ->
    @intervalId = setInterval(@start, 1000)

  takeABrake: ->
    console.log 'break'

  secondPast: ->
    console.log 'past'
  
  minutePast: ->
    console.log 'past'

  timesUp: ->
    alert("Time's Up")
  
  to_s: ->
    minutes = @minutes
    if @minutes < 10
      minutes = "0#{@minutes}"

    seconds = @seconds
    if @seconds < 10
      seconds = "0#{@seconds}"

    return "#{minutes}:#{seconds}"

window.Timer = Timer
