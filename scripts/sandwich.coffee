# Description:
#   Make me a sandwich.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot make me a sandwich
#   hubot sudo make me a sandwich
#
# Authors:
#   https://xkcd.com/149/

module.exports = (robot) ->

  robot.respond /make me a sandwich/i, (msg) ->
    msg.send "What? Make it yourself."

  robot.respond /sudo make me a sandwich/i, (msg) ->
    msg.send "Okay."
