# Description:
#   Alert when the cleaner will come by.
#
# Commands:

TIMEZONE = "Europe/Amsterdam"
CRON = '00 00 16 * * 1' # Mon 1pm
ROOM = "#eveoh"

desks = [
  "https://media.giphy.com/media/z5fNH8BMbeDN6/giphy.gif",
  "https://media.giphy.com/media/Pnph2o2G5pfkA/giphy.gif",
  "https://media.giphy.com/media/8QWDusaF6ZEY0/giphy.gif",
  "https://media.giphy.com/media/uCgghbAv6VkTC/giphy.gif",
  "https://media.giphy.com/media/7FN3Fg7VBJCN2/giphy.gif",
  "https://media.giphy.com/media/Oq6hxnYRu1hgA/giphy.gif",
  "https://media.giphy.com/media/l41m1PRth6MO50jzG/giphy.gif",
  "https://media.giphy.com/media/3osxYiUPAemiORWa4w/giphy.gif",
  "https://media.giphy.com/media/69hh4034OYSUo/giphy.gif"
]


cronJob = require('cron').CronJob

module.exports = (robot) ->
  new cronJob CRON,
    ->
      robot.messageRoom ROOM, "Morgen komt de schoonmaker weer!"
      robot.messageRoom ROOM, desks[Math.floor(Math.random() * desks.length)];
    null
    true
    TIMEZONE
