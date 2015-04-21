#!/usr/bin/env node

###
 forecast-cli
 https://github.com/joergd/forecast-cli

 Copyright (c) 2013-2015 Joerg Diekmann
 Licensed under the MIT license.
###

program = require 'commander'
prompt = require 'prompt'
defaults = require './defaults'
forecast = require './forecast'

program.version(require('../package').version)
  .option('--hourly', 'Hourly report for the next 48 hours')
  .option('--units', 'Configure the units used in the forecast')

program.on('--help', () ->
  console.log '  Examples:'
  console.log ''
  console.log '    $ forecast'
  console.log '    $ forecast "Cape Town"'
  console.log '    $ forecast --hourly "Cape Town"'
  console.log '    $ forecast --units'
  console.log ''
)

program.parse(process.argv)

if program.units

  console.log "Choose the units you'd like to see in your forecasts:"
  units = ["Fahrenheit (°F)", "Celsius (°C)"]
  unitsValues = ["us", "si"]
  program.choose units, (i) ->
    defaults.saveUnits unitsValues[i]
    console.log "Thanks - units have been configured to #{units[i]}."
    process.exit()

else

  if program.args.length is 1
    defaults.savePlace program.args[0]
    forecast.get program.args[0], program.hourly
  else
    console.log ''
    defaultPlace =  defaults.place()
    if defaultPlace != ''
      forecast.get defaultPlace, program.hourly
    else
      prompt.start()
      prompt.get([{ name: 'place', description: 'Please enter a city name', default: defaultPlace }], (err, result) ->
        if err
          console.log err
        else
          if result.place.length > 0
            defaults.savePlace result.place
            forecast.get result.place, program.hourly
          else
            console.log "Ok, whatever."
      )
