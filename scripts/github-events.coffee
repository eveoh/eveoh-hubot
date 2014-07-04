# Description:
#   An HTTP Listener for events from a Github webhook
#
# Dependencies:
#   "url": ""
#   "querystring": ""
#
# Configuration:
#   HUBOT_IGNORED_GITHUB_EVENTS - contains a comma separated list of events to ignore
#   Put this url <HUBOT_URL>:<PORT>/hubot/gh-events?room=<room> into your github hooks
#
# Commands:
#   None
#
# URLS:
#   POST /hubot/gh-events?room=<room>[&type=<type]
#
# Authors:
#   nesQuick
#   marcokrikke

url = require('url')
querystring = require('querystring')

module.exports = (robot) ->

  robot.router.post "/hubot/gh-events", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)
    ignoredEvents = process.env.HUBOT_IGNORED_GITHUB_EVENTS || ""
    ignoredEvents = ignoredEvents.split ","

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

      # Handle Push event
      if req.headers["x-github-event"] == "push" and "push" not in ignoredEvents
        robot.emit "github-push", data
              
      # Handle Create event
      if req.headers["x-github-event"] == "create" and "create" not in ignoredEvents
        robot.emit "github-create", data

      # Handle Delete event
      if req.headers["x-github-event"] == "delete" and "delete" not in ignoredEvents
        robot.emit "github-delete", data

      # Handle PR event
      if req.headers["x-github-event"] == "pull_request" and "pull_request" not in ignoredEvents
        robot.emit "github-pull_request", data

      # Handle issues event
      if req.headers["x-github-event"] == "issues" and "issues" not in ignoredEvents
        robot.emit "github-issues", data

      # Handle status event
      if req.headers["x-github-event"] == "status" and "status" not in ignoredEvents
        robot.emit "github-status", data

    catch error
      console.log "github-hook error: #{error}. Payload: #{req.body.payload}"
