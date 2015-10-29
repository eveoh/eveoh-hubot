# Description:
#   Alert when the weekend begins.
#
# Commands:

TIMEZONE = "Europe/Amsterdam"
WEEKEND_TIME = '00 00 17 * * 5' # F 5pm

cronJob = require('cron').CronJob

module.exports = (robot) ->
  weekend = new cronJob WEEKEND_TIME,
    ->
      robot.send process.env.ROOM, "It's weeeeeeeeeeeeeeeeeeeekend!"
      robot.send process.env.ROOM, "http://img.444.hu/baxxter-animated.gif"
    null
    true
    TIMEZONE
