# Description:
#   An HTTP Listener for events from Nagios
#
# Dependencies:
#   "url": ""
#   "querystring": ""
#
# Configuration:
#   Put this url <HUBOT_URL>:<PORT>/hubot/nagios-events?room=<room> into Nagios
#
# Commands:
#   None
#
# URLS:
#   POST /hubot/nagios-events
#
# Authors:
#   marcokrikke

url = require('url')
querystring = require('querystring')

module.exports = (robot) ->

  robot.router.post "/hubot/nagios-events", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)

    res.end('')

    user = {}
    user.room = query.room if query.room
    user.type = query.type if query.type

    try
      data = {
        user: user,
        payload: req.body
      }

      if req.body.t == 'service'
        robot.emit "nagios-service", data

      if req.body.t == 'host'
        robot.emit "nagios-host", data

    catch error
      console.log "Nagios event error: #{error}. Payload: #{req.body}"
