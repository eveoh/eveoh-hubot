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
      pushWord = if payload.forced then "force pushed" else "pushed"
      branch = payload.ref.replace /refs\/heads\//, ''

      robot.send user, "[#{payload.repository.name}] #{payload.pusher.name} #{pushWord} #{payload.commits.length} new #{commitWord} to #{branch}: #{payload.compare}"

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

    if payload.action = 'assigned'
      robot.send user, "[#{payload.repository.name}] #{payload.sender.login} #{payload.action} pull request '#{payload.pull_request.title}' to #{payload.assignee.login}: #{payload.pull_request.html_url}"
    else if payload.action in ['opened', 'closed', 'reopened']
      robot.send user, "[#{payload.repository.name}] #{payload.sender.login} #{payload.action} pull request '#{payload.pull_request.title}': #{payload.pull_request.html_url}"

  robot.on "github-issues", (data) ->
    payload = data.payload
    user = data.user

    if payload.action == 'assigned'
      robot.send user, "[#{payload.repository.name}] #{payload.sender.login} #{payload.action} issue ##{payload.issue.number} '#{payload.issue.title}' to #{payload.assignee.login}: #{payload.issue.html_url}"
    else if payload.action in ['opened', 'closed', 'reopened']
      robot.send user, "[#{payload.repository.name}] #{payload.sender.login} #{payload.action} issue ##{payload.issue.number} '#{payload.issue.title}': #{payload.issue.html_url}"

  robot.on "github-status", (data) ->
    payload = data.payload
    user = data.user

    if payload.sender.login == "eveoh-ci"
      msg = "[#{payload.repository.name}] "

      switch payload.state
        when "failure" then msg += "Build failed"
        when "error" then msg += "Build error"
        when "success" then msg += "Build succeeded"

      if payload.target_url? then msg += " (" + payload.target_url + ")"

      if payload.state != "pending"
        robot.send user, msg

  robot.on "github-repository", (data) ->
      payload = data.payload
      user = data.user
      visibility = if payload.repository.private then "private" else "public"

      robot.send user, "#{payload.sender.login} #{payload.action} #{visibility} repository: #{payload.repository.full_name}"

