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

formatTemperature = (temperature) ->
  (String(parseInt(temperature)) + '°').rpad(' ', 3).bold

header = (formattedAddress) ->
  console.log ('--- ' + formattedAddress + ' ').rpad('-', 80)
  console.log ''

signoff = ->
  console.log ''         
  console.log 'Now you are prepared.'.grey
  console.log ''         

hourlyDayHeading = (day) ->
  console.log day.bold
  console.log ''


displayHourly = (hourly) ->
  if hourly
    hourlyDayHeading 'Today'
    for hour in hourly.data
      time = new moment(hour.time * 1000)
      if time.hour() > 7 and time.hour() <= 22
        if time.hour() == 8
          if moment().day() isnt time.day()
            console.log ''
            console.log ''
            hourlyDayHeading time.format('dddd')
        console.log "#{time.format('ha').rpad(' ', 4).red} #{formatTemperature(hour.temperature)} #{addColorToSummary(hour.summary)} "
    signoff()

displayDaily = (daily) ->
  if daily
    for day in daily.data
      date = new moment(day.time * 1000)
      maxTime = new moment(day.temperatureMaxTime * 1000)
      if moment().dayOfYear() is date.dayOfYear()
        console.log "    #{formatTemperature(day.temperatureMax)} #{addColorToSummary(day.summary)}"
        console.log ''
      else
        console.log "#{date.format('ddd').red} #{formatTemperature(day.temperatureMax)} #{addColorToSummary(day.summary)}"

    console.log ''         
    console.log daily.summary.bold
    signoff()

exports.get = (place, hourly = false) ->
  geocoder.geocode(place, (err, data) ->
    address = data?.results?[0]
    if location = address?.geometry?.location
      client.get("#{location.lat},#{location.lng}?units=si&exclude=minutely,alerts", (err, res, body) ->
        if err
          console.log err
        else
          header(address?.formatted_address)
          if hourly
            displayHourly body?.hourly
          else
            displayDaily body?.daily
      )
    else
      console.log "I can't find your location. Please forgive me."
  )