# Description:
#   Alert when the weekend begins.
#
# Commands:

CRON_TZ = process.env.HUBOT_WEEKEND_CRON_TZ
CRON_EXP = process.env.HUBOT_WEEKEND_CRON_EXP
ROOM = process.env.HUBOT_WEEKEND_ROOM

cronJob = require('cron').CronJob

module.exports = (robot) ->
  new cronJob CRON_EXP,
    ->
      robot.messageRoom ROOM, "It's weeeeeeeeeeeeeeeeeeeekend!"
      robot.messageRoom ROOM, "http://img.444.hu/baxxter-animated.gif"
    null
    true
    CRON_TZ
