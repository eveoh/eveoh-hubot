# Description:
#   Office temperature as provided by the Spark Core.
#
# Commands:
#   hubot temp - Hubot show me the office temperature.

module.exports = (robot) ->
  robot.respond /temp/i, (msg) ->
    robot.http("https://api.particle.io/v1/devices/#{process.env.HUBOT_PARTICLE_DEVICE_ID}/temperature?access_token=#{process.env.HUBOT_PARTICLE_ACCESS_TOKEN}")
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        if err
          msg.send "Could not grab temperature from Particle"
          return

        data = null
        try
          data = JSON.parse(body)
        catch error
          msg.send "Ran into an error parsing JSON :("
          return

        msg.send "The temperature in the office is #{data.result.toFixed(1)} degrees Celsius"
        return
