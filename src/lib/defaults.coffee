fs = require('fs')

settingsFile = ""
if process.platform == 'win32'
  settingsFile = process.env['USERPROFILE'] + '/forecast-cli.json'
else
  settingsFile = process.env['HOME'] + '/.forecast-cli.json'

readDefaults = () ->
  contents = ""
  try
    contents = fs.readFileSync settingsFile, 'utf8'
  catch e
    return {}    
  JSON.parse(contents)

exports.place = () ->
  readDefaults()?.place ? ''

exports.savePlace = (place) ->
  fs.writeFile(settingsFile, JSON.stringify({ place: place }, null, 2), (err) ->
    if err
      console.log err
  )

