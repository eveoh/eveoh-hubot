# Description:
#   Posts Nagios status messages to the room
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

  robot.on "nagios-service", (data) ->
    payload = data.payload
    user = data.user

    robot.send user, "[nagios-service] #{payload.nt}: #{payload.sa}/#{payload.sd} is #{payload.ss}"

  robot.on "nagios-host", (data) ->
    payload = data.payload
    user = data.user

    robot.send user, "[nagios-host] #{payload.nt}: #{payload.hn} is #{payload.hs}"
