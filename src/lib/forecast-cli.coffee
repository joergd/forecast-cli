#!/usr/bin/env node

###
 forecast-cli
 https://github.com/joergd/forecast-cli
 
 Copyright (c) 2013 Joerg Diekmann
 Licensed under the MIT license.
###

program = require 'commander'
prompt = require 'prompt'
defaults = require './defaults'
forecast = require './forecast'

program.version(require('../package').version)
  .option('--hourly', 'Hourly report for the next 48 hours')

program.on('--help', () ->
  console.log '  Examples:'
  console.log ''
  console.log '    $ forecast'
  console.log '    $ forecast "Cape Town"'
  console.log '    $ forecast --hourly "Cape Town"'
  console.log ''
)

program.parse(process.argv)

if program.args.length is 1
  defaults.savePlace program.args[0] 
  forecast.get program.args[0], program.hourly
else
  console.log ''
  prompt.start()
  prompt.get([{ name: 'place', description: 'Please enter a city name', default: defaults.place() }], (err, result) ->
    if err
      console.log err
    else
      if result.place.length > 0
        defaults.savePlace result.place
        forecast.get result.place, program.hourly
      else
        console.log "Ok, whatever." 
  )