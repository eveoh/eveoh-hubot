# Description:
#   Posts Github status messages to the room
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   None
#
# URLS:
#   None
#
# Authors:
#   marcokrikke

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

    if payload.action == 'synchronize' then payload.action = 'synchronized'

    robot.send user, "[#{payload.repository.name}] #{payload.pull_request.user.login} #{payload.action} pull request '#{payload.pull_request.title}': #{payload.pull_request.html_url}"

  robot.on "github-issues", (data) ->
    payload = data.payload
    user = data.user

    robot.send user, "[#{payload.repository.name}] #{payload.issue.user.login} #{payload.action} issue ##{payload.issue.number} '#{payload.issue.title}': #{payload.issue.html_url}"

  robot.on "github-status", (data) ->
    payload = data.payload
    user = data.user

    if payload.sender.login == "eveoh-ci"
      msg = "[#{payload.repository.name}] "

      switch payload.state
        when "pending" then msg += "Build started"
        when "failure" then msg += "Build failed"
        when "success" then msg += "Build succeeded"

      if payload.target_url? then msg += " (" + payload.target_url + ")"

      robot.send user, msg
