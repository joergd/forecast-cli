#!/usr/bin/env node

/*
 forecast-cli
 https://github.com/joergd/forecast-cli
 
 Copyright (c) 2013 Joerg Diekmann
 Licensed under the MIT license.
*/

var defaults, forecast, program, prompt;

program = require('commander');

prompt = require('prompt');

defaults = require('./defaults');

forecast = require('./forecast');

program.version('0.2.0').option('--hourly', 'Hourly report for the next 48 hours');

program.on('--help', function() {
  console.log('  Examples:');
  console.log('');
  console.log('    $ forecast');
  console.log('    $ forecast "Cape Town"');
  console.log('    $ forecast --hourly "Cape Town"');
  return console.log('');
});

program.parse(process.argv);

if (program.args.length === 1) {
  defaults.savePlace(program.args[0]);
  forecast.get(program.args[0], program.hourly);
} else {
  console.log('');
  prompt.start();
  prompt.get([
    {
      name: 'place',
      description: 'Please enter a city name',
      "default": defaults.place()
    }
  ], function(err, result) {
    if (err) {
      return console.log(err);
    } else {
      if (result.place.length > 0) {
        defaults.savePlace(result.place);
        return forecast.get(result.place, program.hourly);
      } else {
        return console.log("Ok, whatever.");
      }
    }
  });
}
