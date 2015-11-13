# Description:
#   Alert when the weekend begins.
#
# Commands:

TIMEZONE = "Europe/Amsterdam"
WEEKEND_TIME = '00 00 17 * * 5' # F 5pm
ROOM = "#eveoh"

cronJob = require('cron').CronJob

module.exports = (robot) ->
  new cronJob WEEKEND_TIME,
    ->
      robot.messageRoom ROOM, "It's weeeeeeeeeeeeeeeeeeeekend!"
      robot.messageRoom ROOM, "http://img.444.hu/baxxter-animated.gif"
    null
    true
    TIMEZONE
