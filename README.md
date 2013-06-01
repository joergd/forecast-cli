forecast-cli
============

forecast-cli is a CLI tool for getting a beautifully formatted weather forecast in your terminal, using [forecast.io]( http://forecast.io)'s API. You can configure it to use either degrees Celsius or Fahrenheit.



Installation
------------

With [npm](http://github.com/isaacs/npm):

    npm install -g forecast-cli

Clone this project:

    git clone http://github.com/joergd/forecast-cli.git


CLI
---

  Usage: forecast [options] [placename]

  Options:

    --hourly       Hourly report for the next 48 hours
    --units        Configure to use Fahrenheit or Celcius (default)
    -h, --help     output usage information
    -V, --version  output the version number

  Examples:

    $ forecast
    $ forecast "Cape Town"
    $ forecast --hourly "Cape Town"
    $ forecast --units


Default place name
------------------

Your last placename will be stored in

    ~/.forecast-cli.json


Default units
-------------

The default units are Celcius, and they too are stored in

    ~/.forecast-cli.json

The available options are

    us: Fahrenheit (°F)
    si: Celcius (°C)


~/.forecast-cli.json
--------------------

This file holds your settings. Example:

    {
      "place": "Cape Town",
      "units": "si"
    }


White screenshot
----------------

![White Screenshot](https://raw.github.com/joergd/forecast-cli/master/screenshot-white.png)


Black screenshot
----------------

![Black Screenshot](https://raw.github.com/joergd/forecast-cli/master/screenshot-black.png)


----------------

Now you're prepared.
