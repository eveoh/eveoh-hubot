# Description:
#   Alert when the cleaners will come.
#
# Commands:

CRON_TZ = process.env.HUBOT_CLEANERS_CRON_TZ
CRON_EXP = process.env.HUBOT_CLEANERS_CRON_EXP
ROOM = process.env.HUBOT_CLEANERS_ROOM

desks = [
  "https://media.giphy.com/media/z5fNH8BMbeDN6/giphy.gif",
  "https://media.giphy.com/media/Pnph2o2G5pfkA/giphy.gif",
  "https://media.giphy.com/media/8QWDusaF6ZEY0/giphy.gif",
  "https://media.giphy.com/media/uCgghbAv6VkTC/giphy.gif",
  "https://media.giphy.com/media/7FN3Fg7VBJCN2/giphy.gif",
  "https://media.giphy.com/media/Oq6hxnYRu1hgA/giphy.gif",
  "https://media.giphy.com/media/l41m1PRth6MO50jzG/giphy.gif",
  "https://media.giphy.com/media/3osxYiUPAemiORWa4w/giphy.gif",
  "https://media.giphy.com/media/69hh4034OYSUo/giphy.gif",
  "https://media.giphy.com/media/xTiTnyb9oJUqkfCYyk/giphy.gif",
  "https://media.giphy.com/media/HIrYP4RI9DpLy/giphy.gif",
  "https://media.giphy.com/media/DZu3mnCcmsJKE/giphy.gif",
  "https://media.giphy.com/media/LhVGZXspUHbhK/giphy.gif",
  "https://media.giphy.com/media/PDjBHZrqe3Haw/giphy.gif",
  "https://media.giphy.com/media/AgkmVdBGLcor6/giphy.gif",
  "https://media.giphy.com/media/dJEMs13SrsiuA/giphy.gif",
  "https://media.giphy.com/media/c09yGbnSyaFRS/giphy.gif",
  "https://media.giphy.com/media/yOMOCCYI0sEMw/giphy.gif",
  "https://media.giphy.com/media/WdIaMQ6bLlvtm/giphy.gif",
  "https://media.giphy.com/media/l44QfSJkfcLayU8Ny/giphy.gif",
  "https://media.giphy.com/media/3oKIPCSX4UHmuS41TG/giphy.gif"
]

cronJob = require('cron').CronJob

module.exports = (robot) ->
  new cronJob CRON_EXP,
    ->
      robot.messageRoom ROOM, "Morgen komt de schoonmaker weer!"
      robot.messageRoom ROOM, desks[Math.floor(Math.random() * desks.length)];
    null
    true
    CRON_TZ
