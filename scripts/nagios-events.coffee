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

module.exports = (robot) ->

  robot.router.post "/hubot/nagios-events", (req, res) ->
    res.end('')

    try
      data = {
        user: req.body.room,
        payload: req.body
      }

      if req.body.t == 'service'
        robot.emit "nagios-service", data

      if req.body.t == 'host'
        robot.emit "nagios-host", data

    catch error
      console.log "Nagios event error: #{error}. Payload: #{req.body}"
