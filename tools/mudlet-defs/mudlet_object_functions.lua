---  Adjusts the elapsed time on the stopwatch forward or backwards by the amount of time. It will work even on stopwatches that are not running, and thus can be used to preset a newly created stopwatch with a negative amount so that it runs down from a negative time towards zero at the preset time.
--- 
--- ## Parameters
--- * watchID (number) / watchName (string): The stopwatch ID you get with [[Manual:Lua_Functions#createStopWatch|createStopWatch()]] or the name given to that function or later set with [[Manual:Lua_Functions#setStopWatchName|setStopWatchName()]].
--- * amount (decimal number): An amount in seconds to adjust the stopwatch by, positive amounts increase the recorded elapsed time.
--- 
--- ## Returns
--- * true on success if the stopwatch was found and thus adjusted, or nil and an error message if not.
--- 
--- ## Example
--- ```lua
--- -- demo of a persistent stopWatch used to real time a mission
--- -- called with a positive number of seconds it will start a "missionStopWatch"
--- -- unless there already is one in which case it will instead report on
--- -- the deadline. use 'stopStopWatch("missionStopWatch")' when the mission
--- -- is done and 'deleteStopWatch("missionStopWatch")' when the existing mission
--- -- is to be disposed of. Until then repeated use of 'mission(interval)' will
--- -- just give updates...
--- function mission(time)
---   local missionTimeTable = missionTimeTable or {}
--- 
---   if createStopWatch("missionStopWatch") then
---     adjustStopWatch("missionStopWatch", -tonumber(time))
---     setStopWatchPersistence("missionStopWatch", true)
---     missionTimeTable = getStopWatchBrokenDownTime("missionStopWatch")
--- 
---     echo(string.format("Get cracking, you have %02i:%02i:%02i hg:m:s left.\n", missionTimeTable.hours, missionTimeTable.minutes, missionTimeTable.seconds))
---     startStopWatch("missionStopWatch")
---   else
---     -- it already exists, so instead report what is/was the time on it
---     --[=[ We know that the stop watch exists - we just need to find the ID
---       so we can get the running detail which is only available from the getStopWatches()
---       table and that is indexed by ID]=]
---     for k,v in pairs(getStopWatches()) do
---       if v.name == "missionStopWatch" then
---         missionTimeTable = v
---       end
---     end
---     if missionTimeTable.isRunning then
---       if missionTimeTable.elapsedTime.negative then
---         echo(string.format("Better hurry up, the clock is ticking on an existing mission and you only have %02i:%02i:%02i h:m:s left.\n", missionTimeTable.elapsedTime.hours, missionTimeTable.elapsedTime.minutes, missionTimeTable.elapsedTime.seconds))
---       else
---         echo(string.format("Bad news, you are past the deadline on an existing mission by %02i:%02i:%02i h:m:s !\n", missionTimeTable.elapsedTime.hours, missionTimeTable.elapsedTime.minutes, missionTimeTable.elapsedTime.seconds))
---       end
---     else
---       if missionTimeTable.elapsedTime.negative then
---         echo(string.format("Well done! You have already completed a mission %02i:%02i:%02i h:m:s before the deadline ...\n", missionTimeTable.elapsedTime.hours, missionTimeTable.elapsedTime.minutes, missionTimeTable.elapsedTime.seconds))
---       else
---         echo(string.format("Uh oh! You failed to meet the deadline on an existing mission by %02i:%02i:%02i h:m:s !\n", missionTimeTable.elapsedTime.hours, missionTimeTable.elapsedTime.minutes, missionTimeTable.elapsedTime.seconds))
---       end
---     end
---   end
--- end
--- ```
--- 
--- Note:  Available from Mudlet 4.4.0
function adjustStopWatch(watchID/watchName, amount)
end

---  Appends Lua code to the script "scriptName". If no occurrence given it sets the code of the first found script.
--- 
--- See also:
--- see: permScript()
--- see: enableScript()
--- see: disableScript()
--- see: getScript()
--- see: setScript()
--- ## Returns
--- * a unique id number for that script.
--- 
--- ## Parameters
--- * `scriptName`: name of the script
--- * `luaCode`: scripts luaCode to append
--- * `occurence`: (optional) the occurrence of the script in case you have many with the same name
--- 
--- ## Example
--- ```lua
--- -- an example of appending the script lua code to the first occurrence of "testscript"
--- appendScript("testscript", [[echo("This is a test\n")]], 1)
--- ```
--- Note:  Available from Mudlet 4.8+
function appendScript(scriptName, luaCode, occurrence)
end

---  Appends text to the main input line.
--- See also:
--- see: printCmdLine()
--- ## Parameters
--- * `name`: (optional) name of the command line. If not given, the text will be appended to the main commandline.
--- * `text`: text to append
--- 
--- 
--- ## Example
--- ```lua
--- -- adds the text "55 backpacks" to whatever is currently in the input line
--- appendCmdLine("55 backpacks")
--- 
--- -- makes a link, that when clicked, will add "55 backpacks" to the input line
--- echoLink("press me", "appendCmdLine'55 backpack'", "Press me!")
--- 
--- 
--- -- in use:
--- lua mission(60*60)
--- Get cracking, you have 01:00:00 h:m:s left.
--- 
--- lua mission(60*60)
--- Better hurry up, the clock is ticking on an existing mission and you only have 00:59:52 h:m:s left.
--- ```
function appendCmdLine(name, text)
end

---  Clears the input line of any text that's been entered.
--- See also:
--- see: printCmdLine()
--- ## Parameters
--- * `name`: (optional) name of the command line. If not given, the main commandline's text will be cleared.
--- 
--- ## Example
--- ```lua
--- -- don't be evil with this!
--- clearCmdLine()
--- ```
function clearCmdLine(name)
end

--- From Mudlet 4.4.0:
--- ## createStopWatch([start immediately {assumed `true` if omitted}])
--- ## createStopWatch([name], [start immediately {assumed `false` if omitted}])
--- 
---  This function creates a stopwatch, a high resolution time measurement tool. Stopwatches can be started, stopped, reset, asked how much time has passed since the stop watch has been started and, following an update for Mudlet 4.4.0: be adjusted, given a name and be made persistent between sessions (so can time real-life things). Prior to 4.4.0 the function took no parameters **and the stopwatch would start automatically when it was created**.
--- 
--- ## Parameters:
--- * `start immediately` (bool) used to override the behaviour prior to Mudlet 4.4.0 so that if it is the `only` argument then a `false` value will cause the stopwatch to be created but be in a `stopped` state, however if a name parameter is provided then this behaviour is assumed and then a `true` value is required should it be desired for the stopwatch to be started on creation. This difference between the cases with and without a name argument is to allow for older scripts to continue to work with 4.4.0 or later versions of Mudlet without change, yet to allow for more functionality - such as presetting a time when the stopwatch is created but not to start it counting down until some time afterwards - to be performed as well with a named stopwatch.
--- 
--- * `name` (string) a `unique` text to use to identify the stopwatch.
--- 
--- ## Returns:
--- * the ID (number) of a stopwatch; or, from **4.4.0**: a nil + error message if the name has already been used.
--- 
--- See also:
--- see: startStopWatch()
--- see: stopStopWatch()
--- see: resetStopWatch()
--- see: getStopWatchTime()
--- see: adjustStopWatch()
--- see: deleteStopWatch()
--- see: getStopWatches()
--- see: getStopWatchBrokenDownTime()
--- see: setStopWatchName()
--- see: setStopWatchPersistence()
--- ## Example
---  (Prior to Mudlet 4.4.0) in a global script you can create all stop watches that you need in your system and store the respective stopWatch-IDs in global variables:
--- ```lua
--- fightStopWatch = fightStopWatch or createStopWatch() -- create, or re-use a stopwatch, and store the watchID in a global variable to access it from anywhere
--- 
--- -- then you can start the stop watch in some trigger/alias/script with:
--- startStopWatch(fightStopWatch)
--- 
--- -- to stop the watch and measure its time in e.g. a trigger script you can write:
--- fightTime = stopStopWatch(fightStopWatch)
--- echo("The fight lasted for " .. fightTime .. " seconds.")
--- resetStopWatch(fightStopWatch)
--- ```
--- 
---  (From Mudlet 4.4.0) in a global script you can create all stop watches that you need in your system with unique names:
--- ```lua
--- createStopWatch("fightStopWatch") -- this will fail if the given named stopwatch already exists so it will create it if needed
--- 
--- -- then you can start the stop watch (if it is not already started) in some trigger/alias/script with:
--- startStopWatch("fightStopWatch")
--- 
--- -- to stop the watch and measure its time in e.g. a trigger script you can write:
--- fightTime = stopStopWatch("fightStopWatch")
--- echo("The fight lasted for " .. fightTime .. " seconds.")
--- resetStopWatch("fightStopWatch")
--- ```
--- 
--- You can also measure the elapsed time without having to stop the stop watch (equivalent to getting a `lap-time`) with [[#getStopWatchTime|getStopWatchTime()]].
--- 
--- Note:  it's best to re-use stopwatch IDs if you can for Mudlet prior to 4.4.0 as they cannot be deleted, so creating more and more would use more memory. From 4.4.0 the revised internal design has been changed such that there are no internal timers created for each stopwatch - instead either a timestamp or a fixed elapsed time record is used depending on whether the stopwatches is running or stopped so that there are no "moving parts" in the later design and less resources are used - and they can be removed if no longer required.
function createStopWatch()
end

--- 
---  This function removes an existing stopwatch, whether it only exists for this session or is set to be otherwise saved between sessions by using [[Manual:Lua_Functions#setStopWatchPersistence|setStopWatchPersistence()]] with a `true` argument.  
--- 
--- ## Parameters
--- * `watchID` (number) / `watchName` (string): The stopwatch ID you get with [[Manual:Lua_Functions#createStopWatch|createStopWatch()]] or the name given to that function or later set with [[Manual:Lua_Functions#setStopWatchName|setStopWatchName()]].
--- 
--- ## Returns:
--- * `true` if the stopwatch was found and thus deleted, or `nil` and an error message if not - obviously using it twice with the same argument will fail the second time unless another one with the same name or ID was recreated before the second use.  Note that an empty string as a name `will` find the lowest ID numbered `unnamed` stopwatch and that will then find the next lowest ID number of unnamed ones until there are none left, if used repetitively!
--- 
--- ```lua
--- lua MyStopWatch = createStopWatch("stopwatch_mine")
--- true
--- 
--- lua display(MyStopWatch)
--- 4
--- 
--- lua deleteStopWatch(MyStopWatch)
--- true
--- 
--- lua deleteStopWatch(MyStopWatch)
--- nil
--- 
--- "stopwatch with id 4 not found"
--- 
--- lua deleteStopWatch("stopwatch_mine")
--- nil
--- 
--- "stopwatch with name "stopwatch_mine" not found"
--- ```
--- 
--- See also:
--- see: createStopWatch()
--- Note:  Available from Mudlet version 4.4.0. Stopwatches that are NOT set to be **persistent** will be deleted automatically at the end of a session (or if [[Manual:Miscellaneous_Functions#resetProfile|resetProfile()]] is called).
function deleteStopWatch(watchID/watchName)
end

--- Disables/deactivates the alias by its name. If several aliases have this name, they'll all be disabled. If you disable an alias group, all the aliases inside the group will be disabled as well.
--- See also:
--- see: enableAlias()
--- ## Parameters
--- * `name:`
---  The name of the alias. Passed as a string.
--- 
--- ## Examples
--- ```lua
--- --Disables the alias called 'my alias'
--- disableAlias("my alias")
--- ```
function disableAlias(name)
end

--- Disables key a key (macro) or a key group. When you disable a key group, all keys within the group will be implicitly disabled as well.
--- 
--- See also:
--- see: enableKey()
--- ## Parameters
--- * `name:`
---  The name of the key or group to identify what you'd like to disable.
--- 
--- ## Examples
--- 
--- ```lua
--- -- you could set multiple keys on the F1 key and swap their use as you wish by disabling and enabling them
--- disableKey("attack macro")
--- disableKey("jump macro")
--- enableKey("greet macro")
--- ```
--- Note:  From Version **3.10` returns `true` if one or more keys or groups of keys were found that matched the name given or `false` if not; prior to then it returns `true` if there were **any** keys - whether they matched the name or not!
function disableKey(name)
end

--- Disables a script that was previously enabled. Note that disabling a script only stops it from running in the future - it won't "undo" anything the script has made, such as labels on the screen.
--- 
--- See also:
--- see: permScript()
--- see: appendScript()
--- see: enableScript()
--- see: getScript()
--- see: setScript()
--- ## Parameters
--- * `name`: name of the script.
--- 
--- ## Example
--- ```lua
--- --Disables the script called 'my script'
--- disableScript("my script")
--- ```
--- Note:  Available from Mudlet 4.8+
function disableScript(name)
end

--- Disables a timer from running it’s script when it fires - so the timer cycles will still be happening, just no action on them. If you’d like to permanently delete it, use [[Manual:Lua_Functions#killTrigger|killTrigger]] instead.
--- 
--- See also:
--- see: enableTimer()
--- ## Parameters
--- * `name:`
---  Expects the timer ID that was returned by [[Manual:Lua_Functions#tempTimer|tempTimer]] on creation of the timer or the name of the timer in case of a GUI timer.
--- 
--- ## Example
--- ```lua
--- --Disables the timer called 'my timer'
--- disableTimer("my timer")
--- ```
function disableTimer(name)
end

--- Disables a permanent (one in the trigger editor) or a temporary trigger. When you disable a group, all triggers inside the group are disabled as well
--- 
--- See also:
--- see: enableTrigger()
--- ## Parameters
--- * `name:`
---  Expects the trigger ID that was returned by [[Manual:Lua_Functions#tempTrigger|tempTrigger]] or other temp*Trigger variants, or the name of the trigger in case of a GUI trigger.
--- 
--- ## Example
--- ```lua
--- -- Disables the trigger called 'my trigger'
--- disableTrigger("my trigger")
--- ```
function disableTrigger(name)
end

--- Enables/activates the alias by it’s name. If several aliases have this name, they’ll all be enabled.
--- 
--- See also:
--- see: disableAlias()
--- ## Parameters
--- * `name:`
---  Expects the alias ID that was returned by [[Manual:Lua_Functions#tempAlias|tempAlias]] on creation of the alias or the name of the alias in case of a GUI alias.
--- 
--- ## Example
--- ```lua
--- --Enables the alias called 'my alias'
--- enableAlias("my alias")
--- ```
function enableAlias(name)
end

--- Enables a key (macro) or a group of keys (and thus all keys within it that aren't explicitly deactivated).
--- 
--- ## Parameters
--- * `name:`
---  The name of the group that identifies the key.
--- 
--- ```lua
--- -- you could use this to disable one key set for the numpad and activate another
--- disableKey("fighting keys")
--- enableKey("walking keys")
--- ```
--- Note:  From Version **3.10` returns `true` if one or more keys or groups of keys were found that matched the name given or `false` if not; prior to then it returns `true` if there were **any** keys - whether they matched the name or not!
function enableKey(name)
end

--- Enables / activates a script that was previously disabled. 
--- 
--- See also:
--- see: permScript()
--- see: appendScript()
--- see: disableScript()
--- see: getScript()
--- see: setScript()
--- ## Parameters
--- * `name`: name of the script.
--- ```lua
--- -- enable the script called 'my script' that you created in Mudlet's script section
--- enableScript("my script")
--- ```
--- Note:  Available from Mudlet 4.8+
function enableScript(name)
end

--- Enables or activates a timer that was previously disabled. 
--- 
--- ## Parameters
--- * `name:`
---  Expects the timer ID that was returned by [[Manual:Lua_Functions#tempTimer|tempTimer]] on creation of the timer or the name of the timer in case of a GUI timer.
--- ```lua
--- -- enable the timer called 'my timer' that you created in Mudlets timers section
--- enableTimer("my timer")
--- ```
--- 
--- ```lua
--- -- or disable & enable a tempTimer you've made
--- timerID = tempTimer(10, [[echo("hi!")]])
--- 
--- -- it won't go off now
--- disableTimer(timerID)
--- -- it will continue going off again
--- enableTimer(timerID)
--- ```
function enableTimer(name)
end

--- Enables or activates a trigger that was previously disabled. 
--- 
--- ## Parameters
--- * `name:`
---  Expects the trigger ID that was returned by [[Manual:Lua_Functions#tempTrigger|tempTrigger]] or by any other temp*Trigger variants, or the name of the trigger in case of a GUI trigger.
--- ```lua
--- -- enable the trigger called 'my trigger' that you created in Mudlets triggers section
--- enableTrigger("my trigger")
--- ```
--- 
--- ```lua
--- -- or disable & enable a tempTrigger you've made
--- triggerID = tempTrigger("some text that will match in a line", [[echo("hi!")]])
--- 
--- -- it won't go off now when a line with matching text comes by
--- disableTrigger(triggerID)
--- 
--- -- and now it will continue going off again
--- enableTrigger(triggerID)
--- ```
function enableTrigger(name)
end

--- Tells you how many things of the given type exist. 
--- 
--- Note:  This function is only for objects created in the script editor or via perm* functions. You don't need it for temp* functions and will not work for them.
--- 
--- ## Parameters
--- * `name:`
---  The name or the id returned by the temp* function to identify the item.
--- * `type:`
---  The type can be 'alias', 'trigger', 'timer', 'keybind' (Mudlet 3.2+), or 'script' (Mudlet 3.17+).
--- 
--- ## Example
--- ```lua
--- echo("I have " .. exists("my trigger", "trigger") .. " triggers called 'my trigger'!")
--- ```
--- 
---  You can also use this alias to avoid creating duplicate things, for example:
--- ```lua
--- -- this code doesn't check if an alias already exists and will keep creating new aliases
--- permAlias("Attack", "General", "^aa$", [[send ("kick rat")]])
--- 
--- -- while this code will make sure that such an alias doesn't exist first
--- -- we do == 0 instead of 'not exists' because 0 is considered true in Lua
--- if exists("Attack", "alias") == 0 then
---     permAlias("Attack", "General", "^aa$", [[send ("kick rat")]])
--- end
--- ```
--- 
---  Especially helpful when working with [[Manual:Lua_Functions#permTimer|permTimer]]:
--- ```lua
--- if not exists("My animation timer", "timer") then
---   vdragtimer = permTimer("My animation timer", "", .016, onVDragTimer) -- 60fps timer!
--- end
---  
--- enableTimer("My animation timer")
--- ```
function exists(name, type)
end

--- This function can be used within checkbox button scripts (2-state buttons) to determine the current state of the checkbox.
--- 
--- Returns `2` if button is checked, and `1` if it's not.
--- 
--- ## Example
--- ```lua
--- local checked = getButtonState()
--- if checked == 1 then
---     hideExits()
--- else
---     showExits()
--- end
--- ```
function getButtonState()
end

---  Returns the current content of the given command line.
--- See also:
--- see: printCmdLine()
--- ## Parameters
--- * `name`: (optional) name of the command line. If not given, it returns the text of the main commandline.
--- 
--- 
--- ## Example
--- ```lua
--- -- replaces whatever is currently in the input line by "55 backpacks"
--- printCmdLine("55 backpacks")
--- 
--- --prints the text "55 backpacks" to the main console
--- echo(getCmdLine())
--- ```
--- 
--- Note:  Available in Mudlet 3.1+
function getCmdLine(name)
end

--- 
---  Returns a table of the details for each stopwatch in existence, the keys are the watch IDs but since there can be gaps in the ID number allocated for the stopwatches it will be necessary to use the `pairs(...)` rather than the `ipairs(...)` method to iterate through all of them in `for` loops!
---  Each stopwatch's details will list the following items: `name` (string), `isRunning` (boolean), `isPersistent` (boolean), `elapsedTime` (table).  The last of these contains the same data as is returned by the results table from the [[Manual:Lua_Functions#getStopWatchBrokenDownTime|getStopWatchBrokenDownTime()]] function - namely `days` (positive integer), `hours` (integer, 0 to 23), `minutes` (integer, 0 to 59), `second` (integer, 0 to 59), `milliSeconds` (integer, 0 to 999), `negative` (boolean) with an additional `decimalSeconds` (number of seconds, with a decimal portion for the milli-seconds and possibly a negative sign, representing the whole elapsed time recorded on the stopwatch) - as would also be returned by the [[Manual:Lua_Functions#getStopWatchTime|getStopWatchTime()]] function.
--- 
--- ## Example
--- ```lua
--- -- on the command line:
--- lua getStopWatches()
--- -- could return something like:
--- {
---   {
---     isPersistent = true,
---     elapsedTime = {
---       minutes = 15,
---       seconds = 2,
---       negative = false,
---       milliSeconds = 66,
---       hours = 0,
---       days = 18,
---       decimalSeconds = 1556102.066
---     },
---     name = "Playing time",
---     isRunning = true
---   },
---   {
---     isPersistent = true,
---     elapsedTime = {
---       minutes = 47,
---       seconds = 1,
---       negative = true,
---       milliSeconds = 657,
---       hours = 23,
---       days = 2,
---       decimalSeconds = -258421.657
---     },
---     name = "TMC Vote",
---     isRunning = true
---   },
---   {
---     isPersistent = false,
---     elapsedTime = {
---       minutes = 26,
---       seconds = 36,
---       negative = false,
---       milliSeconds = 899,
---       hours = 3,
---       days = 0,
---       decimalSeconds = 12396.899
---     },
---     name = "",
---     isRunning = false
---   },
---   [5] = {
---     isPersistent = false,
---     elapsedTime = {
---       minutes = 0,
---       seconds = 38,
---       negative = false,
---       milliSeconds = 763,
---       hours = 0,
---       days = 0,
---       decimalSeconds = 38.763
---     },
---     name = "",
---     isRunning = true
---   }
--- }
--- ```
--- 
--- Note:  Available from Mudlet 4.4.0 only.
function getStopWatches()
end

---  Returns the time as a decimal number of seconds with up to three decimal places to give a milli-seconds (thousandths of a second) resolution.
---  Please note that, prior to 4.4.0 it was not possible to retrieve the elapsed time after the stopwatch had been stopped, retrieving the time was not possible as the returned value then was an indeterminate, meaningless time; from the 4.4.0 release, however, the elapsed value can be retrieved at any time, even if the stopwatch has not been started since creation or modified with the [[Manual:Lua_Functions#adjustStopWatch|adjustStopWatch()]] function introduced in that release.
--- 
--- See also:
--- see: createStopWatch()
--- see: startStopWatch()
--- see: stopStopWatch()
--- see: deleteStopWatch()
--- see: getStopWatches()
--- see: getStopWatchBrokenDownTime()
--- Returns a number
--- 
--- ## Parameters
--- * `watchID`
---  The ID number of the watch.
--- 
--- ## Example
--- ```lua
--- -- an example of showing the time left on the stopwatch
--- teststopwatch = teststopwatch or createStopWatch()
--- startStopWatch(teststopwatch)
--- echo("Time on stopwatch: "..getStopWatchTime(teststopwatch))
--- tempTimer(1, [[echo("Time on stopwatch: "..getStopWatchTime(teststopwatch))]])
--- tempTimer(2, [[echo("Time on stopwatch: "..getStopWatchTime(teststopwatch))]])
--- stopStopWatch(teststopwatch)
--- ```
function getStopWatchTime(watchID_or_watchName_from_Mudlet_4.4.0)
end

---  Returns the current stopwatch time, whether the stopwatch is running or is stopped, as a table, broken down into:
--- * "days" (integer)
--- * "hours" (integer, 0 to 23)
--- * "minutes" (integer, 0 to 59)
--- * "seconds" (integer, 0 to 59)
--- * "milliSeconds" (integer, 0 to 999)
--- * "negative" (boolean, true if value is less than zero)
--- 
--- See also:
--- see: startStopWatch()
--- see: stopStopWatch()
--- see: deleteStopWatch()
--- see: getStopWatches()
--- see: getStopWatchTime()
--- ## Parameters
--- * `watchID` / `watchName`
---  The ID number or the name of the watch.
--- 
--- ## Example
--- ```lua
--- --an example, showing the presetting of a stopwatch.
--- 
--- --This will fail if the stopwatch with the given name
--- -- already exists, but then we can use the existing one:
--- local watchId = createStopWatch("TopMudSiteVoteStopWatch")
--- if watchId ~= nil then
---   -- so we have just created the stopwatch, we want it
---   -- to be saved for future sessions:
---   setStopWatchPersistence("TopMudSiteVoteStopWatch", true)
---   -- and set it to count down the 12 hours until we can
---   -- revote:
---   adjustStopWatch("TopMudSiteVoteStopWatch", -60*60*12)
---   -- and start it running
---   startStopWatch("TopMudSiteVoteStopWatch")
--- 
---   openWebPage("http://www.topmudsites.com/vote-wotmud.html")
--- end
--- 
--- --[[ now I can check when it is time to vote again, even when
--- I stop the session and restart later by running the following
--- from a perm timer - perhaps on a 15 minute interval. Note that
--- when loaded in a new session the Id it gets is unlikely to be
--- the same as that when it was created - but that is not a
--- problem as the name is preserved and, if the timer is running
--- when the profile is saved at the end of the session then the
--- elapsed time will continue to increase to reflect the real-life
--- passage of time:]]
--- 
--- local voteTimeTable = getStopWatchBrokenDownTime("TopMudSiteVoteStopWatch")
--- 
--- if voteTimeTable["negative"] then
---   if voteTimeTable["hours"] == 0 and voteTimeTable["minutes"] < 30 then
---     echo("Voting for WotMUD on Top Mud Site in " .. voteTimeTable["minutes"] .. " minutes...")
---   end
--- else
---   echo("Oooh, it is " .. voteTimeTable["days"] .. " days, " .. voteTimeTable["hours"] .. " hours and " .. voteTimeTable["minutes"] .. " minutes past the time to Vote on Top Mud Site - doing it now!")
---   openWebPage("http://www.topmudsites.com/vote-wotmud.html")
---   resetStopWatch("TopMudSiteVoteStopWatch")
---   adjustStopWatch("TopMudSiteVoteStopWatch", -60*60*12)
--- end
--- ```
--- 
--- Note:  Available from Mudlet 4.7+
function getStopWatchBrokenDownTime(watchID_or_watchName)
end

---  Returns the script with the given name. If you have more than one script with the same name, specify the occurrence to pick a different one. Returns -1 if the script doesn't exist.
--- 
--- See also:
--- see: permScript()
--- see: enableScript()
--- see: disableScript()
--- see: setScript()
--- see: appendScript()
--- ## Parameters
--- * `scriptName`: name of the script.
--- * `occurrence`: (optional) occurence of the script in case you have many with the same name.
--- 
--- ## Example
--- ```lua
--- -- show the "New script" on screen
--- print(getScript("New script"))
--- 
--- -- an example of returning the script Lua code from the second occurrence of "testscript"
--- test_script_code = getScript("testscript", 2)
--- ```
--- Note:  Available from Mudlet 4.8+
function getScript(scriptName, occurrence)
end

--- Opens a file chooser dialog, allowing the user to select a file or a folder visually. The function returns the selected path or "" if there was none chosen.
--- 
--- ## Parameters
--- * `fileOrFolder:` `true` for file selection, `false` for folder selection.
--- * `dialogTitle`: what to say in the window title.
--- 
--- ## Examples
--- ```lua
--- function whereisit()
---   local path = invokeFileDialog(false, "Where should we save the file? Select a folder and click Open")
--- 
---   if path == "" then return nil else return path end
--- end
--- ```
function invokeFileDialog(fileOrFolder, dialogTitle)
end

--- You can use this function to check if something, or somethings, are active. 
--- Returns the number of active things - and 0 if none are active. Beware that all numbers are true in Lua, including zero.
--- 
--- ## Parameters
--- * `name:`
---  The name or the id returned by temp* function to identify the item.
--- * `type:`
---  The type can be 'alias', 'trigger', 'timer', 'keybind' (Mudlet 3.2+), or 'script' (Mudlet 3.17+).
--- 
--- ## Example
--- ```lua
--- echo("I have " .. isActive("my trigger", "trigger") .. " currently active trigger(s) called 'my trigger'!")
--- ```
function isActive(name, type)
end

--- Returns true or false depending on if the line at the cursor position is a prompt. This infallible feature is available for MUDs that supply GA events (to check if yours is one, look to bottom-right of the main window - if it doesn’t say <No GA>, then it supplies them).
--- 
--- Example use could be as a Lua function, making closing gates on a prompt real easy.
--- 
--- ## Example
--- ```lua
--- -- make a trigger pattern with 'Lua function', and this will trigger on every prompt!
--- return isPrompt()
--- ```
function isPrompt()
end

--- Deletes a temporary alias with the given ID.
--- 
--- ## Parameters
--- * `aliasID:`
---  The id returned by [[Manual:Lua_Functions#tempAlias|tempAlias]] to identify the alias.
--- 
--- ```lua
--- -- deletes the alias with ID 5
--- killAlias(5)
--- ```
function killAlias(aliasID)
end

--- Deletes a keybinding with the given name. If several keybindings have this name, they'll all be deleted.
--- 
--- ## Parameters
--- * `name:`
---  The name or the id returned by [[Manual:Lua_Functions#tempKey|tempKey]] to identify the key.
--- 
--- Note:  Available in Mudlet 3.2+
--- 
--- ```lua
--- -- make a temp key
--- local keyid = tempKey(mudlet.key.F8, [[echo("hi!")]])
--- 
--- -- delete the said temp key
--- killKey(keyid)
--- ```
function killKey(name)
end

--- Deletes a [[Manual:Lua_Functions#tempTimer|tempTimer]].
--- 
--- Note:  Non-temporary timers that you have set up in the GUI or by using [[#permTimer|permTimer]] cannot be deleted with this function. Use [[Manual:Lua_Functions#disableTimer|disableTimer()]] and [[Manual:Lua_Functions#enableTimer|enableTimer()]] to turn them on or off.
--- 
--- ## Parameters
--- * `id:` the ID returned by [[Manual:Lua_Functions#tempTimer|tempTimer]].
--- 
---  Returns true on success and false if the timer id doesn’t exist anymore (timer has already fired) or the timer is not a temp timer.
--- 
--- ## Example
--- ```lua
--- -- create the timer and remember the timer ID
--- timerID = tempTimer(10, [[echo("hello!")]])
--- 
--- -- delete the timer
--- if killTimer(timerID) then echo("deleted the timer") else echo("timer is already deleted") end
--- ```
function killTimer(id)
end

--- Deletes a [[Manual:Lua_Functions#tempTimer|tempTrigger]], or a trigger made with one of the `temp<type>Trigger()` functions.
--- 
--- Note:  When used in out of trigger contexts, the triggers are disabled and deleted upon the next line received from the game - so if you are testing trigger deletion within an alias, the 'statistics' window will be reporting trigger counts that are disabled and pending removal, and thus are no cause for concern.
--- 
--- ## Parameters
--- * `id:`
---  The ID returned by [[Manual:Lua_Functions#tempTimer|tempTimer]] to identify the item. ID is a string and not a number.
--- 
--- Returns true on success and false if the trigger id doesn’t exist anymore (trigger has already fired) or the trigger is not a temp trigger.
function killTrigger(id)
end

--- 
--- Creates a persistent alias that stays after Mudlet is restarted and shows up in the Script Editor.
--- 
--- ## Parameters
--- * `name:`
---  The name you’d like the alias to have.
--- * `parent:` 
---  The name of the group, or another alias you want the trigger to go in - however if such a group/alias doesn’t exist, it won’t do anything. Use "" to make it not go into any groups.
--- * `regex:`
---  The pattern that you’d like the alias to use.
--- * `lua code:` 
---  The script the alias will do when it matches.
--- ## Example
--- ```lua
--- -- creates an alias called "new alias" in a group called "my group"
--- permAlias("new alias", "my group", "^test$", [[echo ("say it works! This alias will show up in the script editor too.")]])
--- ```
--- 
--- Note:  Mudlet by design allows duplicate names - so calling permAlias with the same name will keep creating new aliases. You can check if an alias already exists with the [[Manual:Lua_Functions#exists|exists]] function.
function permAlias(name, parent, regex, lua_code)
end

--- 
--- Creates a new group of a given type at the root level (not nested in any other groups). This group will persist through Mudlet restarts. 
--- ## Parameters
--- * `name:`
---  The name of the new group item you want to create.
--- * `itemtype:`
---  The type of the item, can be trigger, alias, timer, or script.
--- * `parent:`
---  (optional) Name of existing item which the new item will be created as a child of.
--- 
--- ## Example
--- ```lua
--- --create a new trigger group
--- permGroup("Combat triggers", "trigger")
--- 
--- --create a new alias group only if one doesn't exist already
--- if exists("Defensive aliases", "alias") == 0 then
---   permGroup("Defensive aliases", "alias")
--- end
--- ```
--- 
--- {{Note}} Added to Mudlet in the 2.0 final release. Parameter `parent` available in Mudlet 3.1+
--- {{Note}} Itemtype script is available from Mudlet 4.7+
function permGroup(name, itemtype, parent)
end

--- Creates a persistent trigger for the in-game prompt that stays after Mudlet is restarted and shows up in the Script Editor.
--- 
--- Note:  If the trigger is not working, check that the **N:** bottom-right has a number. This feature requires telnet Go-Ahead (GA) or End-of-Record (EOR) to be enabled in your game. Available in Mudlet 3.6+
--- 
--- ## Parameters:
--- * `name` is the name you’d like the trigger to have.
--- * `parent` is the name of the group, or another trigger you want the trigger to go in - however if such a group/trigger doesn’t exist, it won’t do anything. Use "" to make it not go into any groups.
--- * `lua code` is the script the trigger will do when it matches.
--- 
--- ## Example: 
--- ```lua
--- permPromptTrigger("echo on prompt", "", [[echo("hey! this thing is working!\n")]])
--- ```
function permPromptTrigger(name, parent, lua_code)
end

--- Creates a persistent trigger with one or more `regex` patterns that stays after Mudlet is restarted and shows up in the Script Editor.
--- 
--- ## Parameters
--- * `name` is the name you’d like the trigger to have.
--- * `parent` is the name of the group, or another trigger you want the trigger to go in - however if such a group/trigger doesn’t exist, it won’t do anything. Use "" to make it not go into any groups.
--- * `pattern table` is a table of patterns that you’d like the trigger to use - it can be one or many.
--- * `lua code` is the script the trigger will do when it matches.
--- ## Example
--- ```lua
--- -- Create a regex trigger that will match on the prompt to record your status
--- permRegexTrigger("Prompt", "", {"^(\d+)h, (\d+)m"}, [[health = tonumber(matches[2]); mana = tonumber(matches[3])]])
--- ```
--- Note:  Mudlet by design allows duplicate names - so calling permRegexTrigger with the same name will keep creating new triggers. You can check if a trigger already exists with the [[Manual:Lua_Functions#exists|exists()]] function.
function permRegexTrigger(name, parent, pattern_table, lua_code)
end

--- Creates a persistent trigger that stays after Mudlet is restarted and shows up in the Script Editor. The trigger will go off whenever one of the `regex` patterns it's provided with matches. The function returns the trigger ID for subsequent [[Manual:Lua_Functions#enableTrigger|enableTrigger()]], [[Manual:Lua_Functions#disableTrigger|disableTrigger()]] and [[Manual:Lua_Functions#killTrigger|killTrigger()]] calls.
--- 
--- ## Parameters
--- * `name` is the name you’d like the trigger to have.
--- * `parent` is the name of the group, or another trigger you want the trigger to go in - however if such a group/trigger doesn’t exist, it won’t do anything. Use "" to make it not go into any groups.
--- * `pattern table` is a table of patterns that you’d like the trigger to use - it can be one or many.
--- * `lua code` is the script the trigger will do when it matches.
--- 
--- ## Examples
--- ```lua
--- -- Create a trigger that will match on anything that starts with "You sit" and do "stand".
--- -- It will not go into any groups, so it'll be on the top.
--- permBeginOfLineStringTrigger("Stand up", "", {"You sit"}, [[send ("stand")]])
--- 
--- -- Another example - lets put our trigger into a "General" folder and give it several patterns.
--- permBeginOfLineStringTrigger("Stand up", "General", {"You sit", "You fall", "You are knocked over by"}, [[send ("stand")]])
--- ```
--- Note:  Mudlet by design allows duplicate names - so calling permBeginOfLineStringTrigger with the same name will keep creating new triggers. You can check if a trigger already exists with the [[Manual:Lua_Functions#exists|exists()]] function.
function permBeginOfLineStringTrigger(name, parent, pattern_table, lua_code)
end

--- Creates a persistent trigger with one or more `substring` patterns that stays after Mudlet is restarted and shows up in the Script Editor.
--- ## Parameters
--- * `name` is the name you’d like the trigger to have.
--- * `parent` is the name of the group, or another trigger you want the trigger to go in - however if such a group/trigger doesn’t exist, it won’t do anything. Use "" to make it not go into any groups.
--- * `pattern table` is a table of patterns that you’d like the trigger to use - it can be one or many.
--- * `lua code` is the script the trigger will do when it matches.
--- ## Example
--- ```lua
--- -- Create a trigger to highlight the word "pixie" for us
--- permSubstringTrigger("Highlight stuff", "General", {"pixie"},
--- [[selectString(line, 1) bg("yellow") resetFormat()]])
--- 
--- -- Or another trigger to highlight several different things
--- permSubstringTrigger("Highlight stuff", "General", {"pixie", "cat", "dog", "rabbit"},
--- [[selectString(line, 1) fg ("blue") bg("yellow") resetFormat()]])
--- ```
--- Note:  Mudlet by design allows duplicate names - so calling permSubstringTrigger with the same name will keep creating new triggers. You can check if a trigger already exists with the [[Manual:Lua_Functions#exists|exists()]] function.
function permSubstringTrigger(_name, parent, pattern_table, lua_code_)
end

---  Creates a new script in the Script Editor that stays after Mudlet is restarted.
--- 
--- ## Parameters
--- * `name`: name of the script.
--- * `parent`: name of the script group you want the script to go in.
--- * `lua code`: is the code with string you are putting in your script.
--- 
--- ## Returns
--- * a unique id number for that script.
--- 
--- See also:
--- see: enableScript()
--- see: exists()
--- see: appendScript()
--- see: disableScript()
--- see: getScript()
--- see: setScript()
--- ## Example:
--- ```lua
--- -- create a script in the "first script group" group
--- permScript("my script", "first script group", [[send ("my script that's in my first script group fired!")]])
--- -- create a script that's not in any group; just at the top
--- permScript("my script", "", [[send ("my script that's in my first script group fired!")]])
--- 
--- -- enable Script - a script element is disabled at creation
--- enableScript("my script")
--- ```
--- 
--- Note:  The script is called once but NOT active after creation, it will need to be enabled by [[#enableScript|enableScript()]].
--- 
--- Note:  Mudlet by design allows duplicate names - so calling permScript with the same name will keep creating new script elements. You can check if a script already exists with the [[Manual:Lua_Functions#exists|exists()]] function.
--- Note:  Available from Mudlet 4.8+
function permScript(name, parent, lua_code)
end

---  Creates a persistent timer that stays after Mudlet is restarted and shows up in the Script Editor.
--- 
--- ## Parameters
--- * `name` 
--- name of the timer.
--- * `parent` 
--- name of the timer group you want the timer to go in.
--- * `seconds` 
--- a floating point number specifying a delay in seconds after which the timer will do the lua code (stored as the timer's "script") you give it as a string.
--- * `lua code` is the code with string you are doing this to.
--- 
--- ## Returns
--- * a unique id number for that timer.
--- 
--- ## Example:
--- ```lua
--- -- create a timer in the "first timer group" group
--- permTimer("my timer", "first timer group", 4.5, [[send ("my timer that's in my first timer group fired!")]])
--- -- create a timer that's not in any group; just at the top
--- permTimer("my timer", "", 4.5, [[send ("my timer that's in my first timer group fired!")]])
--- 
--- -- enable timer - they start off disabled until you're ready
--- enableTimer("my timer")
--- ```
--- 
--- Note:  The timer is NOT active after creation, it will need to be enabled by a call to [[#enableTimer|enableTimer()]] before it starts.
--- 
--- Note:  Mudlet by design allows duplicate names - so calling permTimer with the same name will keep creating new timers. You can check if a timer already exists with the [[Manual:Lua_Functions#exists|exists()]] function.
function permTimer(name, parent, seconds, lua_code)
end

---  Creates a persistent key that stays after Mudlet is restarted and shows up in the Script Editor.
--- 
--- ## Parameters
--- * `name` 
--- name of the key.
--- * `parent` 
--- name of the timer group you want the timer to go in or "" for the top level.
--- * `modifier` 
--- (optional) modifier to use - can be one of `mudlet.keymodifier.Control`, `mudlet.keymodifier.Alt`, `mudlet.keymodifier.Shift`, `mudlet.keymodifier.Meta`, `mudlet.keymodifier.Keypad`, or `mudlet.keymodifier.GroupSwitch` or the default value of `mudlet.keymodifier.None` which is used if the argument is omitted. To use multiple modifiers, add them together: `(mudlet.keymodifier.Shift + mudlet.keymodifier.Control)`
--- * `key code` 
---  actual key to use - one of the values available in `mudlet.key`, e.g. `mudlet.key.Escape`, `mudlet.key.Tab`, `mudlet.key.F1`, `mudlet.key.A`, and so on. The list is a bit long to list out in full so it is [https://github.com/Mudlet/Mudlet/blob/development/src/mudlet-lua/lua/KeyCodes.lua#L2 available here].
---  set to -1 if you want to create a key folder instead.
--- * `lua code'
---  code you would like the key to run.
--- 
--- ## Returns
--- * a unique id number for that key.
--- 
--- Note:  Available in Mudlet 3.2+, creating key folders in Mudlet 4.10+
--- 
--- ## Example:
--- ```lua
--- -- create a key at the top level for F8
--- permKey("my key", "", mudlet.key.F8, [[echo("hey this thing actually works!\n")]])
--- 
--- -- or Ctrl+F8
--- permKey("my key", "", mudlet.keymodifier.Control, mudlet.key.F8, [[echo("hey this thing actually works!\n")]])
--- 
--- -- Ctrl+Shift+W
--- permKey("jump keybinding", "", mudlet.keymodifier.Control + mudlet.keymodifier.Shift, mudlet.key.W, [[send("jump")]])
--- ```
--- 
--- Note:  Mudlet by design allows duplicate names - so calling permKey with the same name will keep creating new keys. You can check if a key already exists with the [[Manual:Lua_Functions#exists|exists()]] function.  The key will be created even if the lua code does not compile correctly - but this will be apparent as it will be seen in the Editor.
function permKey(name, parent, modifier, key_code, lua_code)
end

--- 
---  Replaces the current text in the input line, and sets it to the given text.
--- See also:
--- see: clearCmdLine()
--- ## Parameters
--- * `name`: (optional) name of the command line. If not given, main commandline's text will be set.
--- * `text`: text to set
--- 
--- ```lua
--- printCmdLine("say I'd like to buy ")
--- ```
function printCmdLine(name, text)
end

--- 
---  Raises the event event_name. The event system will call the main function (the one that is called exactly like the script name) of all such scripts in this profile that have registered event handlers. If an event is raised, but no event handler scripts have been registered with the event system, the event is ignored and nothing happens. This is convenient as you can raise events in your triggers, timers, scripts etc. without having to care if the actual event handling has been implemented yet - or more specifically how it is implemented. Your triggers raise an event to tell the system that they have detected a certain condition to be true or that a certain event has happened. How - and if - the system is going to respond to this event is up to the system and your trigger scripts don’t have to care about such details. For small systems it will be more convenient to use regular function calls instead of events, however, the more complicated your system will get, the more important events will become because they help reduce complexity very much.
--- 
--- The corresponding event handlers that listen to the events raised with raiseEvent() need to use the script name as function name and take the correct number of arguments. 
--- 
--- Note:  possible arguments can be string, number, boolean, table, function, or nil.
--- 
--- ## Example:
--- 
--- raiseEvent("fight") a correct event handler function would be: myScript( event_name ). In this example raiseEvent uses minimal arguments, name the event name. There can only be one event handler function per script, but a script can still handle multiple events as the first argument is always the event name - so you can call your own special handlers for individual events. The reason behind this is that you should rather use many individual scripts instead of one huge script that has all your function code etc. Scripts can be organized very well in trees and thus help reduce complexity on large systems.
--- 
--- Where the number of arguments that your event may receive is not fixed you can use [http://www.lua.org/manual/5.1/manual.html#2.5.9 `...`] as the last argument in the `function` declaration to handle any number of arguments. For example:
--- 
--- ```lua
--- -- try this function out with "lua myscripthandler(1,2,3,4)"
--- function myscripthandler(a, b, ...)
---   print("Arguments a and b are: ", a,b)
---   -- save the rest of the arguments into a table
---   local otherarguments = {...}
---   print("Rest of the arguments are:")
---   display(otherarguments)
--- 
---   -- access specific otherarguments:
---   print("First and second otherarguments are: ", otherarguments[1], otherarguments[2])
--- end
--- ```
function raiseEvent(event_name, arg-1, …_arg-n)
end

--- 
---  Like [[Manual:Lua_Functions#raiseEvent|raiseEvent()]] this raises the event "event_name", but this event is sent to all **other** opened profiles instead. The profiles receive the event in circular alphabetical order (if profile "C" raised this event and we have profiles "A", "C", and "E", the order is "E" -> "A", but if "E" raised the event the order would be "A" -> "C"); execution control is handed to the receiving profiles so that means that long running events may lock up the profile that raised the event.
--- 
---  The sending profile's name is automatically appended as the last argument to the event.
--- 
--- ## Example:
--- 
--- ```lua
--- -- from profile called "My MUD" this raises an event "my event" with additional arguments 1, 2, 3, "My MUD" to all profiles except the original one
--- raiseGlobalEvent("my event", 1, 2, 3)
--- ```
--- 
--- {{Note}} Available since Mudlet 3.1.0.
--- 
--- Tip: you might want to add the [[Manual:Miscellaneous_Functions#getProfileName|profile name]] to your plain [[Manual:Miscellaneous_Functions#raiseEvent|raiseEvent()]] arguments. This'll help you tell which profile your event came from similar to [[#raiseGlobalEvent|raiseGlobalEvent()]].
function raiseGlobalEvent(event_name, arg-1, …_arg-n)
end

--- 
---  Returns the remaining time in floating point form in seconds (if it is active) for the timer (temporary or permanent) with the id number or the (first) one found with the name.
---  If the timer is inactive or has expired or is not found it will return a `nil` and an `error message`. It, theoretically could also return 0 if the timer is overdue, i.e. it has expired but the internal code has not yet been run but that has not been seen in during testing. Permanent `offset timers` will only show as active during the period when they are running after their parent has expired and started them.
--- 
--- {{Note}} Available in Mudlet since 3.20.
--- 
--- ## Example:
--- 
--- ```lua
--- tid = tempTimer(600, [[echo("\nYour ten minutes are up.\n")]])
--- echo("\nYou have " .. remainingTime(tid) .. " seconds left, use it wisely... \n")
--- 
--- -- Will produce something like:
--- 
--- You have 599.923 seconds left, use it wisely... 
--- 
--- -- Then ten minutes time later:
--- 
--- Your ten minutes are up.
--- 
--- ```
function remainingTime(timer_id_number_or_name)
end

---  Resets the profile's icon in the connection screen to default.
--- 
--- See also:
--- see: setProfileIcon()
--- {{Note}} Available in Mudlet 4.0+.
--- 
--- ## Example:
--- 
--- ```lua
--- resetProfileIcon()
--- ```
function resetProfileIcon()
end

--- This function resets the time to 0:0:0.0, but does not start the stop watch. You can start it with [[Manual:Lua_Functions#startStopWatch | startStopWatch]] → [[Manual:Lua_Functions#createStopWatch | createStopWatch]]
function resetStopWatch(watchID)
end

--- Sets the maximum number of lines a buffer (main window or a miniconsole) can hold. Default is 10,000.
--- 
--- ## Parameters
--- * `consoleName:`
---  (optional) The name of the window. If omitted, uses the main console.
--- * `linesLimit:`
---  Sets the amount of lines the buffer should have. 
--- Note:  Mudlet performs extremely efficiently with even huge numbers, but there is of course a limit to your computer's memory. As of Mudlet 4.7+, this amount will be capped to that limit on macOS and Linux (on Windows, it's capped lower as Mudlet on Windows is 32bit).
--- * `sizeOfBatchDeletion:`
---  Specifies how many lines should Mudlet delete at once when you go over the limit - it does it in bulk because it's efficient to do so.
--- 
--- ## Example
--- ```lua
--- -- sets the main windows size to 1 million lines maximum - which is more than enough!
--- setConsoleBufferSize("main", 1000000, 1000)
--- ```
function setConsoleBufferSize(consoleName, linesLimit, sizeOfBatchDeletion)
end

--- Set a custom icon for this profile in the connection screen. 
--- 
--- Returns true if successful, or nil+error message if not.
--- 
--- See also:
--- see: resetProfileIcon()
--- Note:  Available in Mudlet 4.0+
--- 
--- ## Parameters
--- * `iconPath:`
---  Full location of the icon - can be .png or .jpg with ideal dimensions of 120x30.
--- 
--- ## Example
--- ```lua
--- -- set a custom icon that is located in an installed package called "mypackage"
--- setProfileIcon(getMudletHomeDir().."/mypackage/icon.png")
--- ```
function setProfileIcon(iconPath)
end

---  Sets the script's Lua code, replacing existing code. If you have many scripts with the same name, use the 'occurrence' parameter to choose between them.
---  If you'd like to add code instead of replacing it, have a look at [[Manual:Lua_Functions#appendScript|appendScript()]].
---  Returns -1 if the script isn't found - to create a script, use [[Manual:Lua_Functions#permScript|permScript()]].
--- 
--- See also:
--- see: permScript()
--- see: enableScript()
--- see: disableScript()
--- see: getScript()
--- see: appendScript()
--- ## Returns
--- * a unique id number for that script.
--- 
--- ## Parameters
--- * `scriptName`: name of the script to change the code.
--- * `luaCode`: new Lua code to set.
--- * `occurrence`: The position of the script. Optional, defaults to 1 (first).
--- 
--- ## Example
--- ```lua
--- -- an example of setting the script lua code from the first occurrence of "testscript"
--- setScript("testscript", [[echo("This is a test\n")]], 1)
--- ```
--- Note:  Available from Mudlet 4.8+
function setScript(scriptName, luaCode, occurrence)
end

--- 
--- ## Parameters
--- * `watchID` (number) / `currentStopWatchName` (string): The stopwatch ID you get from [[Manual:Lua_Functions#createStopWatch|createStopWatch()]] or the name supplied to that function at that time, or previously applied with this function.
--- * `newStopWatchName` (string): The name to use for this stopwatch from now on.
--- 
--- ## Returns
--- * `true` on success, `nil` and an error message if no matching stopwatch is found.
--- 
--- Note:  Either `currentStopWatchName` or `newStopWatchName` may be empty strings: if the first of these is so then the `lowest` ID numbered stopwatch without a name is chosen; if the second is so then an existing name is removed from the chosen stopwatch.
function setStopWatchName(watchID/currentStopWatchName, newStopWatchName)
end

--- 
--- ## Parameters
--- * `watchID` (number) / `watchName` (string): The stopwatch ID you get from [[Manual:Lua_Functions#createStopWatch|createStopWatch()]] or the name supplied to that function or applied later with [[Manual:Lua_Functions#setStopWatchName|setStopWatchName()]]
--- * `state` (boolean): if `true` the stopWatch will be saved.
--- 
--- ## Returns
--- * `true` on success, `nil` and an error message if no matching stopwatch is found.
--- 
--- Sets or resets the flag so that the stopwatch is saved between sessions or after a [[Manual:Miscellaneous_Functions#resetProfile|resetProfile()]] call. If set then, if `stopped` the elapsed time recorded will be unchanged when the stopwatch is reloaded in the next session; if `running` the elapsed time will continue to increment and it will include the time that the profile was not loaded, therefore it can be used to measure events in real-time, outside of the profile!
--- 
--- Note:  When a persistent stopwatch is reloaded in a later session (or after a use of `resetProfile()`) the stopwatch may not be allocated the same ID number as before - therefore it is advisable to assign any persistent stopwatches a name, either when it is created or before the session is ended.
function setStopWatchPersistence(watchID/watchName, state)
end

--- Sets for how many more lines a trigger script should fire or a chain should stay open after the trigger has matched - so this allows you to extend or shorten the `fire length` of a trigger. The main use of this function is to close a chain when a certain condition has been met.
--- 
--- ## Parameters
--- * `name:` The name of the trigger which has a fire length set (and which opens the chain).
--- * `number`: 0 to close the chain, or a positive number to keep the chain open that much longer.
--- 
--- ## Examples
--- ```lua
--- -- if you have a trigger that opens a chain (has some fire length) and you'd like it to be closed 
--- -- on the next prompt, you could make a trigger inside the chain with a Lua function pattern of:
--- return isPrompt()
--- -- and a script of:
--- setTriggerStayOpen("Parent trigger name", 0)
--- -- to close it on the prompt!
--- ```
function setTriggerStayOpen(name, number)
end

--- ## startStopWatch(watchName)
--- 
--- Stopwatches can be stopped (with [[Manual:Lua_Functions#stopStopWatch|stopStopWatch()]]) and then re-started any number of times. **To ensure backwards compatibility, if the stopwatch is identified by a `numeric` argument then, `unless a second argument of false is supplied as well` this function will also reset the stopwatch to zero and restart it - whether it is running or not**; otherwise only a stopped watch can be started and only a started watch may be stopped. Trying to repeat either will produce a nil and an error message instead; also the recorded time is no longer reset so that they can now be used to record a total of isolated periods of time like a real stopwatch.
--- 
--- See also:
--- see: createStopWatch()
--- see: stopStopWatch()
--- ## Parameters
--- * `watchID`/`watchName`: The stopwatch ID you get with [[Manual:Lua_Functions#createStopWatch|createStopWatch()]], or from **4.4.0** the name assigned with that function or [[Manual:Lua_Functions#setStopWatchName|setStopWatchName()]].
--- * `resetAndRestart`: Boolean flag needed (as `false`) to make the function from **4.4.0**, when supplied with a numeric watch ID, to **not** reset the stopwatch and only start a previously stopped stopwatch. This behavior is automatic when a string watch name is used to identify the stopwatch but differs from how the function behaved prior to that version.
--- 
--- ## Returns
--- * `true` on success, `nil` and an error message if no matching stopwatch is found or if it cannot be started (because the later style behavior was indicated and it was already running).
--- 
--- ## Examples
--- ```lua
--- -- this is a common pattern for re-using stopwatches prior to 4.4.0 and starting them:
--- watch = watch or createStopWatch()
--- startStopWatch(watch)
--- ```
--- 
---  After 4.4.0 the above code will work the same as it does not provide a second argument to the `startStopWatch()` function - if a `false` was used there it would be necessary to call `stopStopWatch(...)` and then `resetStopWatch(...)` before using `startStopWatch(...)` to re-use the stopwatch if the ID form is used, **this is thus not quite the same behavior but it is more consistent with the model of how a real stopwatch would act.**
function startStopWatch(watchID, resetAndRestart)
end

--- "Stops" (though see the note below) the stop watch and returns (only the **first** time it is called after the stopwatch has been set running with [[Manual:Lua_Functions#startStopWatch()|startStopWatchTime()]]) the elapsed time as a number of seconds, with a decimal portion give a resolution in milliseconds (thousandths of a second). You can also retrieve the current time without stopping the stopwatch with [[Manual:Lua_Functions#getStopWatchTime|getStopWatchTime()]], [[Manual:Lua_Functions#getBrokenDownStopWatchTime|getBrokenDownStopWatchTime()]].
--- 
--- See also:
--- see: createStopWatch()
--- ## Parameters
--- * `watchID:` The stopwatch ID you get with [[Manual:Lua_Functions#createStopWatch|createStopWatch()]] or from Mudlet **4.4.0** the name given to that function or later set with [[Manual:Lua_Functions#setStopWatchName|setStopWatchName()]].
--- 
--- ## Returns
--- * the elapsed time as a floating-point number of seconds - it may be negative if the time was previously adjusted/preset to a negative amount (with [[Manual:Lua_Functions#adjustStopWatch|adjustStopWatch()]]) and that period has not yet elapsed.
--- 
--- ## Examples
--- ```lua
--- -- this is a common pattern for re-using stopwatches and starting them:
--- watch = watch or createStopWatch()
--- startStopWatch(watch)
--- 
--- -- do some long-running code here ...
--- 
--- print("The code took: "..stopStopWatch(watch).."s to run.")
--- ```
function stopStopWatch(watchID_or_watchName)
end

--- This is an alternative to [[Manual:Lua_Functions#tempColorTrigger|tempColorTrigger()]] which supports the full set of 256 ANSI color codes directly and makes a color trigger that triggers on the specified foreground and background color. The function returns the trigger ID for subsequent [[Manual:Lua_Functions#enableTrigger|enableTrigger()]], [[Manual:Lua_Functions#disableTrigger|disableTrigger()]] and [[Manual:Lua_Functions#killTrigger|killTrigger()]] calls. The trigger is temporary in the sense that it won't stay when you close Mudlet, and it will go off multiple times until you disable or destroy it. You can also make it be temporary and self-delete after a number of matches with the `expireAfter` parameter.
--- 
--- ## Parameters
--- * `foregroundColor:` The foreground color you'd like to trigger on.
--- * `backgroundColor`: The background color you'd like to trigger on.
--- * `code to do`: The code to do when the trigger runs - wrap it in [[ ]], or give it a Lua function.
--- * `expireAfter`: Delete trigger after a specified number of matches. You can make a trigger match not count towards expiration by returning true after it fires.
--- 
--- `BackgroundColor` and/or `expireAfter` may be omitted.
--- 
--- ## Color codes (note that the values greater than or equal to zero are the actual number codes that ANSI and the game server uses for the 8/16/256 color modes)
--- 
--- Special codes (may be extended in the future):
--- -2 = default text color (what is used after an ANSI SGR 0 m code that resets the foreground and background colors to those set in the preferences)
--- -1 = ignore (only **one** of the foreground or background codes can have this value - otherwise it would not be a `color` trigger!)
--- 
--- ANSI 8-color set:
--- 0 = (dark) black
--- 1 = (dark) red
--- 2 = (dark) green
--- 3 = (dark) yellow
--- 4 = (dark) blue
--- 5 = (dark) magenta
--- 6 = (dark) cyan
--- 7 = (dark) white {a.k.a. light gray}
--- 
--- Additional colors in 16-color set:
--- 8 = light black {a.k.a. dark gray}
--- 9 = light red
--- 10 = light green
--- 11 = light yellow
--- 12 = light blue
--- 13 = light magenta
--- 14 = light cyan
--- 15 = light white
--- 
--- 6 x 6 x 6 RGB (216) colors, shown as a 3x2-digit hex code
--- 16 = #000000
--- 17 = #000033
--- 18 = #000066
--- ...
--- 229 = #FFFF99
--- 230 = #FFFFCC
--- 231 = #FFFFFF
--- 
--- 24 gray-scale, also show as a 3x2-digit hex code
--- 232 = #000000
--- 233 = #0A0A0A
--- 234 = #151515
--- ...
--- 253 = #E9E9E9
--- 254 = #F4F4F4
--- 255 = #FFFFFF
--- 
--- ## Examples
--- ```lua
--- -- This script will re-highlight all text in a light cyan foreground color on any background with a red foreground color
--- -- until another foreground color in the current line is being met. temporary color triggers do not offer match_all
--- -- or filter options like the GUI color triggers because this is rarely necessary for scripting.
--- -- A common usage for temporary color triggers is to schedule actions on the basis of forthcoming text colors in a particular context.
--- tempAnsiColorTrigger(14, -1, [[selectString(matches[1],1) fg("red")]])
--- -- or:
--- tempAnsiColorTrigger(14, -1, function()
---   selectString(matches[1], 1)
---   fg("red")
--- end)
--- 
--- -- match the trigger only 4 times
--- tempColorTrigger(14, -1, [[selectString(matches[1],1) fg("red")]], 4)
--- ```
--- 
--- Note:  Available since Mudlet 3.17+
function tempAnsiColorTrigger(foregroundColor, _backgroundColor, code, _expireAfter)
end

--- Creates a temporary alias - temporary in the sense that it won't be saved when Mudlet restarts (unless you re-create it). The alias will go off as many times as it matches, it is not a one-shot alias. The function returns an ID for subsequent [[Manual:Lua_Functions#enableAlias|enableAlias()]], [[Manual:Lua_Functions#disableAlias|disableAlias()]] and [[Manual:Lua_Functions#killAlias|killAlias()]] calls.
--- 
--- ## Parameters
--- * `regex:` Alias pattern in regex.
--- * `code to do:` The code to do when the alias fires - wrap it in [[ ]].
--- 
--- ## Examples
--- ```lua
--- myaliasID = tempAlias("^hi$", [[send ("hi") echo ("we said hi!")]])
--- 
--- -- you can also delete the alias later with:
--- killAlias(myaliasID)
--- ```
function tempAlias(regex, code_to_do)
end

--- Creates a trigger that will go off whenever the part of line it's provided with matches the line right from the start (doesn't matter what the line ends with). The trigger is temporary in the sense that it won't stay when you close Mudlet, and it will go off multiple times until you disable or destroy it. You can also make it be temporary and self-delete after a number of matches with the `expireAfter` parameter. The function returns the trigger ID for subsequent [[Manual:Lua_Functions#enableTrigger|enableTrigger()]], [[Manual:Lua_Functions#disableTrigger|disableTrigger()]] and [[Manual:Lua_Functions#killTrigger|killTrigger()]] calls.
--- 
--- ## Parameters
--- * `part of line`: start of the line that you'd like to match. This can also be regex.
--- * `code to do`: code to do when the trigger runs - wrap it in [[ ]], or give it a Lua function (since Mudlet 3.5.0).
--- * `expireAfter`: Delete trigger after a specified number of matches (since Mudlet 3.11). You can make a trigger match not count towards expiration by returning true after it fires.
--- 
--- ## Examples
--- ```lua
--- mytriggerID = tempBeginOfLineTrigger("Hello", [[echo("We matched!")]])
--- 
--- --[[ now this trigger will match on any of these lines:
--- Hello
--- Hello!
--- Hello, Bob!
--- 
--- but not on:
--- Oh, Hello
--- Oh, Hello!
--- ]]
--- 
--- -- or as a function:
--- mytriggerID = tempBeginOfLineTrigger("Hello", function() echo("We matched!") end)
--- ```
--- 
--- ```lua
--- -- you can make the trigger match only a certain amount of times as well, 5 in this example:
--- tempBeginOfLineTrigger("This is the start of the line", function() echo("We matched!") end, 5)
--- 
--- -- if you want a trigger match not to count towards expiration, return true. In this example it'll match 5 times unless the line is "Start of line and this is the end."
--- tempBeginOfLineTrigger("Start of line", 
--- function()
---   if line == "Start of line and this is the end." then
---     return true
---   else
---     return false
---   end
--- end, 5)
--- ```
function tempBeginOfLineTrigger(part_of_line, code, expireAfter)
end

--- Creates a temporary button. Temporary means, it will disappear when Mudlet is closed.
--- 
--- ## Parameters:
--- * `toolbar name`: The name of the toolbar to place the button into.
--- * `button text`: The text to display on the button.
--- * `orientation`: a number 0 or 1 where 0 means horizontal orientation for the button and 1 means vertical orientation for the button. This becomes important when you want to have more than one button in the same toolbar.
--- 
--- ## Example
--- ```lua
--- -- makes a temporary toolbar with two buttons at the top of the main Mudlet window 
--- lua tempButtonToolbar("topToolbar", 0, 0)
--- lua tempButton("topToolbar", "leftButton", 0)
--- lua tempButton("topToolbar", "rightButton", 0)
--- ```
--- 
--- Note:  `This function is not that useful as there is no function yet to assign a Lua script or command to such a temporary button - though it may have some use to flag a status indication!`
function tempButton(toolbar_name, button_text, orientation)
end

--- Creates a temporary button toolbar. Temporary means, it will disappear when Mudlet is closed.
--- 
--- ## Parameters:
--- * `name`: The name of the toolbar.
--- * `location`: a number from 0 to 3, where 0 means "at the top of the screen", 1 means "left side", 2 means "right side" and 3 means "in a window of its own" which can be dragged and attached to the main Mudlet window if needed.
--- * `orientation`: a number 0 or 1, where 0 means horizontal orientation for the toolbar and 1 means vertical orientation for the toolbar. This becomes important when you want to have more than one toolbar in the same location of the window.
--- 
--- ## Example
--- ```lua
--- -- makes a temporary toolbar with two buttons at the top of the main Mudlet window 
--- lua tempButtonToolbar("topToolbar", 0, 0)
--- lua tempButton("topToolbar", "leftButton", 0)
--- lua tempButton("topToolbar", "rightButton", 0)
--- ```
function tempButtonToolbar(name, location, orientation)
end

--- Makes a color trigger that triggers on the specified foreground and background color. Both colors need to be supplied in form of these simplified ANSI 16 color mode codes. The function returns the trigger ID for subsequent [[Manual:Lua_Functions#enableTrigger|enableTrigger()]], [[Manual:Lua_Functions#disableTrigger|disableTrigger()]] and [[Manual:Lua_Functions#killTrigger|killTrigger()]] calls. The trigger is temporary in the sense that it won't stay when you close Mudlet, and it will go off multiple times until you disable or destroy it. You can also make it be temporary and self-delete after a number of matches with the `expireAfter` parameter.
--- 
--- ## Parameters
--- * `foregroundColor:` The foreground color you'd like to trigger on.
--- * `backgroundColor`: The background color you'd like to trigger on.
--- * `code to do`: The code to do when the trigger runs - wrap it in [[ ]], or give it a Lua function (since Mudlet 3.5.0).
--- * `expireAfter`: Delete trigger after a specified number of matches (since Mudlet 3.11). You can make a trigger match not count towards expiration by returning true after it fires.
--- 
--- ## Color codes
--- ```lua
--- 0 = default text color
--- 1 = light black
--- 2 = dark black
--- 3 = light red
--- 4 = dark red
--- 5 = light green
--- 6 = dark green
--- 7 = light yellow
--- 8 = dark yellow
--- 9 = light blue
--- 10 = dark blue
--- 11 = light magenta
--- 12 = dark magenta
--- 13 = light cyan
--- 14 = dark cyan
--- 15 = light white
--- 16 = dark white
--- ```
--- 
--- ## Examples
--- ```lua
--- -- This script will re-highlight all text in blue foreground colors on a black background with a red foreground color
--- -- on a blue background color until another color in the current line is being met. temporary color triggers do not 
--- -- offer match_all or filter options like the GUI color triggers because this is rarely necessary for scripting. 
--- -- A common usage for temporary color triggers is to schedule actions on the basis of forthcoming text colors in a particular context.
--- tempColorTrigger(9, 2, [[selectString(matches[1],1) fg("red") bg("blue")]])
--- -- or:
--- tempColorTrigger(9, 2, function()
---   selectString(matches[1], 1)
---   fg("red")
---   bg("blue")
--- end)
--- 
--- -- match the trigger only 4 times
--- tempColorTrigger(9, 2, [[selectString(matches[1],1) fg("red") bg("blue")]], 4)
--- ```
function tempColorTrigger(foregroundColor, backgroundColor, code, expireAfter)
end

--- Allows you to create a temporary trigger in Mudlet, using any of the UI-available options. The trigger is temporary in the sense that it won't stay when you close Mudlet, and it will go off multiple times until you disable or destroy it. You can also make it be temporary and self-delete after a number of matches with the `expireAfter` parameter.
--- Returns the trigger name, that you can use [[Manual:Lua_Functions#killTrigger|killTrigger()]] later on with.
--- 
--- ## Parameters
--- * `name` - The name you call this trigger. 
--- * `regex` - The regular expression you want to match.
--- * `code` - Code to do when the trigger runs. You need to wrap it in [[ ]], or give a Lua function (since Mudlet 3.5.0).
--- * `multiline` - Set this to 1, if you use multiple regex (see note below), and you need the trigger to fire only if all regex have been matched within the specified line delta. Then all captures will be saved in `multimatches` instead of `matches`. If this option is set to 0, the trigger will fire when any regex has been matched.
--- * `fg color` - The foreground color you'd like to trigger on.
--- * `bg color` - The background color you'd like to trigger on.
--- * `filter` - Do you want only the filtered content (=capture groups) to be passed on to child triggers? Otherwise also the initial line.
--- * `match all` - Set to 1, if you want the trigger to match all possible occurrences of the regex in the line. When set to 0, the trigger will stop after the first successful match.
--- * `highlight fg color` - The foreground color you'd like your match to be highlighted in.
--- * `highlight bg color` - The background color you'd like your match to be highlighted in.
--- * `play sound file` - Set to the name of the sound file you want to play upon firing the trigger.
--- * `fire length` - Number of lines within which all condition must be true to fire the trigger.
--- * `line delta` - Keep firing the script for x more lines, after the trigger or chain has matched.
--- * `expireAfter` - Delete trigger after a specified number of matches (since Mudlet 3.11). You can make a trigger match not count towards expiration by returning true after it fires.
--- 
--- {{Note}} Set the options starting at `multiline` to 0, if you don't want to use those options. Otherwise enter 1 to activate or the value you want to use.
--- 
--- {{Note}} If you want to use the color option, you need to provide both fg and bg together.
--- 
--- ## Examples
--- 
--- ```lua
--- -- This trigger will be activated on any new line received.
--- triggerNumber = tempComplexRegexTrigger("anyText", "^(.*)$", [[echo("Text received!")]], 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
--- 
--- -- This trigger will match two different regex patterns:
--- tempComplexRegexTrigger("multiTrigger", "first regex pattern", [[]], 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
--- tempComplexRegexTrigger("multiTrigger", "second regex pattern", [[echo("Trigger matched!")]], 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
--- ```
--- 
--- {{Note}} For making a multiline trigger like in the second example, you need to use the same trigger name and options, providing the new pattern to add. Note that only the last script given will be set, any others ignored.
function tempComplexRegexTrigger(name, regex, code, multiline, fg_color, bg_color, filter, match_all, highlight_fg_color, highlight_bg_color, play_sound_file, fire_length, line_delta, expireAfter)
end

--- Creates a trigger that will go off whenever the line from the game matches the provided line exactly (ends the same, starts the same, and looks the same). You don't need to use any of the regex symbols here (^ and $). The function returns the trigger ID for subsequent [[Manual:Lua_Functions#enableTrigger|enableTrigger()]], [[Manual:Lua_Functions#disableTrigger|disableTrigger()]] and [[Manual:Lua_Functions#killTrigger|killTrigger()]] calls. The trigger is temporary in the sense that it won't stay when you close Mudlet, and it will go off multiple times until you disable or destroy it. You can also make it be temporary and self-delete after a number of matches with the `expireAfter` parameter.
--- 
--- ## Parameters
--- * `exact line`: exact line you'd like to match.
--- * `code`: code to do when the trigger runs - wrap it in [[ ]], or give it a Lua function (since Mudlet 3.5.0).
--- * `expireAfter`: Delete trigger after a specified number of matches (since Mudlet 3.11). You can make a trigger match not count towards expiration by returning true after it fires.
--- 
--- ## Examples
--- ```lua
--- mytriggerID = tempExactMatchTrigger("You have recovered balance on all limbs.", [[echo("We matched!")]])
--- 
--- -- as a function:
--- mytriggerID = tempExactMatchTrigger("You have recovered balance on all limbs.", function() echo("We matched!") end)
--- 
--- -- expire after 4 matches:
--- tempExactMatchTrigger("You have recovered balance on all limbs.", function() echo("Got balance back!\n") end, 4)
--- 
--- -- you can also avoid expiration by returning true:
--- tempExactMatchTrigger("You have recovered balance on all limbs.", function() echo("Got balance back!\n") return true end, 4)
--- ```
function tempExactMatchTrigger(exact_line, code, expireAfter)
end

--- Creates a keybinding. This keybinding isn't temporary in the sense that it'll go off only once (it'll go off as often as you use it), but rather it won't be saved when Mudlet is closed.
--- 
--- See also:
--- see: permKey()
--- see: killKey()
--- * `modifier` 
--- (optional) modifier to use - can be one of `mudlet.keymodifier.Control`, `mudlet.keymodifier.Alt`, `mudlet.keymodifier.Shift`, `mudlet.keymodifier.Meta`, `mudlet.keymodifier.Keypad`, or `mudlet.keymodifier.GroupSwitch` or the default value of `mudlet.keymodifier.None` which is used if the argument is omitted. To use multiple modifiers, add them together: `(mudlet.keymodifier.Shift + mudlet.keymodifier.Control)`
--- * `key code` 
---  actual key to use - one of the values available in `mudlet.key`, e.g. `mudlet.key.Escape`, `mudlet.key.Tab`, `mudlet.key.F1`, `mudlet.key.A`, and so on. The list is a bit long to list out in full so it is [https://github.com/Mudlet/Mudlet/blob/development/src/mudlet-lua/lua/KeyCodes.lua#L2 available here].
--- * `lua code'
---  code you'd like the key to run - wrap it in [[ ]].
--- 
--- ## Returns
--- * a unique id number for that key.
--- 
--- ## Examples
--- ```lua
--- local keyID = tempKey(mudlet.key.F8, [[echo("hi")]])
--- 
--- local anotherKeyID = tempKey(mudlet.keymodifier.Control, mudlet.key.F8, [[echo("hello")]])
--- 
--- -- bind Ctrl+Shift+W:
--- tempKey(mudlet.keymodifier.Control + mudlet.keymodifier.Shift, mudlet.key.W, [[send("jump")]])
--- 
--- -- delete it if you don't like it anymore
--- killKey(keyID)
--- ```
function tempKey(modifier, key_code, lua_code)
end

--- Temporary trigger that will fire on `n` consecutive lines following the current line. This is useful to parse output that is known to arrive in a certain line margin or to delete unwanted output from the MUD - the trigger does not require any patterns to match on. The function returns the trigger ID for subsequent [[Manual:Lua_Functions#enableTrigger|enableTrigger()]], [[Manual:Lua_Functions#disableTrigger|disableTrigger()]] and [[Manual:Lua_Functions#killTrigger|killTrigger()]] calls. The trigger is temporary in the sense that it won't stay when you close Mudlet, and it will go off multiple times until you disable or destroy it. You can also make it be temporary and self-delete after a number of matches with the `expireAfter` parameter.
--- 
--- ## Parameters:
--- * `from`: from which line after this one should the trigger activate - 1 will activate right on the next line.
--- * `howMany`: how many lines to run for after the trigger has activated.
--- * `code`: code to do when the trigger runs - wrap it in [[ ]], or give it a Lua function (since Mudlet 3.5.0).
--- * `expireAfter`: Delete trigger after a specified number of matches (since Mudlet 3.11). You can make a trigger match not count towards expiration by returning true after it fires.
--- 
--- ## Example: 
--- ```lua
--- -- Will fire 3 times with the next line from the MUD.
--- tempLineTrigger(1, 3, function() print(" trigger matched!") end)
--- 
--- -- Will fire 20 lines after the current line and fire twice on 2 consecutive lines, 7 times.
--- tempLineTrigger(20, 2, function() print(" trigger matched!") end, 7)
--- ```
function tempLineTrigger(from, howMany, code, expireAfter)
end

--- Temporary trigger that will match on the games prompt. The function returns the trigger ID for subsequent [[Manual:Lua_Functions#enableTrigger|enableTrigger()]], [[Manual:Lua_Functions#disableTrigger|disableTrigger()]] and [[Manual:Lua_Functions#killTrigger|killTrigger()]] calls. The trigger is temporary in the sense that it won't stay when you close Mudlet, and it will go off multiple times until you disable or destroy it. You can also make it be temporary and self-delete after a number of matches with the `expireAfter` parameter.
--- 
--- Note:  If the trigger is not working, check that the **N:** bottom-right has a number. This feature requires telnet Go-Ahead to be enabled in the game. Available in Mudlet 3.6+
--- 
--- ## Parameters:
--- * `code`: code to do when the trigger runs - wrap it in [[ ]], or give it a Lua function.
--- * `expireAfter`: Delete trigger after a specified number of matches. You can make a trigger match not count towards expiration by returning true after it fires.
--- 
--- Note:  `expireAfter` is available since Mudlet 3.11
--- 
--- ## Example: 
--- ```lua
--- tempPromptTrigger(function()
---   echo("hello! this is a prompt!")
--- end)
--- 
--- -- match only 2 times:
--- tempPromptTrigger(function()
---   echo("hello! this is a prompt!")
--- end, 2)
--- 
--- -- match only 2 times, unless the prompt is "55 health."
--- tempPromptTrigger(function()
---   if line == "55 health." then return true end
--- end, 2)
--- ```
function tempPromptTrigger(code, expireAfter)
end

--- Creates a temporary regex trigger that executes the code whenever it matches. The function returns the trigger ID for subsequent [[Manual:Lua_Functions#enableTrigger|enableTrigger()]], [[Manual:Lua_Functions#disableTrigger|disableTrigger()]] and [[Manual:Lua_Functions#killTrigger|killTrigger()]] calls. The trigger is temporary in the sense that it won't stay when you close Mudlet, and it will go off multiple times until you disable or destroy it. You can also make it be temporary and self-delete after a number of matches with the `expireAfter` parameter.
--- 
--- ## Parameters:
--- * `regex:` regular expression that lines will be matched on.
--- * `code`: code to do when the trigger runs - wrap it in [[ ]], or give it a Lua function (since Mudlet 3.5.0).
--- * `expireAfter`: Delete trigger after a specified number of matches (since Mudlet 3.11). You can make a trigger match not count towards expiration by returning true after it fires.
--- 
--- ## Examples:
--- ```lua
--- -- create a non-duplicate trigger that matches on any line and calls a function
--- html5log = html5log or {}
--- if html5log.trig then killTrigger(html5log.trig) end
--- html5log.trig = tempRegexTrigger("^", [[html5log.recordline()]])
--- -- or a simpler variant:
--- html5log.trig = tempRegexTrigger("^", html5log.recordline)
--- 
--- -- only match 3 times:
--- tempRegexTrigger("^You prick (.+) twice in rapid succession with", function() echo("Hit "..matches[2].."!\n") end, 3)
--- ```
function tempRegexTrigger(regex, code, expireAfter)
end

--- Creates a temporary one-shot timer and returns the timer ID, which you can use with [[Manual:Lua_Functions#enableTimer|enableTimer()]], [[Manual:Lua_Functions#disableTimer|disableTimer()]] and [[Manual:Lua_Functions#killTimer|killTimer()]] functions. You can use 2.3 seconds or 0.45 etc. After it has fired, the timer will be deactivated and destroyed, so it will only go off once. Here is a [[Manual:Introduction#Timers|more detailed introduction to tempTimer]].
--- 
--- ## Parameters
--- * `time:` The time in seconds for which to set the timer for - you can use decimals here for precision. The timer will go off `x` given seconds after you make it.
--- * `code to do`: The code to do when the timer is up - wrap it in [[ ]], or provide a Lua function.
--- * `repeating`: (optional) if true, keep firing the timer over and over until you kill it (available in Mudlet 4.0+).
--- 
--- ## Examples
--- ```lua
--- -- wait half a second and then run the command
--- tempTimer(0.5, function() send("kill monster") end)
--- 
--- -- or an another example - two ways to 'embed' variable in a code for later:
--- local name = matches[2]
--- tempTimer(2, [[send("hello, ]]..name..[[ !")]])
--- -- or:
--- tempTimer(2, function()
---   send("hello, "..name)
--- end)
--- 
--- -- create a looping timer
--- timerid = tempTimer(1, function() display("hello!") end, true)
--- 
--- -- later when you'd like to stop it:
--- killTimer(timerid)
--- ```
--- 
--- Note:  Double brackets, e.g: [[ ]] can be used to quote strings in Lua. The difference to the usual `" " quote syntax is that `[[ ]] also accepts the character ". Consequently, you don’t have to escape the " character in the above script. The other advantage is that it can be used as a multiline quote, so your script can span several lines.
--- 
--- Note:  Lua code that you provide as an argument is compiled from a string value when the timer fires. This means that if you want to pass any parameters by value e.g. you want to make a function call that uses the value of your variable myGold as a parameter you have to do things like this:
--- 
--- ```lua
--- tempTimer( 3.8, [[echo("at the time of the tempTimer call I had ]] .. myGold .. [[ gold.")]] )
--- 
--- -- tempTimer also accepts functions (and thus closures) - which can be an easier way to embed variables and make the code for timers look less messy:
--- 
--- local variable = matches[2]
--- tempTimer(3, function () send("hello, " .. variable) end)
--- ```
function tempTimer(time, code_to_do, _repeating)
end

--- Creates a substring trigger that executes the code whenever it matches. The function returns the trigger ID for subsequent [[Manual:Lua_Functions#enableTrigger|enableTrigger()]], [[Manual:Lua_Functions#disableTrigger|disableTrigger()]] and [[Manual:Lua_Functions#killTrigger|killTrigger()]] calls. The trigger is temporary in the sense that it won't stay when you close Mudlet, and it will go off multiple times until you disable or destroy it. You can also make it be temporary and self-delete after a number of matches with the `expireAfter` parameter.
--- 
--- ## Parameters:
--- * `substring`: The substring to look for - this means a part of the line. If your provided text matches anywhere within the line from the game, the trigger will go off.
--- * `code`: The code to do when the trigger runs - wrap it in [[ ]], or give it a Lua function (since Mudlet 3.5)
--- * `expireAfter`: Delete trigger after a specified number of matches (since Mudlet 3.11). You can make a trigger match not count towards expiration by returning true after it fires.
--- 
--- Example:
--- ```lua
--- -- this example will highlight the contents of the "target" variable.
--- -- it will also delete the previous trigger it made when you call it again, so you're only ever highlighting one name
--- if id then killTrigger(id) end
--- id = tempTrigger(target, [[selectString("]] .. target .. [[", 1) fg("gold") resetFormat()]])
--- 
--- -- you can also write the same line as:
--- id = tempTrigger(target, function() selectString(target, 1) fg("gold") resetFormat() end)
--- 
--- -- or like so if you have a highlightTarget() function somewhere
--- id = tempTrigger(target, highlightTarget)
--- ```
--- 
--- ```lua
--- -- a simpler trigger to replace "hi" with "bye" whenever you see it
--- tempTrigger("hi", [[selectString("hi", 1) replace("bye")]])
--- ```
--- 
--- ```lua
--- -- this trigger will go off only 2 times
--- tempTrigger("hi", function() selectString("hi", 1) replace("bye") end, 2)
--- ```
--- 
--- ```lua
--- -- table to store our trigger IDs in
--- nameIDs = nameIDs or {}
--- -- delete any existing triggers we've already got
--- for _, id in ipairs(nameIDs) do killTrigger(id) end
--- 
--- -- create new ones, avoiding lots of ]] [[ to embed the name
--- for _, name in ipairs{"Alice", "Ashley", "Aaron"} do
---   nameIDs[#nameIDs+1] = tempTrigger(name, function() print(" Found "..name.."!") end)
--- end
--- ```
function tempTrigger(substring, code, expireAfter)
end

