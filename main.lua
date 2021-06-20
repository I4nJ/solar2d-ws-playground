--#############################################################################
--# Corona WebSockets Plugin Demo
--# (c)2019 C. Byerley (develephant)
--# Docs: https://develephant.github.io/websockets-plugin/
--#############################################################################

local WebSocket = require("plugin.websockets")
local json = require("json")

--#############################################################################
--# Create a new WebSocket client
--#############################################################################

local ws = WebSocket.new()

--#############################################################################
--# Sending messages
--#############################################################################

local num_msgs = 5
local count = 0

local function sendMessage()
    count = count + 1
  
    local payload = {
        ["action"] = "studycat_echo",
        ["message"] = "Time: " .. tostring( system.getTimer() ) .. ""
    }

    local str = json.encode(payload);
    
	ws:send( str ) -- Send message to host
end

--#############################################################################
--# WebSocket client event handler
--#############################################################################

local function WsHandler(event)

  local etype = event.type

  if etype == ws.ONOPEN then
    print( 'Received event: ONOPEN' )
		print("=== Sending " .. tostring( num_msgs ) .. " messages ===\n")
		sendMessage()
  elseif etype == ws.ONMESSAGE then
		local msg = event.data

		print( "Received event: ONMESSAGE" )
		print( "echoed message: '" .. tostring( msg ) .. "'\n\n" )

		if count == num_msgs then
			ws:disconnect()
		else
			timer.performWithDelay( 500, function() sendMessage() end)
		end
  elseif etype == ws.ONCLOSE then
		print( "Received event: ONCLOSE" )
		print( 'code:reason', event.code, event.reason )
  elseif etype == ws.ONERROR then
    print( "Received event: ONERROR" )
		print( 'code:reason', event.code, event.reason )
  end

end

--#############################################################################
--# Add WebSocket client event handler
--#############################################################################

ws:addEventListener(ws.WSEVENT, WsHandler)

--#############################################################################
--# WebSocket client connect
--#############################################################################

ws:connect('wss://33umfomvul.execute-api.eu-central-1.amazonaws.com/Prod')