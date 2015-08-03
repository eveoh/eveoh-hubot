# Description:
#   Triggers a release job in Jenkins
#
# Configuration:
#   HUBOT_JENKINS_URL - link to Jenkins, e.g. http://internal-jenkins:8080, without trailing /
#   HUBOT_JENKINS_CI_USER_USERNAME - dedicated Jenkins user used to perform builds
#   HUBOT_JENKINS_CI_USER_TOKEN - token of dedicated Jenkins user used to perform builds
#
# Commands:
#   hubot set jenkins token for <user> to <token> - assign a Jenkins access token to a user
#   hubot release <project> commit <commitSha1> - start release job for project and commit
#   hubot release <project> tag <tag> - start release job for project and tag
#   hubot release <project> branch <branch> - start release job for project and branch
#
# Examples:
#   hubot set jenkins token for foo to bar
#   hubot release jenkins-ci commit fa3cd16
#   hubot release jenkins-ci tag v1.0.1
#   hubot release jenkins-ci branch master
#
# Authors:
#   marcokrikke

module.exports = (robot) ->
  robot.brain.data.jenkinstokens ?= {}

  robot.respond /release (.*) commit ([0-9a-f]{5,40})/i, (msg) ->
    repo = msg.match[1]
    specifier = msg.match[2]

    startReleaseJob(msg, repo, specifier)

  robot.respond /release (.*) tag (.*)/i, (msg) ->
    repo = msg.match[1]
    specifier = "refs/tags/#{msg.match[2]}"

    startReleaseJob(msg, repo, specifier)

  robot.respond /release (.*) branch (.*)/i, (msg) ->
    repo = msg.match[1]
    specifier = "refs/heads/#{msg.match[2]}"

    startReleaseJob(msg, repo, specifier)


  startReleaseJob = (msg, repo, specifier) ->
    data = JSON.stringify({
      parameter: [
        {
          "name": "SPECIFIER",
          "value": specifier
        }
      ]
    })

    hubotUser = msg.message.user.name
    repoJob = "#{repo}-release"

    # Check if token exists for Hubot user, otherwise use global account
    if robot.brain.data.jenkinstokens[hubotUser]?
      auth = new Buffer("#{robot.brain.data.jenkinstokens[hubotUser].username}:#{robot.brain.data.jenkinstokens[hubotUser].token}").toString('base64')
    else
      auth = new Buffer("#{process.env.HUBOT_JENKINS_CI_USER_USERNAME}:#{process.env.HUBOT_JENKINS_CI_USER_TOKEN}").toString('base64')

    robot.http("#{process.env.HUBOT_JENKINS_URL}/job/#{repoJob}/build")
    .header('Authorization', "Basic #{auth}")
    .header('Content-Type', 'application/x-www-form-urlencoded')
    .post("json=#{data}") (err, res, body) ->
      if err
        msg.reply "[release] Jenkins says: #{err}"
      else if 201 == res.statusCode
        msg.reply "[release] Release build started for project #{repo} and specifier #{specifier}"
      else if 404 == res.statusCode
        msg.reply "[release] No release job found for repository #{repo}"
      else
        msg.reply "[release] Jenkins says: Status #{res.statusCode}"

  robot.respond /set jenkins token for ([\w\d]+) to ([\w\d]+)$/i, (msg) ->
    jenkinsUsername = msg.match[1]
    jenkinsToken = msg.match[3]
    hubotUser = msg.message.user.name

    robot.brain.data.jenkinstokens[hubotUser] ?= {}
    robot.brain.data.jenkinstokens[hubotUser].username = jenkinsUsername
    robot.brain.data.jenkinstokens[hubotUser].token = jenkinsToken

    msg.reply "Jenkins token saved for user #{hubotUser}"
