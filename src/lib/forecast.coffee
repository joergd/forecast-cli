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
      console.log ''.rpad('-', 80)
      for hour in hourly.data
        time = new moment(hour.time * 1000)
        if time.hour() > 7
          if time.hour() == 8
            console.log ''
            if moment().day() is time.day()
              console.log 'Today'.bold
            else
              console.log time.format('dddd').bold
          console.log "#{time.format('ha').rpad(' ', 4).red} #{(String(parseInt(hour.temperature)) + '°').rpad(' ', 3).bold} #{addColorToSummary(hour.summary.rpad(' ', 40))} "
      console.log ''         
  )

exports.getDaily = (location) ->
  client.get("#{location.lat},#{location.lng}?si", (err, res, body) ->
    if err
      console.log err
    if daily = body?.daily
      console.log ''.rpad('-', 80)
      for day in daily.data
        date = new moment(day.time * 1000)
        maxTime = new moment(day.temperatureMaxTime * 1000)

        console.log "#{date.format('ddd').red} #{(String(parseInt(day.temperatureMax)) + '°').rpad(' ', 3).bold} #{addColorToSummary(day.summary)}"
      console.log ''         
      console.log daily.summary.bold
      console.log ''         
  )
