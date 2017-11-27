# Description:
#   An HTTP Listener for events from a Github webhook
#
# Dependencies:
#   "url": ""
#   "querystring": ""
#
# Configuration:
#   HUBOT_IGNORED_GITHUB_EVENTS - contains a comma separated list of events to ignore
#   HUBOT_GITHUB_SHARED_SECRET - shared secret used to verify GitHub webhook messages
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
crypto = require('crypto')

module.exports = (robot) ->

  ignoredEvents = process.env.HUBOT_IGNORED_GITHUB_EVENTS || ""
  ignoredEvents = ignoredEvents.split ","

  # See https://developer.github.com/webhooks/#events
  allEvents = ['create_comment', 'create', 'delete', 'deployment', 'deployment_status', 'fork', 'gollum',
    'issue_comment', 'issues', 'member', 'membership', 'page_build', 'public', 'pull_request_review_comment',
    'pull_request', 'push', 'repository', 'release', 'status', 'team_add', 'watch']

  # Events to handle
  events = []
  events.push(value) for value in allEvents when value not in ignoredEvents

  robot.router.post "/hubot/gh-events", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)

    res.end('')

    user = {}
    user.room = query.room if query.room
    user.type = query.type if query.type

    try
      payload = req.body

      # Verify the request
      secret = process.env.HUBOT_GITHUB_SHARED_SECRET
      signature = req.headers["x-hub-signature"]
      computedSignature = 'sha1=' + crypto.createHmac('sha1', secret).update(JSON.stringify(payload)).digest('hex')

      if not crypto.timingSafeEqual(Buffer.from(signature), Buffer.from(computedSignature))
        throw "Could not validate GitHub message"

      eventHeader = req.headers["x-github-event"]

      data = {
        user: user,
        payload: payload
      }

      if eventHeader in events
        robot.emit "github-" + eventHeader, data

    catch error
      console.log "github-hook error: #{error}. Payload: #{req.body.payload}"
