###
 API Docs: https://developer.darkskyapp.com/docs/v2
###
geocoder = require('geocoder')
colors = require('colors')
moment = require('moment')
Client = require('request-json').JsonClient
client = new Client('https://api.forecast.io/forecast/f5951365c265a47ef82e6f1bdd33109e/')

if (typeof String::rpad != 'function')
  String::rpad = (padString, length) ->
    str = this
    while str.length < length
      str = str + padString
    return str


addColorToSummary = (summary) ->
  parts = []
  words = summary.split(' ')
  for word in words
    if word.toLowerCase() in ['rain', 'rain,', 'rain.']
      rains = word.split /[\.,]/
      parts.push rains[0].blue
    else
      parts.push word
  return parts.join(' ')


header = ->
  console.log ''.rpad('-', 80)
  console.log ''

signoff = ->
  console.log ''         
  console.log 'Now you are prepared.'.grey
  console.log ''         

hourlyDayHeading = (day) ->
  console.log day.bold
  console.log ''

exports.get = (place, hourly = false) ->
  geocoder.geocode(place, (err, data) ->
    location = data?.results?[0]?.geometry?.location

    if location
      if hourly
        exports.getHourly location
      else
        exports.getDaily location
    else
      console.log "I can't find your location. Please forgive me."
  )

exports.getHourly = (location) ->
  client.get("#{location.lat},#{location.lng}?si", (err, res, body) ->
    if err
      console.log err
    if hourly = body?.hourly
      header()
      hourlyDayHeading 'Today'
      for hour in hourly.data
        time = new moment(hour.time * 1000)
        if time.hour() > 7 and time.hour() <= 22
          if time.hour() == 8
            if moment().day() isnt time.day()
              console.log ''
              console.log ''
              hourlyDayHeading time.format('dddd')
          console.log "#{time.format('ha').rpad(' ', 4).red} #{(String(parseInt(hour.temperature)) + '°').rpad(' ', 3).bold} #{addColorToSummary(hour.summary.rpad(' ', 40))} "
      signoff()
  )

exports.getDaily = (location) ->
  client.get("#{location.lat},#{location.lng}?si", (err, res, body) ->
    if err
      console.log err
    if daily = body?.daily
      header()
      for day in daily.data
        date = new moment(day.time * 1000)
        maxTime = new moment(day.temperatureMaxTime * 1000)
        if moment().dayOfYear() is date.dayOfYear()
          console.log "    #{(String(parseInt(day.temperatureMax)) + '°').rpad(' ', 3).bold} #{addColorToSummary(day.summary)}"        
          console.log ''
        else
          console.log "#{date.format('ddd').red} #{(String(parseInt(day.temperatureMax)) + '°').rpad(' ', 3).bold} #{addColorToSummary(day.summary)}"        

      console.log ''         
      console.log daily.summary.bold
      signoff()
  )
