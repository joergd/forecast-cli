/*
 API Docs: https://developer.darkskyapp.com/docs/v2
*/

var Client, addColorToSummary, client, colors, displayDaily, displayHourly, formatTemperature, geocoder, header, hourlyDayHeading, moment, signoff;

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

formatTemperature = function(temperature) {
  return (String(parseInt(temperature)) + '°').rpad(' ', 3).bold;
};

header = function() {
  console.log(''.rpad('-', 80));
  return console.log('');
};

signoff = function() {
  console.log('');
  console.log('Now you are prepared.'.grey);
  return console.log('');
};

hourlyDayHeading = function(day) {
  console.log(day.bold);
  return console.log('');
};

displayHourly = function(hourly) {
  var hour, time, _i, _len, _ref;

  if (hourly) {
    header();
    hourlyDayHeading('Today');
    _ref = hourly.data;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      hour = _ref[_i];
      time = new moment(hour.time * 1000);
      if (time.hour() > 7 && time.hour() <= 22) {
        if (time.hour() === 8) {
          if (moment().day() !== time.day()) {
            console.log('');
            console.log('');
            hourlyDayHeading(time.format('dddd'));
          }
        }
        console.log("" + (time.format('ha').rpad(' ', 4).red) + " " + (formatTemperature(hour.temperature)) + " " + (addColorToSummary(hour.summary)) + " ");
      }
    }
    return signoff();
  }
};

displayDaily = function(daily) {
  var date, day, maxTime, _i, _len, _ref;

  if (daily) {
    header();
    _ref = daily.data;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      day = _ref[_i];
      date = new moment(day.time * 1000);
      maxTime = new moment(day.temperatureMaxTime * 1000);
      if (moment().dayOfYear() === date.dayOfYear()) {
        console.log("    " + (formatTemperature(day.temperatureMax)) + " " + (addColorToSummary(day.summary)));
        console.log('');
      } else {
        console.log("" + (date.format('ddd').red) + " " + (formatTemperature(day.temperatureMax)) + " " + (addColorToSummary(day.summary)));
      }
    }
    console.log('');
    console.log(daily.summary.bold);
    return signoff();
  }
};

exports.get = function(place, hourly) {
  if (hourly == null) {
    hourly = false;
  }
  return geocoder.geocode(place, function(err, data) {
    var location, _ref, _ref1, _ref2;

    if (location = data != null ? (_ref = data.results) != null ? (_ref1 = _ref[0]) != null ? (_ref2 = _ref1.geometry) != null ? _ref2.location : void 0 : void 0 : void 0 : void 0) {
      return client.get("" + location.lat + "," + location.lng + "?si", function(err, res, body) {
        if (err) {
          return console.log(err);
        } else {
          if (hourly) {
            return displayHourly(body != null ? body.hourly : void 0);
          } else {
            return displayDaily(body != null ? body.daily : void 0);
          }
        }
      });
    } else {
      return console.log("I can't find your location. Please forgive me.");
    }
  });
};
