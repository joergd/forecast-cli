forecast-cli
============

forecast-cli is a node.js module and CLI tool for getting a weather forecast using [forecast.io](http://forecast.io)'s API. It uses Degrees Celsius.



Installation
------------

With [npm](http://github.com/isaacs/npm):

    npm install -g forecast-cli
  
Clone this project:

    git clone http://github.com/joergd/forecast-cli.git


CLI
---

  Usage: forecast [options] placename

  Options:

    --hourly       Hourly report for the next 48 hours
    -h, --help     output usage information
    -V, --version  output the version number

  Examples:

    $ forecast "Cape Town"
    $ forecast --hourly "Cape Town"


How to set a default place name
-------------------------------

You can export an environment variable called FORECAST_PLACE. Place it in your bash profile.

Example:

    export FORECAST_PLACE="Cape Town"