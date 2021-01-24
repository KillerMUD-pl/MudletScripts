--- Adds a telnet option, which when queried by a MUD server, Mudlet will return DO (253) on. Use this to register the telnet option that you will be adding support for with Mudlet - see [[Manual:Supported_Protocols#Adding_support_for_a_telnet_protocol|additional protocols]] section for more.
--- 
--- ## Example:
--- 
--- ```lua
--- <event handlers that add support for MSDP... see http://www.mudbytes.net/forum/comment/63920/#c63920 for an example>
--- 
--- -- register with Mudlet that it should not decline the request of MSDP support
--- local TN_MSDP = 69
--- addSupportedTelnetOption(TN_MSDP)
--- ```
function addSupportedTelnetOption(option)
end

--- alerts the user to something happening - makes Mudlet flash in the Windows window bar, bounce in the macOS dock, or flash on Linux.
--- 
--- Note:  Available in Mudlet 3.2+
--- 
--- ## Parameters
--- * `seconds:`
--- (optional) number of seconds to have the alert for. If not provided, Mudlet will flash until the user opens Mudlet again.
--- 
--- ## Example:
--- 
--- ```lua
--- -- flash indefinitely until Mudlet is open
--- alert()
--- 
--- -- flash for just 3 seconds
--- alert(3)
--- ```
function alert(seconds)
end

--- Like feedTriggers, but you can add color information using color names, similar to cecho.
--- 
--- ## Parameters
--- * `str`: The string to feed to the trigger engine. Include colors by name as black,red,green,yellow,blue,magenta,cyan,white and light_* versions of same. You can also use a number to get the ansi color corresponding to that number.
--- See also:
--- see: feedTriggers()
--- Note:  Available in Mudlet 4.11+
--- 
--- ## Example
--- ```lua
--- cfeedTriggers("<green:red>green on red<r> reset <124:100> foreground of ANSI124 and background of ANSI100<r>\n")
--- ```
function cfeedTriggers(str)
end

--- 
--- Closes Mudlet and all profiles immediately.
--- See also:
--- see: saveProfile()
--- Note:  Use with care. This potentially lead to data loss, if "save on close" is not activated and the user didn't save the profile manually as this will NOT ask for confirmation nor will the profile be saved. Also it does not consider if there are `other` profiles open if multi-playing: they **all** will be closed!
--- 
--- Note:  Available in Mudlet 3.1+
--- 
--- ## Example
--- ```lua
--- closeMudlet()
--- ```
function closeMudlet()
end

--- 
--- Cancels a [[Manual:Lua_Functions#send|send()]] or user-entered command, but only if used within a [[Manual:Event_Engine#sysDataSendRequest|sysDataSendRequest]] event.
--- 
--- ## Example
--- ```lua
--- -- cancels all "eat hambuger" commands
--- function cancelEatHamburger(event, command)
---   if command == "eat hamburger" then
---     denyCurrentSend()
---     cecho("<red>Denied! Didn't let the command through.\n")
---   end
--- end
--- 
--- registerAnonymousEventHandler("sysDataSendRequest", "cancelEatHamburger")
--- ```
function denyCurrentSend()
end

--- Like feedTriggers, but you can add color information using <r,g,b>, similar to decho.
--- 
--- ## Parameters
--- * `str`: The string to feed to the trigger engine. Include color information inside tags like decho.
--- See also:
--- See also:
--- see: cfeedTriggers()
--- see: decho()
--- Note:  Available in Mudlet 4.11+
--- 
--- ## Example
--- ```lua
--- dfeedTriggers("<0,128,0:128,0,0>green on red<r> reset\n")
--- ```
function dfeedTriggers(str)
end

---  Stops syncing the given module.
--- 
--- ## Parameter
--- * `name`: name of the module.
--- 
--- See also:
--- see: enableModuleSync()
--- see: getModuleSync()
function disableModuleSync(name)
end

---  Enables the sync for the given module name - any changes done to it will be saved to disk and if the module is installed in any other profile(s), it'll be updated in them as well on profile save.
--- 
--- ## Parameter
--- * `name`: name of the module to enable sync on.
--- 
--- See also:
--- see: disableModuleSync()
--- see: getModuleSync()
function enableModuleSync(name)
end

--- Runs the command as if it was from the command line - so aliases are checked and if none match, it's sent to the game unchanged. 
--- 
--- ## Parameters
--- * `command`
---  Text of the command you want to send to the game. Will be checked for aliases.
--- * `echoBackToBuffer`
---  (optional) If `false`, the command will not be echoed back in your buffer. Defaults to `true` if omitted.
--- 
--- Note:  Using expandAlias is not recommended anymore as it is not very robust and may lead to problems down the road. The recommendation is to use lua functions instead. See [[Manual:Functions_vs_expandAlias]] for details and examples.
--- 
--- Note:  If you want to be using the `matches` table after calling `expandAlias`, you should save it first, as, e.g. `local oldmatches = matches` before calling `expandAlias`, since `expandAlias` will overwrite it after using it again.
--- 
--- Note:  Since **Mudlet 3.17.1** the optional second argument to echo the command on screen will be ineffective whilst the game server has negotiated the telnet ECHO option to provide the echoing of text we `send` to him.
--- 
--- ## Example
--- ```lua
--- expandAlias("t rat")
--- 
--- -- don't echo the command
--- expandAlias("t rat", false)
--- ```
function expandAlias(command, echoBackToBuffer)
end

--- This function will have Mudlet parse the given text as if it came from the MUD - one great application is trigger testing. The built-in **`echo** alias provides this functionality as well.
--- 
--- ## Parameters
--- * `text:`
--- string which is sent to the trigger processing system almost as if it came from the MUD Game Server. This string must be byte encoded in a manner to match the currently selected `Server Encoding`.  
--- * `dataIsUtf8Encoded:`
--- Set this to false, if you need pre-Mudlet 4.0 behavior. Most players won't need this.
--- (Before Mudlet 4.0 the text had to be encoded directly in whatever encoding the setting in the preferences was set to. 
--- (Encoding could involve using the Lua string character escaping mechanism of \ and a base 10 number for character codes from \1 up to \255 at maximum)
--- Since Mudlet 4.0 it is assumed that the text is UTF-8 encoded. It will then be automatically converted to the currently selected MUD Game Server encoding.
--- Preventing the automatic conversion can be useful to Mudlet developers testing things, or possibly to those who are creating handlers for Telnet protocols within the Lua subsystem, who need to avoid the transcoding of individual protocol bytes, when they might otherwise be seen as extended ASCII characters.)
--- 
--- ## Returns
--- * `true` on success, `nil` and an error message if the text contains characters that cannot be conveyed by the current Game Server encoding.
--- 
--- Note:  Both the optional parameter dataIsUtf8Encoded and the returned value are only available since Mudlet 4.2.0
--- 
--- Note:  The trigger processing system also requires that some data is (or appears to be) received from the game to process the feedTriggers(), so use a send("\n") to get a new prompt (thus new data) right after or ensure that the `text` includes a new-line "\n" character so as to simulate a line of data from the Game Server.
--- 
--- Note:  It is important to ensure that in Mudlet 4.0.0 and beyond the text data only contains characters that can be encoded in the current Game Server encoding, from 4.2.0 the content is checked that it can successfully be converted from the UTF-8 that the Mudlet Lua subsystem uses internally into that particular encoding and if it cannot the function call will fail and not pass any of the data, this will be significant if the text component contains any characters that are not plain ASCII.
--- 
--- ## Example
--- ```lua
--- -- try using this on the command line
--- `echo This is a sample line from the game
--- 
--- -- You can use \n to represent a new line - you also want to use it before and after the text you’re testing, like so:
--- feedTriggers("\nYou sit yourself down.\n")
--- send("\n")
--- 
--- -- The function also accept ANSI color codes that are used in MUDs. A sample table can be found http://codeworld.wikidot.com/ansicolorcodes
--- feedTriggers("\nThis is \27[1;32mgreen\27[0;37m, \27[1;31mred\27[0;37m, \27[46mcyan background\27[0;37m," ..
--- "\27[32;47mwhite background and green foreground\27[0;37m.\n")
--- send("\n")
--- ```
function feedTriggers(text, _dataIsUtf8Encoded)
end

--- 
--- Returns the name entered into the "Character name" field on the Connection Preferences form. Can be used to find out the name that might need to be handled specially in scripts or anything that needs to be personalized to the player. If there is nothing set in that entry will return an empty string.
--- Introduced along with two other functions to enable MUD Game server log-in to be scripted with the simultaneous movement of that functionality from the Mudlet application core code to a predefined `doLogin()` function that may be replaced for more sophisticated requirements.
--- 
--- See also:
--- see: sendCharacterName()
--- see: sendCharacterPassword()
--- Note:  Expected to be available from Mudlet 4.10
--- 
--- ## Example
--- ```lua
--- lua send("cast 'glamor' " .. getCharacterName())
--- 
--- You get a warm feeling passing from your core to the tips of your hands, feet and other body parts.
--- A small twittering bird settles on your shoulder and starts to look adoringly at you.
--- A light brown faun gambles around you and then nuzzles your hand.
--- A tawny long-haired cat saunters over and start to rub itself against your ankles.
--- A small twittering bird settles on your shoulder and starts to look adoringly at you.
--- A light brown faun gambles around you and then nuzzles your hand.
--- A small twittering bird settles on your shoulder and starts to look adoringly at you.
--- A mangy dog trots up to you and proceeds to mark the bottom of your leggings.
--- ```
function getCharacterName()
end

--- 
--- Returns the location of a module on the disk. If the given name does not correspond to an installed module, it'll return <code>nil</code>
--- See also:
--- see: installModule()
--- Note:  Available in Mudlet 3.0+
--- 
--- ## Example
--- ```lua
--- getModulePath("mudlet-mapper")
--- ```
function getModulePath(module_name)
end

--- 
--- Returns the priority of a module as an integer. This determines the order modules will be loaded in - default is 0. Useful if you have a module that depends on another module being loaded first, for example.
--- See also:
--- see: setModulePriority()
--- ## Example
--- ```lua
--- getModulePriority("mudlet-mapper")
--- ```
function getModulePriority(module_name)
end

---  returns false if module sync is not active, true if it is active and nil if module is not found.
--- 
--- ## Parameter
--- * `name`: name of the module
--- 
--- See also:
--- see: enableModuleSync()
--- see: disableModuleSync()
function getModuleSync(name)
end

--- Returns the current home directory of the current profile. This can be used to store data, save statistical information, or load resource files from packages.
--- 
--- Note:  intentionally uses forward slashes <code>/</code> as separators on Windows since [[Manual:UI_Functions#setLabelStyleSheet|stylesheets]] require them.
--- 
--- ## Example
--- ```lua
--- -- save a table
--- table.save(getMudletHomeDir().."/myinfo.dat", myinfo)
--- 
--- -- or access package data. The forward slash works even on Windows fine
--- local path = getMudletHomeDir().."/mypackagename"
--- ```
function getMudletHomeDir()
end

--- Prints debugging information about the Mudlet that you're running - this can come in handy for diagnostics.
--- 
--- Don't use this command in your scripts to find out if certain features are supported in Mudlet - there are better functions available for this.
--- 
--- Note:  Available since Mudlet 4.8+
--- 
--- ## Example
--- ```lua
--- getMudletInfo()
--- ```
function getMudletInfo()
end

--- Returns the current Mudlet version. Note that you shouldn't hardcode against a specific Mudlet version if you'd like to see if a function is present - instead, check for the existence of the function itself. Otherwise, checking for the version can come in handy if you'd like to test for a broken function or so on.
--- 
--- See also:
--- see: mudletOlderThan()
--- Note:  Available since Mudlet 3.0.0-alpha.
--- 
--- ## Parameters
--- * `style:`
--- (optional) allows you to choose what you'd like returned. By default, if you don't specify it, a key-value table with all the values will be returned: major version, minor version, revision number and the optional build name.
--- 
--- ## Values you can choose
--- * `"string"`:
--- Returns the full Mudlet version as text.
--- * `"table"`:
--- Returns the full Mudlet version as four values (multi-return)
--- * `"major"`:
--- Returns the major version number (the first one).
--- * `"minor"`:
--- Returns the minor version number (the second one).
--- * `"revision"`:
--- Returns the revision version number (the third one).
--- * `"build"`:
--- Returns the build of Mudlet (the ending suffix, if any).
--- 
--- ## Example
--- ```lua
--- -- see the full Mudlet version as text:
--- getMudletVersion("string")
--- -- returns for example "3.0.0-alpha"
--- 
--- -- check that the major Mudlet version is at least 3:
--- if getMudletVersion("major") >= 3 then echo("You're running on Mudlet 3+!") end
--- -- but mudletOlderThan() is much better for this:
--- if mudletOlderThan(3) then echo("You're running on Mudlet 3+!") end 
--- 
--- -- if you'd like to see if a function is available however, test for it explicitly instead:
--- if setAppStyleSheet then
---   -- example credit to http://qt-project.org/doc/qt-4.8/stylesheet-examples.html#customizing-qscrollbar
---   setAppStyleSheet[[
---   QScrollBar:vertical {
---       border: 2px solid grey;
---       background: #32CC99;
---       width: 15px;
---       margin: 22px 0 22px 0;
---   }
---   QScrollBar::handle:vertical {
---       background: white;
---       min-height: 20px;
---   }
---   QScrollBar::add-line:vertical {
---       border: 2px solid grey;
---       background: #32CC99;
---       height: 20px;
---       subcontrol-position: bottom;
---       subcontrol-origin: margin;
---   }
---   QScrollBar::sub-line:vertical {
---       border: 2px solid grey;
---       background: #32CC99;
---       height: 20px;
---       subcontrol-position: top;
---       subcontrol-origin: margin;
---   }
---   QScrollBar::up-arrow:vertical, QScrollBar::down-arrow:vertical {
---       border: 2px solid grey;
---       width: 3px;
---       height: 3px;
---       background: white;
---   }
---   QScrollBar::add-page:vertical, QScrollBar::sub-page:vertical {
---       background: none;
---   }
---   ]]
--- end
--- ```
function getMudletVersion(style)
end

--- 
--- Returns the name of the Operating system. Useful for applying particular scripts only under particular operating systems, such as applying a stylesheet only when the OS is Windows. 
--- Returned string will be one of these: "cygwin", "windows", "mac", "linux", "hurd", "freebsd", "kfreebsd", "openbsd", "netbsd", "bsd4", "unix" or "unknown" otherwise.
--- 
--- ## Example
--- ```lua
--- display(getOS())
--- 
--- if getOS() == "windows" then
---   echo("\nWindows OS detected.\n")
--- else
---   echo("\nDetected Operating system is NOT windows.\n")
--- end
--- ```
--- 
--- ## Using getOS() to detect a specific Windows version
--- 
--- ## Example
--- ```lua
--- local os = getOS()
--- if os ~= "windows" then
---   echo("\nToday we'd like to detect only windows version\n")
--- end
--- 
--- -- open command window and send "ver"
--- local f = io.popen("ver") 
--- -- read command output
--- local ver = f:read("*a")
--- -- close the windows (user may see a small flicker on screen)
--- f:close()
--- -- Example output: Microsoft Windows [Version 6.1.7601]
--- -- Output may change due to language settings so use a language indipendent regexp
--- local major = rex.match(ver,"\w+ ([0-9]+)\.[\d\.]+") --
--- if major == nil then 
---   echo("\nNo version detect. Very bad!\n")      
--- else
---   echo("\nVersion is: " .. major .. "!\n") 
--- end
--- ```
function getOS()
end

--- 
--- Returns the name of the profile. Useful when combined with [[Manual:Mudlet_Object_Functions#raiseGlobalEvent|raiseGlobalEvent()]] to know which profile a global event came from.
--- 
--- Note:  Available in Mudlet 3.1+
--- 
--- ## Example
--- ```lua
--- -- if connected to the Achaea profile, will print Achaea to the main console
--- echo(getProfileName())
--- ```
function getProfileName()
end

--- 
--- Returns the command separator in use by the profile.
--- 
--- Note:  Available in Mudlet 3.18+
--- 
--- ## Example
--- ```lua
--- -- if your command separator is ;;, the following would send("do thing 1;;do thing 2"). 
--- -- This way you can determine what it is set to and use that and share this script with 
--- -- someone who has changed their command separator.
--- -- Note: This is not really the preferred way to send this, using sendAll("do thing 1", "do thing 2") is,
--- --       but this illustates the use case.
--- local s = getCommandSeparator()
--- expandAlias("do thing 1" .. s .. "do thing 2")
--- ```
function getCommandSeparator()
end

--- Returns the current server [https://www.w3.org/International/questions/qa-what-is-encoding data encoding] in use.
--- 
--- See also:
--- see: setServerEncoding()
--- see: getServerEncodingsList()
--- ## Example
--- ```lua
--- getServerEncoding()
--- ```
function getServerEncoding()
end

--- Returns an indexed list of the server [https://www.w3.org/International/questions/qa-what-is-encoding data encodings] that Mudlet knows. This is not the list of encodings the servers knows - there's unfortunately no agreed standard for checking that. See [[Manual:Unicode#Changing_encoding|encodings in Mudlet]] for the list of which encodings are available in which Mudlet version.
--- 
--- See also:
--- see: setServerEncoding()
--- see: getServerEncoding()
--- ## Example
--- ```lua
--- -- check if UTF-8 is available:
--- if table.contains(getServerEncodingsList(), "UTF-8") then
---   print("UTF-8 is available!")
--- end
--- ```
function getServerEncodingsList()
end

--- Returns the current [https://docs.microsoft.com/en-us/windows/desktop/Intl/code-page-identifiers codepage] of your Windows system.
--- 
--- {{Note}} Available since Mudlet 3.22
--- {{Note}} This function only works on Windows - It is only needed internally in Mudlet to enable Lua to work with non-ASCII usernames (e.g. Iksiński, Jäger) for the purposes of IO. Linux and macOS work fine with with these out of the box.
--- 
--- ## Example
--- ```lua
--- print(getWindowsCodepage())
--- ```
function getWindowsCodepage()
end

--- Like feedTriggers, but you can add color information using #RRGGBB in hex, similar to hecho.
--- 
--- ## Parameters
--- * `str`: The string to feed to the trigger engine. Include color information in the same manner as hecho.
--- See also:
--- See also:
--- see: dfeedTriggers()
--- see: hecho()
--- Note:  Available in Mudlet 4.11+
--- 
--- ## Example
--- ```lua
--- hfeedTriggers("#008000,800000green on red#r reset\n")
--- ```
function hfeedTriggers(str)
end

--- Installs a Mudlet XML, zip, or mpackage as a module.
--- 
--- ## Parameters
--- * `location:`
--- Exact location of the file install.
--- 
--- See also:
--- see:  uninstallModule()
--- see:  Event: sysLuaInstallModule()
--- ## Example
--- ```lua
--- installModule([[C:\Documents and Settings\bub\Desktop\myalias.xml]])
--- ```
function installModule(location)
end

--- Installs a Mudlet XML or package.
--- 
--- ## Parameters
--- * `location:`
--- Exact location of the xml or package to install.
--- 
--- See also:
--- see:  uninstallPackage()
--- ## Example
--- ```lua
--- installPackage([[C:\Documents and Settings\bub\Desktop\myalias.xml]])
--- ```
function installPackage(location)
end

--- Disables and removes the given event handler.
--- 
--- ## Parameters
--- * `handler id`
--- ID of the event handler to remove as returned by the [[ #registerAnonymousEventHandler | registerAnonymousEventHandler ]] function.
--- 
--- See also:
--- see:  registerAnonymousEventHandler ()
--- Note:  Available in Mudlet 3.5+.
--- ## Example
--- ```lua
--- -- registers an event handler that prints the first 5 GMCP events and then terminates itself
--- 
--- local counter = 0
--- local handlerId = registerAnonymousEventHandler("gmcp", function(_, origEvent)
---   print(origEvent)
---   counter = counter + 1
---   if counter == 5 then
---     killAnonymousEventHandler(handlerId)
---   end
--- end)
--- ```
function killAnonymousEventHandler(handler_id)
end

--- Resets the layout of userwindows (floating miniconsoles) to the last saved state.
--- 
--- See also:
--- see: saveWindowLayout()
--- Note:  Available in Mudlet 3.2+
--- 
--- ## Example
--- ```lua
--- loadWindowLayout()
--- ```
function loadWindowLayout()
end

--- Returns true if Mudlet is older than the given version to check. This is useful if you'd like to use a feature that you can't check for easily, such as coroutines support. However, if you'd like to check if a certain function exists, do not use this and use <code>if mudletfunction then</code> - it'll be much more readable and reliable.
--- 
--- See also:
--- see: getMudletVersion()
--- ## Parameters
--- * `major:`
--- Mudlet major version to check. Given a Mudlet version 3.0.1, 3 is the major version, second 0 is the minor version, and third 1 is the patch version.
--- * `minor:`
--- (optional) minor version to check.
--- * `patch:`
--- (optional) patch version to check.
--- 
--- ## Example
--- ```lua
--- -- stop doing the script of Mudlet is older than 3.2
--- if mudletOlderThan(3,2) then return end
--- 
--- -- or older than 2.1.3
--- if mudletOlderThan(2, 1, 3) then return end
--- 
--- -- however, if you'd like to check that a certain function is available, like getMousePosition(), do this instead:
--- if not getMousePosition then return end
--- 
--- -- if you'd like to check that coroutines are supported, do this instead:
--- if not mudlet.supportscoroutines then return end
--- ```
function mudletOlderThan(major, minor, patch)
end

--- Opens the browser to the given webpage.
--- 
--- ## Parameters
--- * `URL:`
--- Exact URL to open.
--- 
--- ## Example
--- ```lua
--- openWebPage("http://google.com")
--- ```
--- 
--- Note: This function can be used to open a local file or file folder as well by using "file:///" and the file path instead of "http://".
--- 
--- ## Example
--- ```lua
--- openWebPage("file:///"..getMudletHomeDir().."file.txt")
--- ```
function openWebPage(URL)
end

--- This function plays a sound file (no limit on how many you can start).
--- 
--- ## Parameters:
--- * `fileName:`
--- Exact path of the sound file.
--- * `volume:`
--- Set the volume (in percent) of the sound. If no volume is given, 100 (maximum) is used.
--- Optional, available since 3.0
--- 
--- See also:
--- see: stopSounds()
--- ## Example
--- ```lua
--- -- play a sound in Windows
--- playSoundFile([[C:\My folder\boing.wav]])
--- 
--- -- play a sound in Linux
--- playSoundFile([[/home/myname/Desktop/boingboing.wav]])
--- 
--- -- play a sound from a package
--- playSoundFile(getMudletHomeDir().. [[/mypackage/boingboing.wav]])
--- 
--- -- play a sound in Linux at half volume
--- playSoundFile([[/home/myname/Desktop/boingboing.wav]], 50)
--- ```
function playSoundFile(fileName, volume)
end

--- Registers a function to an event handler, not requiring you to set one up via script. [[Manual:Event_Engine#Mudlet-raised_events|See here]] for a list of Mudlet-raised events. The function may be refered to either by name as a string containing a global function name, or with the lua function object itself.
--- 
--- The optional <code>one shot</code> parameter allows you to automatically kill an event handler after it is done by giving a true value. If the event you waited for did not occur yet, return <code>true</code> from the function to keep it registered.
--- 
--- The function returns an ID that can be used in [[Manual:Lua_Functions#killAnonymousEventHandler|killAnonymousEventHandler()]] to unregister the handler again.
--- 
--- If you use an asterisk `("*")` as the event name, your code will capture all events. Useful for debugging, or integration with external programs.
--- 
--- Note:  The ability to refer lua functions directly, the <code>one shot</code> parameter and the returned ID are features of Mudlet 3.5 and above.
--- 
--- Note:  The `"*"` all-events capture was added in Mudlet 4.10.
--- 
--- ## See also
--- [[Manual:Lua_Functions#killAnonymousEventHandler|killAnonymousEventHandler()]], [[Manual:Lua_Functions#raiseEvent|raiseEvent()]],
--- 
--- ## Example
--- ```lua
--- -- example taken from the God Wars 2 (http://godwars2.org) Mudlet UI - forces the window to keep to a certain size
--- function keepStaticSize()
---   setMainWindowSize(1280,720)
--- end -- keepStaticSize
--- 
--- if keepStaticSizeEventHandlerID then killAnonymousEventHandler(keepStaticSizeEventHandlerID) end -- clean up any already registered handlers for this function
--- keepStatisSizeEventHandlerID = registerAnonymousEventHandler("sysWindowResizeEvent", "keepStaticSize") -- register the event handler and save the ID for later killing
--- ```
--- 
--- ```lua
--- -- simple inventory tracker for GMCP enabled games. This version does not leak any of the methods
--- -- or tables into the global namespace. If you want to access it, you should export the inventory
--- -- table via an own namespace.
--- local inventory = {}
--- 
--- local function inventoryAdd()
---   if gmcp.Char.Items.Add.location == "inv" then
---     inventory[#inventory + 1] = table.deepcopy(gmcp.Char.Items.Add.item)
---   end
--- end
--- if inventoryAddHandlerID then killAnonymousEventHandler(inventoryAddHandlerID) end -- clean up any already registered handlers for this function
--- inventoryAddHandlerID = registerAnonymousEventHandler("gmcp.Char.Items.Add", inventoryAdd) -- register the event handler and save the ID for later killing
--- 
--- local function inventoryList()
---   if gmcp.Char.Items.List.location == "inv" then
---     inventory = table.deepcopy(gmcp.Char.Items.List.items)
---   end
--- end
--- if inventoryListHandlerID then killAnonymousEventHandler(inventoryListHandlerID) end -- clean up any already registered handlers for this function
--- inventoryListHandlerID = registerAnonymousEventHandler("gmcp.Char.Items.List", inventoryList) -- register the event handler and save the ID for later killing
--- 
--- local function inventoryUpdate()
---   if gmcp.Char.Items.Remove.location == "inv" then
---     local found
---     local updatedItem = gmcp.Char.Items.Update.item
---     for index, item in ipairs(inventory) do
---       if item.id == updatedItem.id then
---         found = index
---         break
---       end
---     end
---     if found then
---       inventory[found] = table.deepcopy(updatedItem)
---     end
---   end
--- end
--- if inventoryUpdateHandlerID then killAnonymousEventHandler(inventoryUpdateHandlerID) end -- clean up any already registered handlers for this function
--- inventoryUpdateHandlerID = registerAnonymousEventHandler("gmcp.Char.Items.Update", inventoryUpdate)
--- 
--- local function inventoryRemove()
---   if gmcp.Char.Items.Remove.location == "inv" then
---     local found
---     local removedItem = gmcp.Char.Items.Remove.item
---     for index, item in ipairs(inventory) do
---       if item.id == removedItem.id then
---         found = index
---         break
---       end
---     end
---     if found then
---       table.remove(inventory, found)
---     end
---   end
--- end
--- if inventoryRemoveHandlerID then killAnonymousEventHandler(inventoryRemoveHandlerID) end -- clean up any already registered handlers for this function
--- inventoryRemoveHandlerID = registerAnonymousEventHandler("gmcp.Char.Items.Remove", inventoryRemove)
--- ```
--- 
--- ```lua
--- -- downloads a package from the internet and kills itself after it is installed.
--- local saveto = getMudletHomeDir().."/dark-theme-mudlet.zip"
--- local url = "http://www.mudlet.org/wp-content/files/dark-theme-mudlet.zip"
--- 
--- if myPackageInstallHandler then killAnonymousEventHandler(myPackageInstallHandler) end
--- myPackageInstallHandler = registerAnonymousEventHandler(
---   "sysDownloadDone",
---   function(_, filename)
---     if filename ~= saveto then
---       return true -- keep the event handler since this was not our file
---     end
---     installPackage(saveto)
---     os.remove(b)
---   end,
---   true
--- )
--- 
--- downloadFile(saveto, url)
--- cecho("<white>Downloading <green>"..url.."<white> to <green>"..saveto.."\n")
--- ```
function registerAnonymousEventHandler(event_name, functionReference, one_shot)
end

--- Reload a module (by uninstalling and reinstalling).
--- 
--- See also:
--- see: installModule()
--- see: uninstallModule()
--- ## Example
--- ```lua
--- reloadModule("3k-mapper")
--- ```
function reloadModule(module_name)
end

--- 
--- Reloads your entire Mudlet profile - as if you've just opened it. All UI elements will be cleared, so this useful when you're coding your UI.
--- 
--- ## Example
--- ```lua
--- resetProfile()
--- ```
--- 
--- The function used to require input from the game to work, but as of Mudlet 3.20 that is no longer the case.
--- 
--- 
--- Note:  Don't put resetProfile() in the a script-item in the script editor as the script will be reloaded by resetProfile() as well better use 
--- ```lua
--- lua resetProfile()
--- ```
--- in your commandline or make an Alias containing resetProfile().
function resetProfile()
end

--- 
--- Saves the current Mudlet profile to disk, which is equivalent to pressing the "Save Profile" button.
--- 
--- ## Example
--- ```lua
--- saveProfile()
--- ```
function saveProfile()
end

--- Saves the layout of userwindows (floating miniconsoles), in case you'd like to load them again later.
--- 
--- See also:
--- see: loadWindowLayout()
--- Note:  Available in Mudlet 3.2+
--- 
--- ## Example
--- ```lua
--- saveWindowLayout()
--- ```
function saveWindowLayout()
end

--- 
--- Sends the name entered into the "Character name" field on the Connection Preferences form directly to the MUD Game Server. Returns `true` unless there is nothing set in that entry in which case a `nil` and an error message will be returned instead.
--- 
--- Introduced along with two other functions to enable MUD Game server log-in to be scripted with the simultaneous movement of that functionality from the Mudlet application core code to a predefined `doLogin()` function that may be replaced for more sophisticated requirements.
--- See also:
--- see: getCharacterName()
--- see: sendCharacterPassword()
--- Note:  Expected to be available from Mudlet 4.9
function sendCharacterName()
end

--- 
--- Sends the password entered into the "Password" field on the Connection Preferences form directly to the MUD Game Server. Returns `true` unless there is nothing set in that entry or it is too long after (or before) a connection was successfully made in which case a `nil` and an error message will be returned instead.
--- 
--- Introduced along with two other functions to enable MUD Game server log-in to be scripted with the simultaneous movement of that functionality from the Mudlet application core code to a predefined `doLogin()` function, reproduced below, that may be replaced for more sophisticated requirements.
--- See also:
--- see: getCharacterName()
--- see: sendCharacterName()
--- Note:  Expected to be available from Mudlet 4.9 
--- 
--- ## Example
--- ```lua
--- -- The default function placed into LuaGlobal.lua to reproduce the previous behavior of the Mudlet application:
--- function doLogin()
---   if getCharacterName() ~= "" then
---     tempTime(2.0, [[sendCharacterName()]], 1)
---     tempTime(3.0, [[sendCharacterPassword()]], 1)
---   end
--- end
--- ```
function sendCharacterPassword()
end

--- 
--- Sends given binary data as-is to the MUD. You can use this to implement support for a [[Manual:Supported_Protocols#Adding_support_for_a_telnet_protocol|new telnet protocol]], [http://forums.mudlet.org/viewtopic.php?f=5&t=2272 simultronics] [http://forums.mudlet.org/viewtopic.php?f=5&t=2213#p9810 login] or etcetera.
--- 
--- ## Example
--- ```lua
--- TN_IAC = 255
--- TN_WILL = 251
--- TN_DO = 253
--- TN_SB = 250
--- TN_SE = 240
--- TN_MSDP = 69
--- 
--- MSDP_VAL = 1
--- MSDP_VAR = 2
--- 
--- sendSocket( string.char( TN_IAC, TN_DO, TN_MSDP ) ) -- sends IAC DO MSDP
--- 
--- --sends: IAC  SB MSDP MSDP_VAR "LIST" MSDP_VAL "COMMANDS" IAC SE
--- local msg = string.char( TN_IAC, TN_SB, TN_MSDP, MSDP_VAR ) .. " LIST " ..string.char( MSDP_VAL ) .. " COMMANDS " .. string.char( TN_IAC, TN_SE )
--- sendSocket( msg )
--- ```
--- 
--- {{Note}} Remember that should it be necessary to send the byte value of 255 as a `data` byte and not as the Telnet **IAC** value it is required to repeat it for Telnet to ignore it and not treat it as the latter.
function sendSocket(data)
end

--- Makes Mudlet merge the table of the given GMCP or MSDP module instead of overwriting the data. This is useful if the game sends only partial updates which need combining for the full data. By default "Char.Status" is the only merged module.
--- 
--- ## Parameters
--- * `module:`
--- Name of the GMCP or MSDP module that should be merged as a string.
--- 
--- ## Example
--- ```lua
--- setMergeTables("Char.Skills", "Char.Vitals")
--- ```
function setMergeTables(module)
end

--- 
--- Sets the module priority on a given module as a number - the module priority determines the order modules are loaded in, which can be helpful if you have ones dependent on each other. This can also be set from the module manager window.
--- See also:
--- see: getModulePriority()
--- ```lua
--- setModulePriority("mudlet-mapper", 1)
--- ```
function setModulePriority(moduleName, priority)
end

--- Makes Mudlet use the specified [https://www.w3.org/International/questions/qa-what-is-encoding encoding] for communicating with the game.
--- 
--- ## Parameters
--- * `encoding:`
--- Encoding to use.
--- 
--- See also:
--- see: getServerEncodingsList()
--- see: getServerEncoding()
--- ## Example
--- ```lua
--- -- use UTF-8 if Mudlet knows it. Unfortunately there's no way to check if the game's server knows it too.
--- if table.contains(getServerEncodingsList(), "UTF-8") then
---   setServerEncoding("UTF-8")
--- end
--- ```
function setServerEncoding(encoding)
end

--- 
--- Spawns a process and opens a communicatable link with it - `read function` is the function you'd like to use for reading output from the process, and `t` is a table containing functions specific to this connection - `send(data)`, `true/false = isRunning()`, and `close()`.
--- 
--- This allows you to setup RPC communication with another process.
--- 
--- ## Examples
--- ```lua
--- -- simple example on a program that quits right away, but prints whatever it gets using the 'display' function
--- local f = spawn(display, "ls")
--- display(f.isRunning())
--- f.close()
--- ```
--- ```lua
--- local f = spawn(display, "ls", "-la")
--- display(f.isRunning())
--- f.close()
--- ```
function spawn(readFunction, processToSpawn, _...arguments)
end

--- 
--- Control logging of the main console text as text or HTML (as specified by the "Save log files in HTML format instead of plain text" setting on the "General" tab of the "Profile preferences" or "Settings" dialog).  Despite being called startLogging it can also stop the process and correctly close the file being created. The file will have an extension of type ".txt" or ".html" as appropriate and the name will be in the form of a date/time "yyyy-MM-dd#hh-mm-ss" using the time/date of when logging started.  Note that this control parallels the corresponding icon in the "bottom buttons" for the profile and that button can also start and stop the same logging process and will reflect the state as well.
--- 
--- ## Parameters
--- * `state:`
--- Required: logging state. Passed as a boolean
--- 
--- ## Returns (4 values)
--- * `successful (bool)`
--- `true` if the logging state actually changed; if, for instance, logging was already active and `true` was supplied then no change in logging state actually occurred and `nil` will be returned (and logging will continue).
--- * `fileName (string)`
--- The log will be/is being written to the path/file name returned.
--- * `message (string)`
--- A displayable message given one of four messages depending on the current and previous logging states, this will include the file name except for the case when logging was not taking place and the supplied argument was also `false`.
--- * `code (number)`
--- A value indicating the response to the system to this instruction:
---   *  0 = logging has just stopped
---   *  1 = logging has just started
---   * -1 = logging was already in progress so no change in logging state
---   * -2 = logging was already not in progress so no change in logging state
--- 
--- ## Example
--- ```lua
--- -- start logging
--- startLogging(true)
--- 
--- -- stop logging
--- startLogging(false)
--- ```
function startLogging(state)
end

--- 
--- Stops all currently playing sounds.
--- 
--- Note:  Available in Mudlet 3.0.
--- 
--- See also:
--- see: playSoundFile()
--- ## Example
--- ```lua
--- stopSounds()
--- ```
function stopSounds()
end

--- 
--- A utility function that helps you change and track variable states without using a lot of tempTimers.
--- 
--- Note:  Available in Mudlet 3.6+
--- 
--- ## Parameters
--- * `vname:`
--- A string or function to use as the variable placeholder.
--- * `true_time:`
--- Time before setting the variable to true. Can be a number or a table in the format: <code>{time, value}</code>
--- * `nil_time:`
--- (optional) Number of seconds until <code>vname</code> is set back to nil. Leaving it undefined will leave it at whatever it was set to last. Can be a number of a table in the format: <code>{time, value}</code>
--- * `...:`
--- (optional) Further list of times and values to set the variable to, in the following format: <code>{time, value}</code>
--- 
--- ## Example
--- ```lua
--- -- sets the global 'limiter' variable to true immediately (see the 0) and back to nil in one second (that's the 1).
--- timeframe("limiter", 0, 1)
--- 
--- -- An angry variable 'giant' immediately set to "fee", followed every second after by "fi", "fo", and "fum" before being reset to nil at four seconds.
--- timeframe("giant", {0, "fee"}, 4, {1, "fi"}, {2, "fo"}, {3, "fum"})
--- 
--- -- sets the local 'width' variable to true immediately and back to nil in one second.
--- local width
--- timeframe(function(value) width = value end, 0, 1)
--- ```
function timeframe(vname, true_time, nil_time, ...)
end

--- 
--- Given a table of directions (such as <code>speedWalkDir</code>), translates directions to another language for you. Right now, it can only translate it into the language of Mudlet's user interface - but [https://github.com/Mudlet/Mudlet/issues/new let us know if you need more].
--- 
--- Note:  Available in Mudlet 3.22+
--- 
--- ## Parameters
--- * `directions:`
--- An indexed table of directions (eg. <code>{"sw", "w", "nw", "s"}</code>).
--- * `languagecode:`
--- (optional) Language code (eg <code>ru_RU</code> or <code>it_IT</code>) - by default, <code>mudlet.translations.interfacelanguage</code> is used.
--- 
--- ## Example
--- ```lua
--- -- get the path from room 2 to room 5 and translate directions
--- if getPath(2, 5) then
--- speedWalkDir = translateTable(speedWalkDir)
--- print("Translated directions:")
--- display(speedWalkDir)
--- ```
function translateTable(directions, languagecode)
end

--- 
--- Uninstalls a Mudlet module with the given name.
--- 
--- See also:
--- see:  installModule()
--- see:  Event: sysLuaUninstallModule()
--- ## Example
--- ```lua
--- uninstallModule("myalias")
--- ```
function uninstallModule(name)
end

--- 
--- Uninstalls a Mudlet package with the given name.
--- 
--- See also:
--- see:  installPackage()
--- ## Example
--- ```lua
--- uninstallPackage("myalias")
--- ```
function uninstallPackage(name)
end

--- 
--- Unzips the zip file at path, extracting the contents to the location provided. Returns true if it is able to start unzipping, or nil+message if it cannot
--- Raises the <code>sysUnzipDone</code> event with the zip file location and location unzipped to as arguments if unzipping is successful, and <code>sysUnzipError</code> with the same arguments if it is not.
--- 
--- Note: Available since Mudlet 4.6
--- 
--- ## Example
--- ```lua
--- function handleUnzipEvents(event, ...)
---   local args = {...}
---   local zipName = args[1]
---   local unzipLocation = args[2]
---   if event == "sysUnzipDone" then
---     cecho(string.format("<green>Unzip successful! Unzipped %s to %s\n", zipName, unzipLocation))
---   elseif event == "sysUnzipError" then
---     cecho(string.format("<firebrick>Unzip failed! Tried to unzip %s to %s\n", zipName, unzipLocation))
---   end
--- end
--- if unzipSuccessHandler then killAnonymousEventHandler(unzipSuccessHandler) end
--- if unzipFailureHandler then killAnonymousEventHandler(unzipFailureHandler) end
--- unzipSuccessHandler = registerAnonymousEventHandler("sysUnzipDone", "handleUnzipEvents")
--- unzipFailureHandler = registerAnonymousEventHandler("sysUnzipError", "handleUnzipEvents")
--- --use the path to your zip file for this, not mine
--- local zipFileLocation = "/home/demonnic/Downloads/Junkyard_Orc.zip" 
--- --directory to unzip to, it does not need to exist but you do need to be able to create it
--- local unzipLocation = "/home/demonnic/Downloads/Junkyard_Orcs" 
--- unzipAsync(zipFileLocation, unzipLocation) -- this will work
--- unzipAsync(zipFileLocation .. "s", unzipLocation) --demonstrate error, will happen first because unzipping takes time```
function unzipAsync(path, location)
end

--- 
--- Encodes a Lua table into JSON data and returns it as a string. This function is very efficient - if you need to encode into JSON, use this.
--- 
--- ## Example
--- ```lua
--- -- on IRE MUDs, you can send a GMCP request to request the skills in a particular skillset. Here's an example:
--- sendGMCP("Char.Skills.Get "..yajl.to_string{group = "combat"})
--- 
--- -- you can also use it to convert a Lua table into a string, so you can, for example, store it as room's userdata
--- local toserialize = yajl.to_string(continents)
--- setRoomUserData(1, "areaContinents", toserialize)
--- ```
function yajl.to_string(data)
end

--- 
--- Decodes JSON data (as a string) into a Lua table. This function is very efficient - if you need to dencode into JSON, use this.
--- 
--- ## Example
--- ```lua
--- -- given the serialization example above with yajl.to_string, you can deserialize room userdata back into a table
--- local tmp = getRoomUserData(1, "areaContinents")
--- if tmp == "" then return end
--- 
--- local continents = yajl.to_value(tmp)
--- display(continents)
--- ```
function yajl.to_value(data)
end

