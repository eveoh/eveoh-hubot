# Description:
#   Posts Sonatype Nexus status messages to the room
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

  robot.on "nexus-created", (data) ->
    payload = data.payload
    user = data.user

    robot.send user, "[#{payload.repositoryName}] new artifact created #{payload.group}:#{payload.name}:#{payload.version}"
