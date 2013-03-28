#!/usr/bin/env node

###
 forecast-cli
 https://github.com/joergd/forecast-cli
 
 Copyright (c) 2013 Joerg Diekmann
 Licensed under the MIT license.
###

program = require('commander')
prompt = require('prompt')
forecast = require('./forecast')

program.version('0.1.0')
  .option('--hourly', 'Hourly report for the next 48 hours')

program.on('--help', () ->
  console.log '  Examples:'
  console.log ''
  console.log '    $ forecast'
  console.log '    $ forecast "Cape Town"'
  console.log '    $ forecast --hourly "Cape Town"'
  console.log ''
  console.log '  You can also export an FORECAST_PLACE environment variable with your place name'
  console.log '  e.g. export FORECAST_PLACE="Cape Town"'
  console.log ''
)

program.parse(process.argv)

if program.args.length is 1
  forecast.get program.args[0], program.hourly
else
  prompt.start()
  prompt.get([{ name: 'place', description: 'Please enter a city name', default: process.env?.FORECAST_PLACE }], (err, result) ->
    if err
      console.log err
    else
      if result.place.length > 0
        forecast.get result.place, program.hourly
      else
        console.log "Ok, whatever." 
  )