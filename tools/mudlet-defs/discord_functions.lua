--- 
---   Returns the text used for the Discord Rich Presence detail field. See [https://discordapp.com/developers/docs/rich-presence/how-to#updating-presence-update-presence-payload-fields Discord docs] for a handy image reference on where the detail is shown.
--- 
--- See also:
--- see: setDiscordDetail()
--- Note:   Available since Mudlet 3.14.
--- 
--- ##  Example
--- ```lua
--- print(" Discord detail is: ".. getDiscordDetail())
--- ```
function getDiscordDetail()
end

--- 
---   Returns the large icon name used for the Discord Rich Presence. See [https://discordapp.com/developers/docs/rich-presence/how-to#updating-presence-update-presence-payload-fields Discord docs] for a handy image reference on where the large icon is shown.
--- 
--- See also:
--- see: setDiscordLargeIcon()
--- Note:   Available since Mudlet 3.14.
--- 
--- ##  Example
--- ```lua
--- print(" Discord large icon is: ".. getDiscordLargeIcon())
--- ```
function getDiscordLargeIcon()
end

--- 
---   Returns the text used as a tooltip for the large icon in the Discord Rich Presence. See [https://discordapp.com/developers/docs/rich-presence/how-to#updating-presence-update-presence-payload-fields Discord docs] for a handy image reference on where the large icon is shown.
--- 
--- See also:
--- see: setDiscordLargeIconText()
--- Note:   Available since Mudlet 3.14.
--- 
--- ##  Example
--- ```lua
--- print(" Discord large icon tooltip is: ".. setDiscordLargeIconText())
--- ```
function getDiscordLargeIconText()
end

--- 
---   Returns the current and max party values used in the Discord Rich Presence. See [https://discordapp.com/developers/docs/rich-presence/how-to#updating-presence-update-presence-payload-fields Discord docs] for a handy image reference on where the the party info is shown.
--- 
--- See also:
--- see: setDiscordParty()
--- Note:   Available since Mudlet 3.14.
--- 
--- ##  Example
--- ```lua
--- local currentsize, maxsize = getDiscordParty()
--- print(string.format(" Discord party: %d out of %d", currentsize, maxsize))
--- ```
function getDiscordParty()
end

--- 
---   Returns the small icon name used for the Discord Rich Presence. See [https://discordapp.com/developers/docs/rich-presence/how-to#updating-presence-update-presence-payload-fields Discord docs] for a handy image reference on where the small icon is shown.
--- 
--- See also:
--- see: setDiscordSmallIcon()
--- Note:   Available since Mudlet 3.14.
--- 
--- ##  Example
--- ```lua
--- print(" Discord small icon is: ".. getDiscordSmallIcon())
--- ```
function getDiscordSmallIcon()
end

--- 
---   Returns the text used as a tooltip for the small icon in the Discord Rich Presence. See [https://discordapp.com/developers/docs/rich-presence/how-to#updating-presence-update-presence-payload-fields Discord docs] for a handy image reference on where the small icon is shown.
--- 
--- See also:
--- see: setDiscordSmallIconText()
--- Note:   Available since Mudlet 3.14.
--- 
--- ##  Example
--- ```lua
--- print(" Discord small icon tooltip is: ".. setDiscordSmallIconText())
--- ```
function getDiscordSmallIconText()
end

--- 
---   Returns the text used for the Discord Rich Presence state field. See [https://discordapp.com/developers/docs/rich-presence/how-to#updating-presence-update-presence-payload-fields Discord docs] for a handy image reference on where the state is shown.
--- 
--- See also:
--- see: setDiscordState()
--- Note:   Available since Mudlet 3.14.
--- 
--- ##  Example
--- ```lua
--- print(" Discord state is: ".. getDiscordState())
--- ```
function getDiscordState()
end

--- 
---   Set a custom Discord ID so Discord Rich Presence will show "Playing <your game>" instead of "Playing Mudlet". This function is intended for game authors. Note that you can also set it [[Standards:Discord GMCP|automatically over GMCP]], no pre-installation of scripts required. This will currently (as of Mudlet 4.9.1) bypass the Discord privacy option "Enable Lua API" on future sessions if a non-empty id is specified. Returns true if the Discord application ID is in the correct format.
--- 
---  If you're a game author, you can register your game [https://discordapp.com/developers/applications/ over at Discord] to obtain the "client ID" to be used for this function. Once you do so, make sure to upload the games icon as an art asset under the name of <code>server-icon</code>.
--- 
---  Mudlet calls this the Application ID to avoid confusion with Mudlet being a MUD client - however Discord uses both Application ID and Client ID to refer to this detail (which seems to be an 18 digit number).
--- 
--- ##  Parameters 
--- * `id:`  (required) id as a string.
--- 
--- 
--- 
--- See also:
--- see: setDiscordGame()
--- see: usingMudletsDiscordID()
--- Note:   Available since Mudlet 3.14.
--- 
--- ##  Example
--- ```lua
--- --  set the ID to Mudlets own as an example
--- setDiscordApplicationID("450571881909583884")
--- ```
--- 
--- Note:   So you do not have to remember that long number you can also reset to the default Mudlet ID by calling this function without an argument:
--- ```lua
--- setDiscordApplicationID()
--- ```
function setDiscordApplicationID(id)
end

--- 
---   Sets the text to be shown in the detail field of Discord Rich Presence. See [https://discordapp.com/developers/docs/rich-presence/how-to#updating-presence-update-presence-payload-fields Discord docs] for a handy image reference on where the detail is shown. Note that this will overwrite the same information set by [[#setdiscordgame|setDiscordGame()]].
--- 
--- See also:
--- see: getDiscordDetail()
--- see: setDiscordGame()
--- Note:   To ensure privacy, the detail will only be shown if the Lua API is enabled and the detail is not hidden.
--- 
--- Note:   Available since Mudlet 3.14.
--- 
--- ##  Example
--- ```lua
--- --  set detail to your character name in-game, as an example
--- setDiscordDetail("Vadi")
--- ```
function setDiscordDetail()
end

--- 
---   Sets the time to be shown for "## elapsed" field in Discord Rich Presence. See [https://discordapp.com/developers/docs/rich-presence/how-to#updating-presence-update-presence-payload-fields Discord docs] for a handy image reference on where the elapsed time is shown.
--- 
--- ##  Parameters 
--- * `time:`  (required) time as a [https://en.wikipedia.org/wiki/Unix_time Unix time]. To get the current Unix time in Lua, use <code>os.time(os.date("*t"))</code>.
--- 
--- See also:
--- see: setDiscordRemainingEndTime()
--- Note:   To ensure privacy, the time will only be shown if the Lua API is enabled and the time is not hidden.
--- 
--- Note:   Available since Mudlet 3.14.
--- 
--- ##  Example
--- ```lua
--- --  set the timer to start counting up from now:
--- setDiscordElapsedStartTime(os.time(os.date("*t")))
--- ```
function setDiscordElapsedStartTime(time)
end

--- 
---   Sets the given game to be shown in the "detail" field and the game's icon as the large icon in Discord Rich Presence. See [https://discordapp.com/developers/docs/rich-presence/how-to#updating-presence-update-presence-payload-fields Discord docs] for a handy image reference on where the detail and large icon is shown. This is an alternative way of showing which game you're playing - a better way, if you're the game author, is to use [[Standards:Discord GMCP|GMCP]] (no pre-installation of scripts required) or [[#setdiscordapplicationid|setDiscordApplicationID()]].
--- 
---  Currently supported games are: Achaea, Aetolia, Imperian, Luminari, Lusternia, MidMUD, Starmourn, WoTMUD. To add a new game to the list, [https://www.mudlet.org/contact/ get in touch].
--- 
--- See also:
--- see: setDiscordApplicationID()
--- Note:   To ensure privacy, the game and icon will only be shown if the Lua API is enabled, and detail and large icon are set to show.
--- 
--- Note:   Available since Mudlet 3.14.
--- 
--- ##  Example
--- ```lua
--- setDiscordGame("WoTMUD")
--- ```
function setDiscordGame()
end

--- 
---   Sets the large icon to be shown in Discord Rich Presence. See [https://discordapp.com/developers/docs/rich-presence/how-to#updating-presence-update-presence-payload-fields Discord docs] for a handy image reference the icon is shown.
--- 
---  Icons supported by default in Mudlet: armor, axe, backpack, bow, coin, dagger, envelope, gem-blue, gem-green, gem-red, hammer, heart, helmet, map, shield, tome, tools, wand, wood-sword ([https://opengameart.org/content/fantasy-icon-pack-by-ravenmore-0 icons credit]). To add a new icon to the list, [https://www.mudlet.org/contact/ get in touch] (the Discord limit is 150 icons).
--- 
---  If you're a game author, you can register your own game with Discord and upload your own icons instead of using the ones registered by Mudlet, see [[#setdiscordapplicationid|setDiscordApplicationID()]].
--- 
--- See also:
--- see: getDiscordLargeIcon()
--- see: setDiscordLargeIconText()
--- see: setDiscordApplicationID()
--- Note:   To ensure privacy, the icon will only be shown if the Lua API is enabled and the large icon is not hidden.
--- 
--- Note:   Available since Mudlet 3.14.
--- 
--- ##  Example
--- ```lua
--- setDiscordLargeIcon("coin")
--- setDiscordLargeIconText(" Fishing")
--- setDiscordState(" Fishing")
--- ```
function setDiscordLargeIcon()
end

--- 
---   Sets the tooltip for the large icon in the Discord Rich Presence. See [https://discordapp.com/developers/docs/rich-presence/how-to#updating-presence-update-presence-payload-fields Discord docs] for a handy image reference the large icon is shown.
--- 
--- See also:
--- see: setDiscordLargeIcon()
--- Note:   To ensure privacy, the tooltip will only be shown if the Lua API is enabled, and large icon with the large icon tooltip is set to show.
--- 
--- Note:   Available since Mudlet 3.14.
--- 
--- ##  Example
--- ```lua
--- setDiscordLargeIcon("axe")
--- setDiscordLargeIconText(" Killing heterics")
--- ```
function setDiscordLargeIconText()
end

--- 
---   Sets the party information the Discord Rich Presence. See [https://discordapp.com/developers/docs/rich-presence/how-to#updating-presence-update-presence-payload-fields Discord docs] for a handy image reference the party is shown.
--- 
--- ##  Parameters 
--- * `current:`  (required) current party amount.
--- * `max:`  (optional) max party amount - if not provided, then the max is set to the current amount.
--- 
--- See also:
--- see: getDiscordParty()
--- Note:   To ensure privacy, the party will only be shown if the Lua API is enabled and the party information is not hidden.
--- 
--- Note:   Available since Mudlet 3.14.
--- 
--- ##  Example
--- ```lua
--- --  show that 5 out of 10 people are in currently in the party
--- setDiscordParty(5, 10)
--- ```
function setDiscordParty(current, max)
end

--- 
---   Sets the time to be shown for "## remaining" field in Discord Rich Presence. See [https://discordapp.com/developers/docs/rich-presence/how-to#updating-presence-update-presence-payload-fields Discord docs] for a handy image reference on where the remaining time is shown.
--- 
--- ##  Parameters 
--- * `time:`  (required) time as a [https://en.wikipedia.org/wiki/Unix_time Unix time]. To get the current Unix time in Lua, use <code>os.time(os.date("*t"))</code>.
--- 
--- See also:
--- see: setDiscordElapsedStartTime()
--- Note:   To ensure privacy, the time will only be shown if the Lua API is enabled and the time is not hidden.
--- 
--- Note:   Available since Mudlet 3.14.
--- 
--- ##  Example
--- ```lua
--- --  set the timer to start counting down from an hour from now
--- setDiscordRemainingEndTime(os.time(os.date("*t"))+(60 * 60))
--- ```
function setDiscordRemainingEndTime(time)
end

--- 
---   Sets the small icon to be shown in Discord Rich Presence. See [https://discordapp.com/developers/docs/rich-presence/how-to#updating-presence-update-presence-payload-fields Discord docs] for a handy image reference the icon is shown.
--- 
---  Icons supported by default in Mudlet: armor, axe, backpack, bow, coin, dagger, envelope, gem-blue, gem-green, gem-red, hammer, heart, helmet, map, shield, tome, tools, wand, wood-sword ([https://opengameart.org/content/fantasy-icon-pack-by-ravenmore-0 icons credit]). To add a new icon to the list, [https://www.mudlet.org/contact/ get in touch] (the Discord limit is 150 icons).
--- 
---  If you're a game author, you can register your own game with Discord and upload your own icons instead of using the ones registered by Mudlet, see [[#setdiscordapplicationid|setDiscordApplicationID()]].
--- 
--- See also:
--- see: getDiscordSmallIcon()
--- see: setDiscordSmallIconText()
--- see: setDiscordApplicationID()
--- Note:   To ensure privacy, the icon will only be shown if the Lua API is enabled and the small icon is not hidden.
--- 
--- Note:   Available since Mudlet 3.14.
--- 
--- ##  Example
--- ```lua
--- setDiscordSmallIcon("envelope")
--- setDiscordSmallIconText(" Writing letters")
--- setDiscordState(" Writing letters")
--- ```
function setDiscordSmallIcon()
end

--- 
---   Sets the tooltip for the small icon in the Discord Rich Presence. See [https://discordapp.com/developers/docs/rich-presence/how-to#updating-presence-update-presence-payload-fields Discord docs] for a handy image reference the small icon is shown.
--- 
--- See also:
--- see: setDiscordSmallIcon()
--- Note:   To ensure privacy, the tooltip will only be shown if the Lua API is enabled, and small icon with the small icon tooltip is set to show.
--- 
--- Note:   Available since Mudlet 3.14.
--- 
--- ##  Example
--- ```lua
--- setDiscordSmallIcon("map")
--- setDiscordSmallIconText(" Exploring")
--- ```
function setDiscordSmallIconText()
end

--- 
---   Sets the text to be shown in the state field of Discord Rich Presence. See [https://discordapp.com/developers/docs/rich-presence/how-to#updating-presence-update-presence-payload-fields Discord docs] for a handy image reference on where the state is shown.
--- 
--- See also:
--- see: getDiscordState()
--- see: setDiscordDetail()
--- Note:   To ensure privacy, the state will only be shown if the Lua API is enabled and the state is not hidden.
--- 
--- Note:    Available since Mudlet 3.14.
--- 
--- ##  Example
--- ```lua
--- --  set state to your current area
--- local currentarea = getRoomArea(getPlayerRoom())
--- local areaname = getAreaTableSwap()[currentarea]
--- setDiscordDetail(areaname)
--- ```
--- 
--- 
--- <span id="usingmudletsdiscordid"></span>
function setDiscordState(state)
end

--- 
---   Returns true if the currently playing game is set to "Mudlet". You can change this with [[#setdiscordapplicationid|setDiscordApplicationID()]].
--- 
--- See also:
--- see: setDiscordApplicationID()
--- Note:   Available since Mudlet 3.14.
--- 
--- ##  Example
--- ```lua
--- if usingMudletsDiscordID() then
---   print(' It is showing "Playing Mudlet" right now!')
--- end
--- ```
function usingMudletsDiscordID()
end

