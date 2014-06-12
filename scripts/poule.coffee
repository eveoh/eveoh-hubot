# Description:
#   World Cup poule standings.
#
# Dependencies:
#   "ws": "0.4.31"
#
# Configuration:
#   HUBOT_POULE_ID
#
# Commands:
#   hubot wk - Returns the standings in the poule.

WebSocket = require('ws');

serverUrl = 'wss://service.watgaathetworden.nl/soccom/814/mfsy9whr/websocket'

module.exports = (robot) ->
	robot.respond /WK$/i, (msg) ->
		ws = new WebSocket(serverUrl)

		ws.onmessage = (e) ->
			data = e.data

			# Some sourcery going on here
			if (data.charAt 0) == 'a'
				data = data[1 .. data.length - 1]
				data = JSON.parse data
				data = JSON.parse data

				if data.t == "response" and data.a == "subpoule.players"
					for player in data.d.data.players
						msg.send "#{player.player.score}pt:\t #{player.player.name}"

					ws.close()

		ws.onopen = () ->
			# Request standings for our poule
			ws.send("{\"t\":\"request\",\"d\":{\"subpouleId\":#{process.env.HUBOT_POULE_ID},\"limit\":20,\"page\":1},\"a\":\"subpoule.players\"}")
