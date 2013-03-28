/*
 API Docs: https://developer.darkskyapp.com/docs/v2
*/

var Client, addColorToSummary, client, colors, geocoder, moment;

geocoder = require('geocoder');

colors = require('colors');

moment = require('moment');

Client = require('request-json').JsonClient;

client = new Client('https://api.forecast.io/forecast/f5951365c265a47ef82e6f1bdd33109e/');

if (typeof String.prototype.rpad !== 'function') {
  String.prototype.rpad = function(padString, length) {
    var str;

    str = this;
    while (str.length < length) {
      str = str + padString;
    }
    return str;
  };
}

addColorToSummary = function(summary) {
  var parts, rains, word, words, _i, _len, _ref;

  parts = [];
  words = summary.split(' ');
  for (_i = 0, _len = words.length; _i < _len; _i++) {
    word = words[_i];
    if ((_ref = word.toLowerCase()) === 'rain' || _ref === 'rain,' || _ref === 'rain.') {
      rains = word.split(/[\.,]/);
      parts.push(rains[0].blue);
    } else {
      parts.push(word);
    }
  }
  return parts.join(' ');
};

exports.get = function(place, hourly) {
  if (hourly == null) {
    hourly = false;
  }
  return geocoder.geocode(place, function(err, data) {
    var location, _ref, _ref1, _ref2;

    location = data != null ? (_ref = data.results) != null ? (_ref1 = _ref[0]) != null ? (_ref2 = _ref1.geometry) != null ? _ref2.location : void 0 : void 0 : void 0 : void 0;
    if (location) {
      if (hourly) {
        return exports.getHourly(location);
      } else {
        return exports.getDaily(location);
      }
    } else {
      return console.log("I can't find your location. Please forgive me.");
    }
  });
};

exports.getHourly = function(location) {
  return client.get("" + location.lat + "," + location.lng + "?si", function(err, res, body) {
    var hour, hourly, time, _i, _len, _ref;

    if (err) {
      console.log(err);
    }
    if (hourly = body != null ? body.hourly : void 0) {
      console.log(''.rpad('-', 80));
      console.log('Today'.bold);
      _ref = hourly.data;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        hour = _ref[_i];
        time = new moment(hour.time * 1000);
        if (time.hour() > 7) {
          if (time.hour() === 8) {
            console.log('');
            console.log(time.format('dddd').bold);
          }
          console.log("" + (time.format('ha').rpad(' ', 4).red) + " " + ((String(parseInt(hour.temperature)) + '°').rpad(' ', 3).bold) + " " + (addColorToSummary(hour.summary.rpad(' ', 40))) + " ");
        }
      }
      return console.log('');
    }
  });
};

exports.getDaily = function(location) {
  return client.get("" + location.lat + "," + location.lng + "?si", function(err, res, body) {
    var daily, date, day, maxTime, _i, _len, _ref;

    if (err) {
      console.log(err);
    }
    if (daily = body != null ? body.daily : void 0) {
      console.log(''.rpad('-', 80));
      _ref = daily.data;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        day = _ref[_i];
        date = new moment(day.time * 1000);
        maxTime = new moment(day.temperatureMaxTime * 1000);
        console.log("" + (date.format('ddd').red) + " " + ((String(parseInt(day.temperatureMax)) + '°').rpad(' ', 3).bold) + " " + (addColorToSummary(day.summary)));
      }
      console.log('');
      console.log(daily.summary.bold);
      return console.log('');
    }
  });
};
