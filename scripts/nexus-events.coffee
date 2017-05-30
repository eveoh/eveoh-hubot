# Description:
#   An HTTP Listener for events from a Sonatype Nexus webhook
#
# Dependencies:
#   "url": ""
#   "querystring": ""
#
# Configuration:
#   HUBOT_IGNORED_NEXUS_EVENTS - contains a comma separated list of events to ignore
#   Put this url <HUBOT_URL>:<PORT>/hubot/nexus-events?room=<room> into your Nexus hooks
#
# Commands:
#   None
#
# URLS:
#   POST /hubot/nexus-events?room=<room>[&type=<type]
#
# Authors:
#   nesQuick
#   marcokrikke

url = require('url')
querystring = require('querystring')

module.exports = (robot) ->

  ignoredEvents = process.env.HUBOT_IGNORED_NEXUS_EVENTS || ""
  ignoredEvents = ignoredEvents.split ","

  allEvents = ['CREATED']

  # Events to handle
  events = []
  events.push(value) for value in allEvents when value not in ignoredEvents

  robot.router.post "/hubot/nexus-events", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)

    res.end('')

    user = {}
    user.room = query.room if query.room
    user.type = query.type if query.type

    try
      payload = req.body

      data = {
        user: user,
        payload: payload
      }

      if payload.action in events
        robot.emit "nexus-" + payload.action.toLowerCase(), data

    catch error
      console.log "nexus-hook error: #{error}. Payload: #{req.body.payload}"
