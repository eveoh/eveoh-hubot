# Description:
#   Triggers a publish job in Jenkins
#
# Configuration:
#   HUBOT_JENKINS_URL - link to Jenkins, e.g. http://internal-jenkins:8080, without trailing /
#   HUBOT_JENKINS_CI_USER_USERNAME - dedicated Jenkins user used to perform builds
#   HUBOT_JENKINS_CI_USER_TOKEN - token of dedicated Jenkins user used to perform builds
#
# Commands:
#   hubot publish <project> commit <commitSha1> - start publish job for project and commit
#   hubot publish <project> tag <tag> - start publish job for project and tag
#   hubot publish <project> branch <branch> - start publish job for project and branch
#
# Examples:
#   hubot publish jenkins-ci commit fa3cd16
#   hubot publish jenkins-ci tag v1.0.1
#   hubot publish jenkins-ci branch master
#
# Authors:
#   marcokrikke

module.exports = (robot) ->
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
    auth = new Buffer("#{process.env.HUBOT_JENKINS_CI_USER_USERNAME}:#{process.env.HUBOT_JENKINS_CI_USER_TOKEN}").toString('base64')

    # Get Crumb from Jenkins
    robot.http("#{process.env.HUBOT_JENKINS_URL}/crumbIssuer/api/json")
    .header('Authorization', "Basic #{auth}")
    .get() (err, res, body) ->
      if err
        msg.send "[publish] Could not get Crumb. Jenkins says: #{err}"
        return
      else
        crumbData = JSON.parse body

        console.error(crumbData)

        # Start publish job
        data = JSON.stringify({
          parameter: [
            {
              "name": "SPECIFIER",
              "value": specifier
            }
          ]
        })

        robot.http("#{process.env.HUBOT_JENKINS_URL}/job/#{repo}-publish/build")
          .header('Authorization', "Basic #{auth}")
          .header('Content-Type', 'application/x-www-form-urlencoded')
          .header(crumbData.crumbRequestField, crumbData.crumb)
          .post("json=#{data}") (err, res) ->
            if err
              msg.send "[publish] Jenkins says: #{err}"
            else if 201 == res.statusCode
              msg.send "[publish] Publish build started for project #{repo} and specifier #{specifier}"
            else if 404 == res.statusCode
              msg.send "[publish] No publish job found for repository #{repo}"
            else
              msg.send "[publish] Jenkins says: Status #{res.statusCode}"
