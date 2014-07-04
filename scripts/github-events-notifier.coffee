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
#   marcorkikke

url = require('url')
querystring = require('querystring')

module.exports = (robot) ->

  robot.on "github-push", (data) ->
    payload = data.payload
    user = data.user

    if payload.commits.length > 0
      commitWord = if payload.commits.length > 1 then "commits" else "commit"

      robot.send user, "[#{payload.repository.name}] #{payload.pusher.name} pushed #{payload.commits.length} new #{commitWord}: #{payload.compare}"

      # Display the last 4 commits
      for commit in payload.commits[-4..]
        # Only consider first line of the commit message
        message = commit.message.split "\n", 1
        message = message[0]

        robot.send user, "[#{payload.repository.name}] * #{commit.id[0..6]} - #{commit.author.username}: #{message}"

  robot.on "github-create", (data) ->
    payload = data.payload
    user = data.user

    robot.send user, "[#{payload.repository.name}] #{payload.sender.login} created #{payload.ref_type}: #{payload.ref}"

  robot.on "github-delete", (data) ->
    payload = data.payload
    user = data.user

    robot.send user, "[#{payload.repository.name}] #{payload.sender.login} deleted #{payload.ref_type}: #{payload.ref}"

  robot.on "github-pull_request", (data) ->
    payload = data.payload
    user = data.user

    robot.send user, "[#{payload.repository.name}] #{payload.pull_request.user.login} #{payload.action} pull request '#{payload.pull_request.title}': #{payload.pull_request.html_url}"

  robot.on "github-issues", (data) ->
    payload = data.payload
    user = data.user

    robot.send user, "[#{payload.repository.name}] #{payload.issue.user.login} #{payload.action} issue ##{payload.issue.number} '#{payload.issue.title}': #{payload.issue.html_url}"

