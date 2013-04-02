fs = require('fs')

settingsFile = ""
if process.platform == 'win32'
  settingsFile = process.env['USERPROFILE'] + '/forecast-cli.json'
else
  settingsFile = process.env['HOME'] + '/.forecast-cli.json'

readDefaults = () ->
  contents = ''
  try
    contents = fs.readFileSync settingsFile, 'utf8'
  catch e

  try
    JSON.parse(contents)
  catch e
    {}

exports.place = () ->
  readDefaults()?.place ? ''

exports.units = () ->
  readDefaults()?.units ? 'si'

exports.savePlace = (place) ->
  defaults = readDefaults()
  defaults.place = place
  fs.writeFileSync(settingsFile, JSON.stringify(defaults, null, 2))

exports.saveUnits = (units) ->
  defaults = readDefaults()
  defaults.units = units
  fs.writeFileSync(settingsFile, JSON.stringify(defaults, null, 2))