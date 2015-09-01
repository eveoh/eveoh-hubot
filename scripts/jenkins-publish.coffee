# Description:
#   Triggers a publish job in Jenkins
#
# Configuration:
#   HUBOT_JENKINS_URL - link to Jenkins, e.g. http://internal-jenkins:8080, without trailing /
#   HUBOT_JENKINS_CI_USER_USERNAME - dedicated Jenkins user used to perform builds
#   HUBOT_JENKINS_CI_USER_TOKEN - token of dedicated Jenkins user used to perform builds
#
# Commands:
#   hubot set jenkins token for <jenkinsuser> to <token> - assign a Jenkins user and access token to a Hubot user
#   hubot show jenkins token - display the Jenkins token for the Hubot user
#   hubot remove jenkins token - remove the Jenkins token for the Hubot user
#   hubot publish <project> commit <commitSha1> - start publish job for project and commit
#   hubot publish <project> tag <tag> - start publish job for project and tag
#   hubot publish <project> branch <branch> - start publish job for project and branch
#
# Examples:
#   hubot set jenkins token for foo to bar
#   hubot publish jenkins-ci commit fa3cd16
#   hubot publish jenkins-ci tag v1.0.1
#   hubot publish jenkins-ci branch master
#
# Authors:
#   marcokrikke

module.exports = (robot) ->
  robot.brain.data.jenkinstokens ?= {}

  robot.respond /publish (.*) commit ([0-9a-f]{5,40})/i, (msg) ->
    repo = msg.match[1]
    specifier = msg.match[2]

    startPublishJob(msg, repo, specifier)

  robot.respond /publish (.*) tag (.*)/i, (msg) ->
    repo = msg.match[1]
    specifier = "refs/tags/#{msg.match[2]}"

    startPublishJob(msg, repo, specifier)

  robot.respond /publish (.*) branch (.*)/i, (msg) ->
    repo = msg.match[1]
    specifier = "refs/heads/#{msg.match[2]}"

    startPublishJob(msg, repo, specifier)


  startPublishJob = (msg, repo, specifier) ->
    data = JSON.stringify({
      parameter: [
        {
          "name": "SPECIFIER",
          "value": specifier
        }
      ]
    })

    hubotUser = msg.message.user.name
    repoJob = "#{repo}-publish"

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
        msg.send "[publish] Jenkins says: #{err}"
      else if 201 == res.statusCode
        msg.send "[publish] Publish build started for project #{repo} and specifier #{specifier}"
      else if 404 == res.statusCode
        msg.send "[publish] No publish job found for repository #{repo}"
      else
        msg.send "[publish] Jenkins says: Status #{res.statusCode}"

  robot.respond /set jenkins token for ([\w\d]+) to ([\w\d-]+)$/i, (msg) ->
    jenkinsUsername = msg.match[1]
    jenkinsToken = msg.match[2]
    hubotUser = msg.message.user.name

    robot.brain.data.jenkinstokens[hubotUser] ?= {}
    robot.brain.data.jenkinstokens[hubotUser].username = jenkinsUsername
    robot.brain.data.jenkinstokens[hubotUser].token = jenkinsToken

    msg.reply "Jenkins token saved for user #{hubotUser}: Jenkins username '#{jenkinsUsername}', token '#{jenkinsToken}'"


  robot.respond /show jenkins token/i, (msg) ->
    hubotUser = msg.message.user.name

    if robot.brain.data.jenkinstokens[hubotUser]?
      msg.reply "Jenkins token found for Hubot user #{hubotUser}: Jenkins username '#{robot.brain.data.jenkinstokens[hubotUser].username}', token '#{robot.brain.data.jenkinstokens[hubotUser].token}'"
    else
      msg.reply "No Jenkins token found for user #{hubotUser}"

  robot.respond /remove jenkins token/i, (msg) ->
    hubotUser = msg.message.user.name

    robot.brain.data.jenkinstokens[hubotUser] = undefined

    msg.reply "Jenkins token removed for user #{hubotUser}"
