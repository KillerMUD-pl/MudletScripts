---  Connects to a given game.
--- 
--- ## Parameters:
--- * `host:`
---  Server domain or IP address.
--- * `port:`
---  Servers port.
--- * `save:`
---  (optional, boolean) if provided, saves the new connection parameters in the profile so they'll be used next time you open it.
--- 
--- Note:  `save` is available in Mudlet 3.2+.
--- 
--- ## Example
--- ```lua
--- connectToServer("midnightsun2.org", 3000)
--- 
--- -- save to disk so these parameters are used next time when opening the profile
--- connectToServer("midnightsun2.org", 3000, true)
--- ```
function connectToServer(host, port, save)
end

---  Disconnects you from the game right away. Note that this will `not` properly log you out of the game - use an ingame command for that. Such commands vary, but typically QUIT will work.
--- 
--- See also:
--- see: reconnect()
--- ```lua
--- disconnect()
--- ```
function disconnect()
end

---  Downloads the resource at the given url into the saveto location on disk. This does not pause the script until the file is downloaded - instead, it lets it continue right away and downloads in the background. When a download is finished, the [[Manual:Event_Engine#sysDownloadDone|sysDownloadDone]] event is raised (with the saveto location as the argument), or when a download fails, the [[Manual:Event_Engine#sysDownloadError|sysDownloadError]] event is raised with the reason for failure. You may call downloadFile multiple times and have multiple downloads going on at once - but they aren’t guaranteed to be downloaded in the same order that you started them in.
--- 
--- See also:
--- see: getHTTP()
--- see: postHTTP()
--- see: putHTTP()
--- see: deleteHTTP()
--- 
--- 
--- Note:  Since Mudlet 3.0, https downloads are supported and the actual url that was used for the download is returned - useful in case of redirects.
--- 
--- ## Example
--- ```lua
--- -- just download a file and save it in our profile folder
--- local saveto = getMudletHomeDir().."/dark-theme-mudlet.zip"
--- local url = "http://www.mudlet.org/wp-content/files/dark-theme-mudlet.zip"
--- downloadFile(saveto, url)
--- cecho("<white>Downloading <green>"..url.."<white> to <green>"..saveto.."\n")
--- ```
--- 
--- 
--- 
--- 
--- A more advanced example that downloads a webpage, reads it, and prints a result from it:
--- ```lua
--- -- create a function to parse the downloaded webpage and display a result
--- function downloaded_file(_, filename)
---   -- is the file that downloaded ours?
---   if not filename:find("achaea-who-count.html", 1, true) then return end
--- 
---   -- read the contents of the webpage in
---   local f, s, webpage = io.open(filename)
---   if f then webpage = f:read("*a"); io.close(f) end
---   -- delete the file on disk, don't clutter
---   os.remove(filename)
--- 
---   -- parse our downloaded file for the player count
---   local pc = webpage:match([[Total: (%d+) players online]])
---   display("Achaea has "..tostring(pc).." players on right now.")
--- end
--- 
--- -- register our function to run on the event that something was downloaded
--- registerAnonymousEventHandler("sysDownloadDone", "downloaded_file")
--- 
--- -- download a list of fake users for a demo
--- downloadFile(getMudletHomeDir().."/achaea-who-count.html", "https://www.achaea.com/game/who")
--- ```
--- 
--- Result should look like this:
--- 
--- .
function downloadFile(saveto, url)
end

--- Returns the server address and port that you're currently connected to.
--- See also:
--- see: connectToServer()
--- Note:  Available in Mudlet 4.2+
--- 
--- ## Example
--- ```lua
--- local host, port = getConnectionInfo()
--- cecho(string.format("<light_grey>Connected to <forest_green>%s:%s\n", host, port))
--- ```
--- 
--- ```lua
--- -- echo the new connection parameters whenever we connect to a different host with connectToServer()
--- function echoInfo()
---     local host, port = getConnectionInfo()
---     cecho(string.format("<light_grey>Now connected to <forest_green>%s:%s\n", host, port))
---   end
--- 
--- registerAnonymousEventHandler("sysConnectionEvent", "echoInfo")
--- ```
function getConnectionInfo()
end

--- Returns a list of channels the IRC client is joined to as a lua table. If the client is not yet started the value returned is loaded from disk and represents channels the client will auto-join when started.
--- See also:
--- see: setIrcChannels()
--- Note:  Available in Mudlet 3.3+
--- 
--- ## Example
--- ```lua
--- display(getIrcChannels())
--- -- Prints: {"#mudlet", "#lua"}
--- ```
function getIrcChannels()
end

--- Returns true+host where host is a string containing the host name of the IRC server, as given to the client by the server while starting the IRC connection. If the client has not yet started or finished connecting this will return false and an empty string.  
--- 
--- This function can be particularly useful for testing if the IRC client has connected to a server prior to sending data, and it will not auto-start the IRC client.<br />  
--- The `hostname` value this function returns can be used to test if [[Manual:Event_Engine#sysIrcMessage|sysIrcMessage]] events are sent from the server or a user on the network.
--- 
--- ## Example
--- ```lua
--- local status, hostname = getIrcConnectedHost()
--- 
--- if status == true then
---   -- do something with connected IRC, send IRC commands, store 'hostname' elsewhere.
---   -- if sysIrcMessage sender = hostname from above, message is likely a status, command response, or an error from the Server.
--- else 
---   -- print a status, change connection settings, or just continue waiting to send IRC data.
--- end
--- ```
--- 
--- Note:  Available in Mudlet 3.3+
function getIrcConnectedHost()
end

--- Returns a string containing the IRC client nickname. If the client is not yet started, your default nickname is loaded from IRC client configuration.
--- See also:
--- see: setIrcNick()
--- Note:  Available in Mudlet 3.3+
--- 
--- ## Example
--- ```lua
--- local nick = getIrcNick()
--- echo(nick)
--- -- Prints: "Sheldor"
--- ```
function getIrcNick()
end

--- Returns the IRC client server name and port as a string and a number respectively. If the client is not yet started your default server is loaded from IRC client configuration.
--- See also:
--- see: setIrcServer()
--- Note:  Available in Mudlet 3.3+
--- 
--- ## Example
--- ```lua
--- local server, port = getIrcServer()
--- echo("server: "..server..", port: "..port.."\n")
--- ```
function getIrcServer()
end

---  Returns the last measured response time between the sent command and the server reply in seconds - e.g. 0.058 (=58 milliseconds lag) or 0.309 (=309 milliseconds). This is the `N:` number you see bottom-right of Mudlet.
--- 
--- Also known as server lag.
--- 
--- ## Example
--- `Need example`
function getNetworkLatency()
end

--- Opens the default OS browser for the given URL.
--- 
--- ## Example:
--- ```lua
--- openUrl("http://google.com")
--- openUrl("www.mudlet.org")
--- ```
function openUrl(url)
end

---  Purge all media file stored in the media cache within a given Mudlet profile (media used with MCMP and MSP protocols). As game developers update the media files on their games, this enables the media folder inside the profile to be cleared so that the media files could be refreshed to the latest update(s).
--- 
--- ## Guidance:
--- 
--- * Instruct a player to type `lua purgeMediaCache()` on the command line, or
--- * Distribute a trigger, button or other scriptable feature for the given profile to call `purgeMediaCache()`
--- 
--- See also:
--- see: Supported Protocols MSP()
--- see: Scripting MCMP()
function purgeMediaCache()
end

---  Receives a well-formed Mud Sound Protocol (MSP) message to be processed by the Mudlet client.  Reference the [[Manual:Supported_Protocols#MSP|Supported Protocols MSP]] manual for more information on about what can be sent and example triggers.
--- 
--- See also:
--- see: Supported Protocols MSP()
--- ## Example
--- ```lua
--- --Play a cow.wav media file stored in the media folder of the current profile. The sound would play twice at a normal volume.
--- receiveMSP("!!SOUND(cow.wav L=2 V=50)")
--- 
--- --Stop any SOUND media files playing stored in the media folder of the current profile.
--- receiveMSP("!!SOUND(Off)")
--- 
--- --Play a city.mp3 media file stored in the media folder of the current profile. The music would play once at a low volume.
--- --The music would continue playing if it was triggered earlier by another room, perhaps in the same area.
--- receiveMSP([[!!MUSIC(city.mp3 L=1 V=25 C=1)]])
--- 
--- --Stop any MUSIC media files playing stored in the media folder of the current profile.
--- receiveMSP("!!MUSIC(Off)")
--- ```
function receiveMSP(command)
end

---  Force-reconnects (so if you're connected, it'll disconnect) you to the game.
--- 
--- ## Example
--- ```lua
--- -- you could trigger this on a log out message to reconnect, if you'd like
--- reconnect()
--- ```
function reconnect()
end

--- Restarts the IRC client connection, reloading configurations from disk before reconnecting the IRC client.
--- 
--- Note:  Available in Mudlet 3.3+
function restartIrc()
end

---  sends multiple things to the game. If you'd like the commands not to be shown, include `false` at the end.
--- 
--- See also:
--- see: send()
--- ## Example
--- ```lua
--- -- instead of using many send() calls, you can use one sendAll
--- sendAll("outr paint", "outr canvas", "paint canvas")
--- -- can also have the commands not be echoed
--- sendAll("hi", "bye", false)
--- ```
function sendAll(list_of_things_to_send, echo_back_or_not)
end

---  `Need description`
--- 
--- See also:
--- see: ATCP Protocol()
--- see: ATCP Extensions()
--- ## Parameters:
--- * `message:`
---  The message that you want to send.
--- * `what:`
---  `Need description`
--- 
--- ## Example
--- `Need example`
function sendATCP(message, what)
end

---  Sends a GMCP message to the server.  The [http://www.ironrealms.com/gmcp-doc IRE document on GMCP] has information about what can be sent, and what tables it will use, etcetera.
---  Note that this function is rarely used in practice. For most GMCP modules, the messages are automatically sent by the server when a relevant event happens in the game. For example, LOOKing in your room prompts the server to send the room description and contents, as well as the GMCP message gmcp.Room. A call to sendGMCP would not be required in this case.
--- 
--- See also:
--- see: GMCP Scripting()
--- ## Example
--- ```lua
--- --This would send "Core.KeepAlive" to the server, which resets the timeout
--- sendGMCP("Core.KeepAlive")
--- 
--- --This would send a request for the server to send an update to the gmcp.Char.Skills.Groups table.
--- sendGMCP("Char.Skills.Get {}")
--- 
--- --This would send a request for the server to send a list of the skills in the 
--- --vision group to the gmcp.Char.Skills.List table.
--- 
--- sendGMCP("Char.Skills.Get " .. yajl.to_string{group = "vision"})
--- 
--- --And finally, this would send a request for the server to send the info for 
--- --hide in the woodlore group to the gmcp.Char.Skills.Info table
--- 
--- sendGMCP("Char.Skills.Get " .. yajl.to_string{group="MWP", name="block"})
--- ```
function sendGMCP(command)
end

---  Sends a MSDP message to the server.
--- 
--- ## Parameters:
--- * `variable:`
---  The variable, in MSDP terms, that you want to request from the server.
--- * `value:`
---  The variables value that you want to request. You can request more than one value at a time.
--- 
---  See Also: [[Manual:Supported_Protocols#MSDP|MSDP support in Mudlet]], [http://tintin.sourceforge.net/msdp/ Mud Server Data Protocol specification]
--- 
--- ## Example
--- ```lua
--- -- ask for a list of commands, lists, and reportable variables that the server supports
--- sendMSDP("LIST", "COMMANDS", "LISTS", "REPORTABLE_VARIABLES")
--- 
--- -- ask the server to start keeping you up to date on your health
--- sendMSDP("REPORT", "HEALTH")
--- 
--- -- or on your health and location
--- sendMSDP("REPORT", "HEALTH", "ROOM_VNUM", "ROOM_NAME")
--- ```
function sendMSDP(variable, _value, _value...)
end

---  Sends a message to an IRC channel or person. Returns `true`+`status` if message could be sent or was successfully processed by the client, or `nil`+`error` if the client is not ready for sending, and `false`+`status` if the client filtered the message or failed to send it for some reason. If the IRC client hasn't started yet, this function will initiate the IRC client and begin a connection.
--- 
--- To receive an IRC message, check out the [[Manual:Event_Engine#sysIrcMessage|sysIrcMessage event]].
--- 
--- Note:  Since Mudlet 3.3, auto-opens the IRC window and returns the success status.
--- 
--- ## Parameters:
--- * `target:`
---  nick or channel name and if omitted will default to the first available channel in the list of joined channels.
--- * `message:`
---  The message to send, may contain IRC client commands which start with <code>/</code> and can use all commands which are available through the client window.
--- 
--- ## Example
--- ```lua
--- -- this would send "hello from Mudlet!" to the channel #mudlet on freenode.net
--- sendIrc("#mudlet", "hello from Mudlet!")
--- -- this would send "identify password" in a private message to Nickserv on freenode.net
--- sendIrc("Nickserv", "identify password")
--- 
--- -- use an in-built IRC command
--- sendIrc("#mudlet", "/topic")
--- ```
--- 
--- Note:  The following IRC commands are available since Mudlet 3.3:
--- * /ACTION <target> <message...>
--- * /ADMIN (<server>)
--- * /AWAY (<reason...>)
--- * /CLEAR (<buffer>) -- Clears the text log for the given buffer name. Uses the current active buffer if none are given.
--- * /CLOSE (<buffer>) -- Closes the buffer and removes it from the Buffer list. Uses the current active buffer if none are given.
--- * /HELP (<command>) -- Displays some help information about a given command or lists all available commands.
--- * /INFO (<server>)
--- * /INVITE <user> (<#channel>)
--- * /JOIN <#channel> (<key>)
--- * /KICK (<#channel>) <user> (<reason...>)
--- * /KNOCK <#channel> (<message...>)
--- * /LIST (<channels>) (<server>)
--- * /ME [target] <message...>
--- * /MODE (<channel/user>) (<mode>) (<arg>)
--- * /MOTD (<server>)
--- * /MSG <target> <message...> -- Sends a message to target, can be used to send Private messages.
--- * /NAMES (<#channel>)
--- * /NICK <nick>
--- * /NOTICE <#channel/user> <message...>
--- * /PART (<#channel>) (<message...>)
--- * /PING (<user>)
--- * /RECONNECT -- Issues a Quit command to the IRC Server and closes the IRC connection then reconnects to the IRC server. The same as calling ircRestart() in Lua.
--- * /QUIT (<message...>)
--- * /QUOTE <command> (<parameters...>)
--- * /STATS <query> (<server>)
--- * /TIME (<user>)
--- * /TOPIC (<#channel>) (<topic...>)
--- * /TRACE (<target>)
--- * /USERS (<server>)
--- * /VERSION (<user>)
--- * /WHO <mask>
--- * /WHOIS <user>
--- * /WHOWAS <user>
--- 
--- Note:  The following IRC commands are available since Mudlet 3.15:
--- * /MSGLIMIT <limit> (<buffer>) -- Sets the limit for messages to keep in the IRC client message buffers and saves this setting.  If a specific buffer/channel name is given the limit is not saved and applies to the given buffer until the application is closed or the limit is changed again.  For this reason, global settings should be applied first, before settings for specific channels/PM buffers.
function sendIrc(target, message)
end

---  Sends a message via the 102 subchannel back to the MUD (that's used in Aardwolf). The msg is in a two byte format; see the link below to the Aardwolf Wiki for how that works.
--- 
--- ## Example
--- ```lua
--- -- turn prompt flags on:
--- sendTelnetChannel102("\52\1")
--- 
--- -- turn prompt flags off:
--- sendTelnetChannel102("\52\2")
--- ```
--- 
--- To see the list of options that Aardwolf supports go to: [http://www.aardwolf.com/blog/2008/07/10/telnet-negotiation-control-mud-client-interaction/ Using Telnet negotiation to control MUD client interaction].
function sendTelnetChannel102(msg)
end

--- Saves the given channels to disk as the new IRC client channel auto-join configuration. This value is not applied to the current active IRC client until it is restarted with [[Manual:Networking_Functions#restartIrc|restartIrc()]]
--- See also:
--- see: getIrcChannels()
--- see: restartIrc()
--- ## Parameters:
--- * `channels:`
---  A table containing strings which are valid channel names. Any channels in the list which aren't valid are removed from the list. 
--- 
--- Note:  Available in Mudlet 3.3+
--- 
--- ## Example
--- ```lua
--- setIrcChannels( {"#mudlet", "#lua", "irc"} )
--- -- Only the first two will be accepted, as "irc" is not a valid channel name.
--- ```
function setIrcChannels(channels)
end

--- Saves the given nickname to disk as the new IRC client configuration. This value is not applied to the current active IRC client until it is restarted with restartIrc()
--- See also:
--- see: getIrcNick()
--- see: restartIrc()
--- ## Parameters:
--- * `nickname:`
---  A string with your new desired name in IRC.
--- 
--- Note:  Available in Mudlet 3.3+
--- 
--- ## Example
--- ```lua
--- setIrcNick( "Sheldor" )
--- ```
function setIrcNick(nickname)
end

--- Saves the given server's address to disk as the new IRC client connection configuration. These values are not applied to the current active IRC client until it is restarted with restartIrc()
--- See also:
--- see: getIrcServer()
--- see: restartIrc()
--- ## Parameters:
--- * `hostname:`
---  A string containing the hostname of the IRC server.
--- * `port:`
---  (optional) A number indicating the port of the IRC server. Defaults to 6667, if not provided.
--- 
--- Note:  Available in Mudlet 3.3+
--- 
--- ## Example
--- ```lua
--- setIrcServer("chat.freenode.net", 6667)
--- ```
function setIrcServer(hostname, port)
end

---  Sends an [https://en.wikipedia.org/wiki/GET_(HTTP) HTTP GET] request to the given URL. Raises [[Manual:Event_Engine#sysGetHttpDone|sysGetHttpDone]] on success or [[Manual:Event_Engine#sysGetHttpError|sysGetHttpError]] on failure.
--- See also:
--- see: downloadFile()
--- 
--- 
--- ## Parameters:
--- * `url:`
---  Location to send the request to.
--- * `headersTable:`
---  (optional) table of headers to send with your request.
--- 
--- Note:  Available since Mudlet 4.10
--- 
--- ## Examples
--- ```lua
--- function onHttpGetDone(_, url, body)
---   cecho(string.format("<white>url: <dark_green>%s<white>, body: <dark_green>%s", url, body))
--- end
--- 
--- registerAnonymousEventHandler("sysGetHttpDone", onHttpGetDone)
--- 
--- getHTTP("https://httpbin.org/info")
--- getHTTP("https://httpbin.org/are_you_awesome", {["X-am-I-awesome"] = "yep I am"})
--- ```
--- 
--- ```lua
--- -- Status requests typically use GET requests
--- local url = "http://postman-echo.com/status"
--- local header = {["Content-Type"] = "application/json"}
--- 
--- -- first we create something to handle the success, and tell us what we got
--- registerAnonymousEventHandler('sysGetHttpDone', function(event, rurl, response)
---   if rurl == url then display(r) else return true end -- this will show us the response body, or if it's not the right url, then do not delete the handler
--- end, true) -- this sets it to delete itself after it fires
--- -- then we create something to handle the error message, and tell us what went wrong
--- registerAnonymousEventHandler('sysGetHttpError', function(event, response, rurl)
---   if rurl == url then display(r) else return true end -- this will show us the response body, or if it's not the right url, then do not delete the handler
--- end, true) -- this sets it to delete itself after it fires
--- 
--- -- Lastly, we make the request:
--- getHTTP(url, header)
--- 
--- -- Pop this into an alias and try it yourself!
--- ```
function getHTTP(url, headersTable)
end

---  Sends an [https://en.wikipedia.org/wiki/POST_(HTTP) HTTP POST] request to the given URL, either as text or with a specific file you'd like to upload. Raises [[Manual:Event_Engine#sysPostHttpDone|sysPostHttpDone]] on success or [[Manual:Event_Engine#sysPostHttpError|sysPostHttpError]] on failure.
--- See also:
--- see: downloadFile()
--- see: getHTTP()
--- see: putHTTP()
--- see: deleteHTTP()
--- 
--- 
--- ## Parameters:
--- * `dataToSend:`
---  Text to send in the request (unless you provide a file to upload).
--- * `url:`
---  Location to send the request to.
--- * `headersTable:`
---  (optional) table of headers to send with your request.
--- * `file:`
---  (optional) file to upload as part of the POST request. If provided, this will replace 'dataToSend'.
--- 
--- Note:  Available in Mudlet 4.1+
--- 
--- ## Examples
--- ```lua
--- function onHttpPostDone(_, url, body)
---   cecho(string.format("<white>url: <dark_green>%s<white>, body: <dark_green>%s", url, body))
--- end
--- 
--- registerAnonymousEventHandler("sysPostHttpDone", onHttpPostDone)
--- 
--- postHTTP("why hello there!", "https://httpbin.org/post")
--- postHTTP("this us a request with custom headers", "https://httpbin.org/post", {["X-am-I-awesome"] = "yep I am"})
--- postHTTP("https://httpbin.org/post", "<fill in file location to upload here>")
--- ```
--- 
--- ```lua
--- -- This will create a JSON message body. Many modern REST APIs expect a JSON body. 
--- local url = "http://postman-echo.com/post"
--- local data = {message = "I am the banana", user = "admin"}
--- local header = {["Content-Type"] = "application/json"}
--- 
--- -- first we create something to handle the success, and tell us what we got
--- registerAnonymousEventHandler('sysPostHttpDone', function(event, rurl, response)
---   if rurl == url then display(r) else return true end -- this will show us the response body, or if it's not the right url, then do not delete the handler
--- end, true) -- this sets it to delete itself after it fires
--- -- then we create something to handle the error message, and tell us what went wrong
--- registerAnonymousEventHandler('sysPostHttpError', function(event, response, rurl)
---   if rurl == url then display(r) else return true end -- this will show us the response body, or if it's not the right url, then do not delete the handler
--- end, true) -- this sets it to delete itself after it fires
--- 
--- -- Lastly, we make the request:
--- postHTTP(yajl.to_string(data), url, header) -- yajl.to_string converts our Lua table into a JSON-like string so the server can understand it
--- 
--- -- Pop this into an alias and try it yourself!
--- ```
function postHTTP(dataToSend, url, headersTable, file)
end

---  Sends an [https://en.wikipedia.org/wiki/PUT_(HTTP) HTTP PUT] request to the given URL, either as text or with a specific file you'd like to upload. Raises [[Manual:Event_Engine#sysPutHttpDone|sysPutHttpDone]] on success or [[Manual:Event_Engine#sysPutHttpError|sysPutHttpError]] on failure.
--- See also:
--- see: downloadFile()
--- see: getHTTP()
--- see: postHTTP()
--- see: deleteHTTP()
--- 
--- 
--- ## Parameters:
--- * `dataToSend:`
---  Text to send in the request (unless you provide a file to upload).
--- * `url:`
---  Location to send the request to.
--- * `headersTable:`
---  (optional) table of headers to send with your request.
--- * `file:`
---  (optional) file to upload as part of the PUT request. If provided, this will replace 'dataToSend'.
--- 
--- Note:  Available in Mudlet 4.1+
--- 
--- ## Example
--- ```lua
--- function onHttpPutDone(_, url, body)
---   cecho(string.format("<white>url: <dark_green>%s<white>, body: <dark_green>%s", url, body))
--- end
--- 
--- registerAnonymousEventHandler("sysPutHttpDone", onHttpPutDone)
--- putHTTP("this us a request with custom headers", "https://httpbin.org/put", {["X-am-I-awesome"] = "yep I am"})
--- putHTTP("https://httpbin.org/put", "<fill in file location to upload here>")
--- ```
function putHTTP(dataToSend, url, headersTable, file)
end

---  Sends an [https://en.wikipedia.org/wiki/DELETE_(HTTP) HTTP DELETE] request to the given URL. Raises [[Manual:Event_Engine#sysDeleteHttpDone|sysDeleteHttpDone]] on success or [[Manual:Event_Engine#sysDeleteHttpError|sysDeleteHttpError]] on failure.
--- See also:
--- see: downloadFile()
--- see: getHTTP()
--- see: postHTTP()
--- see: putHTTP()
--- 
--- 
--- ## Parameters:
--- * `url:`
---  Location to send the request to.
--- * `headersTable:`
---  (optional) table of headers to send with your request.
--- 
--- Note:  Available in Mudlet 4.1+
--- 
--- ## Example
--- function onHttpDeleteDone(_, url, body)
---   cecho(string.format("<white>url: <dark_green>%s<white>, body: <dark_green>%s", url, body))
--- end
--- 
--- registerAnonymousEventHandler("sysDeleteHttpDone", onHttpDeleteDone)
--- 
--- deleteHTTP("https://httpbin.org/delete")
--- deleteHTTP("https://httpbin.org/delete", {["X-am-I-awesome"] = "yep I am"})
--- ```
function deleteHTTP(url, headersTable)
end

