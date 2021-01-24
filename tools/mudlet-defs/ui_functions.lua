---  Converts ANSI colour sequences in <code>text</code> to colour tags that can be processed by the decho() function. Italics and underline not currently supported since decho doesn't support them.
--- See also:
--- see: decho()
---  ANSI bold is available since Mudlet 3.7.1+.
--- R
--- ## Parameters
--- * `text:`
---  String that contains ANSI colour sequences that should be replaced.
--- * `default_colour:`
---  Optional - ANSI default colour code (used when handling orphan bold tags).
--- 
--- ## Return values
--- * `string text:`
---  The decho-valid converted text.
--- * `string colour:`
---  The ANSI code for the last used colour in the substitution (useful if you want to colour subsequent lines according to this colour).
--- 
--- ## Example
--- ```lua
--- local replaced = ansi2decho('\27[0;1;36;40mYou say in a baritone voice, "Test."\27[0;37;40m')
--- -- 'replaced' should now contain <r><0,255,255:0,0,0>You say in a baritone voice, "Test."<r><192,192,192:0,0,0>
--- decho(replaced)
--- ```
--- 
--- Or show a complete colourful squirrel! It's a lotta code to do all the colours, so click the **Expand** button on the right to show it:
--- 
--- ```lua
--- decho(ansi2decho([[
---                                                   �[38;5;95m▄�[48;5;95;38;5;130m▄▄▄�[38;5;95m█�[49m▀�[0m    �[0m
--- ╭───────────────────────╮          �[38;5;95m▄▄�[0m          �[38;5;95m▄�[48;5;95;38;5;130m▄▄�[48;5;130m█�[38;5;137m▄�[48;5;137;38;5;95m▄�[49m▀�[0m      �[0m
--- │                       │         �[48;5;95;38;5;95m█�[48;5;137;38;5;137m██�[48;5;95m▄�[49;38;5;95m▄▄▄�[48;5;95;38;5;137m▄▄▄�[49;38;5;95m▄▄�[48;5;95;38;5;130m▄�[48;5;130m███�[38;5;137m▄�[48;5;137m█�[48;5;95;38;5;95m█�[0m       �[0m
--- │  Encrypt everything!  │       �[38;5;95m▄�[48;5;187;38;5;16m▄�[48;5;16;38;5;187m▄�[38;5;16m█�[48;5;137;38;5;137m███�[38;5;187m▄�[38;5;16m▄▄�[38;5;137m██�[48;5;95;38;5;95m█�[48;5;130;38;5;130m█████�[48;5;137;38;5;137m██�[48;5;95;38;5;95m█�[0m       �[0m
--- │                       ├────  �[38;5;95m▄�[48;5;95;38;5;137m▄�[48;5;16m▄▄▄�[48;5;137m███�[48;5;16;38;5;16m█�[48;5;187m▄�[48;5;16m█�[48;5;137;38;5;137m█�[48;5;95;38;5;95m█�[48;5;130;38;5;130m██████�[48;5;137;38;5;137m███�[48;5;95;38;5;95m█�[0m      �[0m
--- ╰───────────────────────╯      �[48;5;95;38;5;95m█�[48;5;137;38;5;137m██�[48;5;16m▄�[38;5;16m█�[38;5;137m▄�[48;5;137m██████�[48;5;95;38;5;95m█�[48;5;130;38;5;130m██████�[48;5;137;38;5;137m████�[48;5;95m▄�[49;38;5;95m▄�[0m    �[0m
---                                 �[38;5;95m▀�[48;5;137m▄�[38;5;137m███████�[38;5;95m▄�[49m▀�[0m �[48;5;95;38;5;95m█�[48;5;130;38;5;130m██████�[48;5;137;38;5;137m████�[48;5;95m▄�[49;38;5;95m▄�[0m   �[0m
---                                   �[48;5;95;38;5;187m▄▄▄�[38;5;137m▄�[48;5;137m██�[48;5;95;38;5;95m█�[0m    �[48;5;95;38;5;95m█�[48;5;130;38;5;130m███████�[48;5;137;38;5;137m███�[48;5;95m▄�[49;38;5;95m▄�[0m  �[0m
---                                  �[38;5;187m▄�[48;5;187m███�[48;5;137;38;5;137m████�[48;5;95;38;5;95m█�[0m   �[48;5;95;38;5;95m█�[48;5;130;38;5;130m█████████�[48;5;137;38;5;137m███�[48;5;95;38;5;95m█�[0m �[0m
---                                 �[38;5;187m▄�[48;5;187m███�[38;5;137m▄�[48;5;137m█�[48;5;95;38;5;95m█�[48;5;137;38;5;137m███�[48;5;95m▄�[49;38;5;95m▄�[0m  �[38;5;95m▀�[48;5;130m▄�[38;5;130m███████�[48;5;137;38;5;137m████�[48;5;95;38;5;95m█�[0m�[0m
---                                �[48;5;95;38;5;95m█�[48;5;187;38;5;187m████�[48;5;137;38;5;137m██�[48;5;95m▄�[48;5;137;38;5;95m▄�[38;5;137m██�[38;5;95m▄�[38;5;137m█�[48;5;95m▄�[49;38;5;95m▄�[0m �[48;5;95;38;5;95m█�[48;5;130;38;5;130m███████�[48;5;137;38;5;137m████�[48;5;95;38;5;95m█�[0m�[0m
---                               �[38;5;95m▄�[48;5;95;38;5;137m▄�[48;5;187;38;5;187m████�[48;5;137;38;5;137m███�[48;5;95;38;5;95m█�[48;5;137;38;5;137m██�[48;5;95;38;5;95m█�[48;5;137;38;5;137m██�[48;5;95m▄�[49;38;5;95m▄�[0m �[48;5;95;38;5;95m█�[48;5;130;38;5;130m██████�[48;5;137;38;5;137m████�[48;5;95;38;5;95m█�[0m�[0m
---                            �[38;5;95m▄�[48;5;95m██�[48;5;137m▄▄�[48;5;187;38;5;187m████�[48;5;137;38;5;95m▄▄�[48;5;95;38;5;137m▄�[48;5;137m█�[38;5;95m▄�[48;5;95;38;5;137m▄�[48;5;137m████�[48;5;95;38;5;95m█�[0m �[48;5;95;38;5;95m█�[48;5;130;38;5;130m██████�[48;5;137;38;5;137m████�[48;5;95;38;5;95m█�[0m�[0m
---                                 �[48;5;187;38;5;187m███�[48;5;95m▄�[38;5;137m▄▄▄▄�[48;5;137m██████�[48;5;95;38;5;95m█�[49m▄�[48;5;95;38;5;130m▄�[48;5;130m██████�[48;5;137;38;5;137m███�[38;5;95m▄�[49m▀�[0m�[0m
---                                 �[48;5;187;38;5;95m▄�[38;5;187m████�[48;5;137;38;5;137m█�[38;5;95m▄�[48;5;95;38;5;137m▄�[48;5;137m█████�[48;5;95;38;5;95m█�[48;5;130;38;5;130m███████�[38;5;137m▄�[48;5;137m████�[48;5;95;38;5;95m█�[0m �[0m
---                                 �[48;5;95;38;5;95m█�[48;5;187;38;5;137m▄�[38;5;187m███�[48;5;95;38;5;95m█�[48;5;137;38;5;137m██████�[48;5;95m▄▄�[48;5;130m▄▄▄▄▄�[48;5;137m██████�[48;5;95;38;5;95m█�[0m  �[0m
---                               �[38;5;95m▄▄▄�[48;5;95;38;5;137m▄�[48;5;187m▄�[38;5;187m██�[48;5;95m▄�[48;5;137;38;5;95m▄�[38;5;137m█████�[38;5;95m▄�[38;5;137m███████████�[48;5;95;38;5;95m█�[0m   �[0m
---                             �[38;5;95m▀▀▀▀▀▀▀▀�[48;5;187m▄▄▄�[48;5;95;38;5;137m▄�[48;5;137m██�[38;5;95m▄�[49m▀�[0m �[38;5;95m▀▀�[48;5;137m▄▄▄▄▄▄�[49m▀▀▀�[0m    �[0m
---                                   �[38;5;95m▀▀▀▀▀▀▀▀▀�[0m                 �[0m
---                                                                     ]]))
--- ```
--- 
--- 
--- 
--- 
--- Note: 
---  Available in Mudlet 3.0+
function ansi2decho(text, default_colour)
end

---  Strips ANSI colour sequences from a string (text)
--- See also:
--- see: ansi2decho()
--- ## Parameters
--- * `text:`
---  String that contains ANSI colour sequences that should be removed.
--- 
--- ## Return values
--- * `string text:`
---  The plain text without ANSI colour sequences.
--- 
--- Note: 
---  Available in Mudlet 4.10+
--- 
--- 
--- ## Example
--- ```lua
--- local replaced = ansi2string('\27[0;1;36;40mYou say in a baritone voice, "Test."\27[0;37;40m')
--- -- 'replaced' should now contain You say in a baritone voice, "Test."
--- print(replaced)
--- ```
function ansi2string(text)
end

---  Pastes the previously copied rich text (including text formats like color etc.) into user window name.
--- See also:
--- see: selectCurrentLine()
--- see: copy()
--- see: paste()
--- ## Parameters
--- * `name:`
---  The name of the user window to paste into. Passed as a string.
--- 
--- ## Example
--- ```lua
--- --selects and copies an entire line to user window named "Chat"
--- selectCurrentLine()
--- copy()
--- appendBuffer("Chat")
--- ```
function appendBuffer(name)
end

---  Changes the background color of the text. Useful for highlighting text.
---  See Also: [[Manual:Lua_Functions#fg|fg()]], [[Manual:Lua_Functions#setBgColor|setBgColor()]]
--- 
--- ## Parameters
--- * `window:`
---  The miniconsole to operate on - optional. If you'd like it to work on the main window, don't specify anything, or use `main` (since Mudlet 3.0).
--- * `colorName:`
---  The name of the color to set the background to. 
--- 
--- ## Example
--- ```lua
--- --This would change the background color of the text on the current line to magenta
--- selectCurrentLine()
--- bg("magenta")
--- 
--- -- or echo text with a green background to a miniconsole
--- bg("my window", "green")
--- echo("my window", "some green text\n")
--- ```
function bg(window, colorName)
end

---  Returns the average height and width of characters in a particular window, or a font name and size combination. Helpful if you want to size a miniconsole to specific dimensions.
---  Returns two numbers, width/height
--- See also:
--- see: setMiniConsoleFontSize()
--- see: getMainWindowSize()
--- ## Parameters
--- * `window_or_fontsize:`
---  The miniconsole or font size you are wanting to calculate pixel sizes for.
--- * `fontname:`
---  Specific font name (along with the size as the first argument) to calculate for.
--- 
--- Note: 
--- Window as an argument is available in Mudlet 3.10+, and font name in Mudlet 4.1+.
--- 
--- ## Example
--- ```lua
--- --this snippet will calculate how wide and tall a miniconsole designed to hold 4 lines of text 20 characters wide
--- --would need to be at 9 point font, and then changes miniconsole Chat to be that size
--- local width,height = calcFontSize(9)
--- width = width * 20
--- height = height * 4
--- resizeWindow("Chat", width, height)
--- ```
function calcFontSize(window_or_fontsize, fontname)
end

---  Echoes text that can be easily formatted with colour tags. You can also include unicode art in it - try some examples from [http://1lineart.kulaone.com/#/ 1lineart].
--- See also:
--- see: decho()
--- see: hecho()
--- see: creplaceLine()
--- ## Parameters
--- * `window:`
---  Optional - the window name to echo to - can either be none or "main" for the main window, or the miniconsoles name.
--- * `text:`
---  The text to display, with color names inside angle brackets <>, ie `<red>`. If you'd like to use a background color, put it after a colon : - `<:red>`. You can use the `<reset`> tag to reset to the default color. You can select any from this list: 
--- 
--- ## Example
--- ```lua
--- cecho("Hi! This text is <red>red, <blue>blue, <green> and green.")
--- 
--- cecho("<:green>Green background on normal foreground. Here we add an <ivory>ivory foreground.")
--- 
--- cecho("<blue:yellow>Blue on yellow text!")
--- 
--- -- \n adds a new line
--- cecho("<red>one line\n<green>another line\n<blue>last line")
--- 
--- cecho("myinfo", "<green>All of this text is green in the myinfo miniconsole.")
--- 
--- cecho("<green>(╯°□°）<dark_green>╯︵ ┻━┻")
--- 
--- cecho("°º¤ø,¸¸,ø¤º°`°º¤ø,¸,ø¤°º¤ø,¸¸,ø¤º°`°º¤ø,¸")
--- 
--- cecho([[
---  ██╗    ██╗     ██╗███╗   ██╗███████╗     █████╗ ██████╗ ████████╗
--- ███║    ██║     ██║████╗  ██║██╔════╝    ██╔══██╗██╔══██╗╚══██╔══╝
--- ╚██║    ██║     ██║██╔██╗ ██║█████╗      ███████║██████╔╝   ██║
---  ██║    ██║     ██║██║╚██╗██║██╔══╝      ██╔══██║██╔══██╗   ██║
---  ██║    ███████╗██║██║ ╚████║███████╗    ██║  ██║██║  ██║   ██║
---  ╚═╝    ╚══════╝╚═╝╚═╝  ╚═══╝╚══════╝    ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝
--- ]])
--- ```
function cecho(window, text)
end

---  Echos a piece of text as a clickable link, at the end of the current selected line - similar to [[Manual:Lua_Functions#cecho|cecho()]]. This version allows you to use colours within your link text.
--- 
--- See also:
--- see: echoLink()
--- see: dechoLink()
--- see: hechoLink()
--- ## Parameters
--- * `windowName:`
---  optional parameter, allows selection between sending the link to a miniconsole or the main window.
--- * `text:`
---  text to display in the echo. Same as a normal [[Manual:Lua_Functions#cecho|cecho()]].
--- * `command:`
---  lua code to do when the link is clicked.
--- * `hint:`
---  text for the tooltip to be displayed when the mouse is over the link.
--- * `true:`
---  requires argument for the colouring to work.
--- 
--- ## Example
--- ```lua
--- -- echo a link named 'press me!' that'll send the 'hi' command to the game
--- cechoLink("<red>press <brown:white>me!", [[send("hi")]], "This is a tooltip", true)
--- ```
function cechoLink(windowName, text, command, hint, true)
end

---  Creates text with a left-clickable link, and a right-click menu for more options at the end of the current line, like [[#cecho|cecho()]]. The added text, upon being left-clicked, will do the first command in the list. Upon being right-clicked, it'll display a menu with all possible commands. The menu will be populated with hints, one for each line.
--- 
--- ##  Parameters
--- * `windowName:`
---  (optional) name of the window to echo to. Use either `main` or omit for the main window, or the miniconsoles name otherwise.
--- * `text:`
---  the text to display
--- * `{commands}:`
---  a table of lua code strings to do. ie, ```lua" inline="
--- [[send("hello")]], [[echo("hi!"]]}```
--- * `{hints}:`
---  a table of strings which will be shown on the popup and right-click menu. ie, ```lua" inline="
--- "send the hi command", "echo hi to yourself"}```
--- * `useCurrentFormatElseDefault:`
---  (optional) a boolean value for using either the current formatting options (colour, underline, italic) or the link default (blue underline).
--- 
--- ## Example
--- ```lua
--- -- Create some text as a clickable with a popup menu:
--- cechoPopup("<red>activities<reset> to do", {[[send "sleep"]], [[send "sit"]], [[send "stand"]]}, {"sleep", "sit", "stand"}, true)
--- ```
--- 
--- Note:  Available in Mudlet 4.1+
function cechoPopup(windowName, text, {commands}, {hints}, useCurrentFormatElseDefault)
end

---  Echos a piece of text as a clickable link, at the end of the current cursor position - similar to [[#cinsertText|cinsertText()]]. This version allows you to use colours within your link text.
--- 
--- See also:
--- see: insertLink()
--- see: hinsertLink()
--- ## Parameters
--- * `windowName:`
---  optional parameter, allows selection between sending the link to a miniconsole or the main window.
--- * `text:`
---  text to display in the echo. Same as a normal [[Manual:Lua_Functions#cecho|cecho()]].
--- * `command:`
---  lua code to do when the link is clicked.
--- * `hint:`
---  text for the tooltip to be displayed when the mouse is over the link.
--- * `true:`
---  requires argument for the colouring to work.
--- 
--- ## Example
--- ```lua
--- -- echo a link named 'press me!' that'll send the 'hi' command to the game
--- cinsertLink("<red>press <brown:white>me!", [[send("hi")]], "This is a tooltip", true)
--- ```
--- 
--- Note:  Available in Mudlet 4.1+
function cinsertLink(windowName, text, command, hint, true)
end

---  Creates text with a left-clickable link, and a right-click menu for more options at the end of the current cursor position, like [[#cinsertText|cinsertText()]]. The added text, upon being left-clicked, will do the first command in the list. Upon being right-clicked, it'll display a menu with all possible commands. The menu will be populated with hints, one for each line.
--- 
--- ##  Parameters
--- * `windowName:`
---  (optional) name of the window to echo to. Use either `main` or omit for the main window, or the miniconsoles name otherwise.
--- * `text:`
---  the text to display
--- * `{commands}:`
---  a table of lua code strings to do. ie, ```lua" inline="
--- [[send("hello")]], [[echo("hi!"]]}```
--- * `{hints}:`
---  a table of strings which will be shown on the popup and right-click menu. ie, ```lua" inline="
--- "send the hi command", "echo hi to yourself"}```
--- * `useCurrentFormatElseDefault:`
---  (optional) a boolean value for using either the current formatting options (colour, underline, italic) or the link default (blue underline).
--- 
--- ## Example
--- ```lua
--- -- Create some text as a clickable with a popup menu:
--- cinsertPopup("<red>activities<reset> to do", {[[send "sleep"]], [[send "sit"]], [[send "stand"]]}, {"sleep", "sit", "stand"}, true)
--- ```
--- 
--- Note:  Available in Mudlet 4.1+
function cinsertPopup(windowName, text, {commands}, {hints}, useCurrentFormatElseDefault)
end

---  inserts text at the current cursor position, with the possibility for color tags.
---  See Also: [[Manual:Lua_Functions#cecho|cecho()]], [[Manual:UI Functions#creplaceLine|creplaceLine()]]
--- 
--- ## Parameters
--- * `window:`
---  Optional - the window name to echo to - can either be none or "main" for the main window, or the miniconsoles name.
--- * `text:`
---  The text to display, with color names inside angle brackets <>, ie `<red>`. If you'd like to use a background color, put it after a double colon : - `<:red>`. You can use the `<reset`> tag to reset to the default color. You can select any from this list: 
--- 
--- ## Example
--- ```lua
--- cinsertText("Hi! This text is <red>red, <blue>blue, <green> and green.")
--- 
--- cinsertText("<:green>Green background on normal foreground. Here we add an <ivory>ivory foreground.")
--- 
--- cinsertText("<blue:yellow>Blue on yellow text!")
--- 
--- cinsertText("myinfo", "<green>All of this text is green in the myinfo miniconsole.")
--- ```
function cinsertText(window, text)
end

---  This is (now) identical to [[Manual:Lua_Functions#clearWindow|clearWindow()]].
function clearUserWindow(name)
end

---  Clears the label, mini console, or user window with the name given as argument (removes all text from it). If you don't give it a name, it will clear the main window (starting with Mudlet 2.0-test3+)
--- 
--- ## Parameters
--- * `windowName:`
---  (optional) The name of the label, mini console, or user window to clear. Passed as a string.
--- 
--- ## Example
--- ```lua
--- --This would clear a label, user window, or miniconsole with the name "Chat"
--- clearWindow("Chat")
--- ```
--- 
--- ```lua
--- -- this can clear your whole main window - needs Mudlet version >= 2.0
--- clearWindow()
--- ```
function clearWindow(windowName)
end

---  Copies the current selection to the lua virtual clipboard. This function operates on rich text, i. e. the selected text including all its format codes like colors, fonts etc. in the lua virtual clipboard until it gets overwritten by another copy operation.
--- See also:
--- see: selectString()
--- see: selectCurrentLine()
--- see: paste()
--- see: appendBuffer()
--- see: replace()
--- see: createMiniConsole()
--- see: openUserWindow()
--- ##  Parameters
--- * `windowName` (optional):
---   the window from which to copy text - use the main console if not specified.
--- 
--- ## Example
--- ```lua
--- -- This script copies the current line on the main screen to a window (miniconsole or userwindow) called 'chat' and gags the output on the main screen.
--- selectString(line, 1)
--- copy()
--- appendBuffer("chat")
--- replace("This line has been moved to the chat window!")
--- ```
function copy(windowName)
end

---  Copies a string from the current line of window, including color information in decho format.
--- {{Note}} Available in Mudlet 4.8+
--- 
--- ##  Parameters
--- * `window` (optional):
---   the window to copy the text from. Defaults to "main".
--- * `stringToCopy` (optional): 
---   the string to copy. Defaults to copying the entire line.
--- * `instanceToCopy` (optional):
---   the instance of the string to copy. Defaults to 1.
--- 
--- ## Example
--- ```lua
--- -- This copies the current line on the main console and dechos it to a miniconsole named "test"
--- decho("test", copy2decho())
--- ```
--- 
--- ```lua
--- -- This when put into a trigger would copy matches[2] with color information and decho it to a Geyser miniconsole stored as the variable enemylist
--- enemylist:decho(copy2decho(matches[2]))
--- ```
function copy2decho(window, stringToCopy, instanceToCopy)
end

---  Copies a string from the current line of window, including color information in html format for echoing to a label.
--- {{Note}} Available in Mudlet 4.8+
--- 
--- ##  Parameters
--- * `window` (optional):
---   the window to copy the text from. Defaults to "main"
--- * `stringToCopy` (optional): 
---   the string to copy. Defaults to copying the entire line
--- * `instanceToCopy` (optional):
---   the instance of the string to copy. Defaults to 1
--- 
--- ## Example
--- ```lua
--- -- This copies the current line on the main console and echos it to a label named "TestLabel"
--- echo("TestLabel", copy2html())
--- ```
--- 
--- ```lua
--- -- This when put into a trigger would copy matches[2] with color information and echo it to a Geyser label stored as the variable enemylist
--- enemylist:echo(copy2html(matches[2]))
--- ```
function copy2html(window, stringToCopy, instanceToCopy)
end

---  Creates a named buffer for formatted text, much like a miniconsole, but the buffer is not intended to be shown on the screen - use it for formatting text or storing formatted text.
--- 
--- See also:
--- see: selectString()
--- see: selectCurrentLine()
--- see: copy()
--- see: paste()
--- ## Parameters
--- * `name:`
---  The name of the buffer to create.
--- 
--- ## Example
--- ```lua
--- --This creates a named buffer called "scratchpad"
--- createBuffer("scratchpad")
--- ```
function createBuffer(name)
end

---  Creates a new command line inside the main window of Mudlet. If only a command line inside a miniConsole/UserWindow is needed see [[Manual:UI_Functions#enableCommandLine|enableCommandLine()]].
---  You can use [[Manual:Mudlet_Object_Functions#appendCmdLine|appendCmdLine()]] / [[Manual:Mudlet_Object_Functions#getCmdLine|getCmdLine()]] and other command line functions to customize the input.
--- Note:  [[Manual:UI_Functions#setCmdLineAction|setCmdLineAction]] allows you to attach an action to your command line input.
--- 
---  Returns true or false.
--- 
--- See also:
--- see: enableCommandLine()
--- see: disableCommandLine()
--- see: clearCmdLine()
--- see: getCmdLine()
--- see: printCmdLine()
--- see: appendCmdLine()
--- ## Parameters
--- * `name of userwindow:`
---  Name of userwindow the command line is created in. Optional, defaults to the main window if not provided.
--- * `name:`
---  The name of the command line. Must be unique. Passed as a string.
--- * `x`, `y`, `width`, `height`
---  Parameters to set set the command line size and location - it is also possible to set them by using [[Manual:Lua_Functions#moveWindow|moveWindow()]] and [[Manual:Lua_Functions#resizeWindow|resizeWindow()]], as createCommandLine() will only set them once.
--- 
--- Note:  available in Mudlet 4.10+
function createCommandLine(name_of_userwindow, name, x, y, width, height)
end

---  Makes a new miniconsole which can be sized based upon the width of a 'W' character and the extreme top and bottom positions any character of the font should use. The background will be black, and the text color white.
--- 
--- ## Parameters
--- * `name of userwindow:`
---  Name of userwindow your new miniconsole is created in. Optional, defaults to the main window if not provided.
--- * `consoleName:`
---  The name of your new miniconsole. Passed as a string.
--- * `fontSize:`
---  The font size to use for the miniconsole. Passed as an integer number.
--- * `charsPerLine:`
---  How many characters wide to make the miniconsole. Passed as an integer number.
--- * `numberOfLines:`
---  How many lines high to make the miniconsole. Passed as an integer number.
--- * `Xpos:`
---  X position of miniconsole. Measured in pixels, with 0 being the very left. Passed as an integer number.
--- * `Ypos:`
---  Y position of miniconsole. Measured in pixels, with 0 being the very top. Passed as an integer number.
--- 
--- Note: 
--- userwindow argument only available in 4.6.1+
--- 
--- ## Example
--- ```lua
--- -- this will create a console with the name of "myConsoleWindow", font size 8, 80 characters wide,
--- -- 20 lines high, at coordinates 300x,400y
--- createConsole("myConsoleWindow", 8, 80, 20, 200, 400)
--- ```
--- 
--- Note: 
---  `(For Mudlet Makers)` This function is implemented outside the application's core via the **GUIUtils.lua** file of the Mudlet supporting Lua code using [[Manual:UI_Functions#createMiniConsole|createMiniConsole()]] and other functions to position and size the mini-console and configure the font.
function createConsole(name_of_userwindow, consoleName, fontSize, charsPerLine, numberOfLines, Xpos, Ypos)
end

--- ## createGauge([name of userwindow], name, width, height, Xpos, Ypos, gaugeText, colorName, orientation)
---  Creates a gauge that you can use to express completion with. For example, you can use this as your healthbar or xpbar.
--- See also:
--- see: moveGauge()
--- see: setGauge()
--- see: setGaugeText()
--- see: setGaugeStyleSheet()
--- ## Parameters
--- * `name of userwindow:`
---  Name of userwindow the gauge is created in. Optional, defaults to the main window if not provided.
--- * `name:`
---  The name of the gauge. Must be unique, you can not have two or more gauges with the same name. Passed as a string.
--- * `width:`
---  The width of the gauge, in pixels. Passed as an integer number.
--- * `height:`
---  The height of the gauge, in pixels. Passed as an integer number.
--- * `Xpos:`
---  X position of gauge. Measured in pixels, with 0 being the very left. Passed as an integer number.
--- * `Ypos:`
---  Y position of gauge. Measured in pixels, with 0 being the very top. Passed as an integer number.
--- * `gaugeText:`
---  Text to display on the gauge. Passed as a string, unless you do not wish to have any text, in which case you pass nil
--- * `r:`
---  The red component of the gauge color. Passed as an integer number from 0 to 255
--- * `g:`
---  The green component of the gauge color. Passed as an integer number from 0 to 255
--- * `b:`
---  The blue component of the gauge color. Passed as an integer number from 0 to 255
--- * `colorName:`
---  the name of color for the gauge. Passed as a string.
--- * `orientation:`
---  the gauge orientation. Can be horizontal, vertical, goofy, or batty.
--- 
--- Note: 
--- userwindow argument only available in 4.6.1+
--- 
--- ## Example
--- ```lua
--- -- This would make a gauge at that's 300px width, 20px in height, located at Xpos and Ypos and is green.
--- -- The second example is using the same names you'd use for something like [[fg]]() or [[bg]]().
--- createGauge("healthBar", 300, 20, 30, 300, nil, 0, 255, 0)
--- createGauge("healthBar", 300, 20, 30, 300, nil, "green")
--- 
--- 
--- -- If you wish to have some text on your label, you'll change the nil part and make it look like this:
--- createGauge("healthBar", 300, 20, 30, 300, "Now with some text", 0, 255, 0)
--- -- or
--- createGauge("healthBar", 300, 20, 30, 300, "Now with some text", "green")
--- ```
--- 
--- Note: 
---  If you want to put text on the back of the gauge when it's low, use an echo with the <gauge name>_back.
--- ```lua
--- echo("healthBar_back", "This is a test of putting text on the back of the gauge!")
--- ```
function createGauge(name_of_userwindow, name, width, height, Xpos, Ypos, gaugeText, r, g, b, orientation)
end

---  Creates a highly manipulable overlay which can take some css and html code for text formatting. Labels are clickable, and as such can be used as a sort of button. Labels are meant for small variable or prompt displays, messages, images, and the like. You should not use them for larger text displays or things which will be updated rapidly and in high volume, as they are much slower than miniconsoles.
---  Returns true or false.
--- See also:
--- see: hideWindow()
--- see: showWindow()
--- see: resizeWindow()
--- see: setLabelClickCallback()
--- see: setTextFormat()
--- see: getTextFormat()
--- see: moveWindow()
--- see: setBackgroundColor()
--- see: getMainWindowSize()
--- see: calcFontSize()
--- see: deleteLabel()
--- ## Parameters
--- * `name of userwindow:`
---  Name of userwindow label is created in. Optional, defaults to the main window if not provided.
--- * `name:`
---  The name of the label. Must be unique, you can not have two or more labels with the same name. Passed as a string.
--- * `Xpos:`
---  X position of the label. Measured in pixels, with 0 being the very left. Passed as an integer number.
--- * `Ypos:`
---  Y position of the label. Measured in pixels, with 0 being the very top. Passed as an integer number.
--- * `width:`
---  The width of the label, in pixels. Passed as an integer number.
--- * `height:`
---  The height of the label, in pixels. Passed as an integer number.
--- * `fillBackground:`
---  Whether or not to display the background. Passed as integer number (1 or 0) or as boolean (true, false). 1 or true will display the background color, 0 or false will not.
--- * `enableClickthrough:`
---  Whether or not enable clickthrough on this label. Passed as integer number (1 or 0) or as boolean (true, false). 1 or true will enable clickthrough, 0 or false will not. Optional, defaults to clickthrough not enabled if not provided.
--- 
--- Note: 
--- userwindow argument only available in 4.6.1+
--- 
--- ## Example
--- 
--- ```lua
--- -- a label situated at x=300 y=400 with dimensions 100x200
--- createLabel("a very basic label",300,400,100,200,1)
--- ```
--- 
--- ```lua
--- -- this example creates a transparent overlay message box to show a big warning message "You are under attack!" in the middle
--- -- of the screen. Because the background color has a transparency level of 150 (0-255, with 0 being completely transparent
--- -- and 255 opaque) the background text can still be read through.
--- local width, height = getMainWindowSize()
--- createLabel("messageBox",(width/2)-300,(height/2)-100,250,150,1)
--- resizeWindow("messageBox",500,70)
--- moveWindow("messageBox", (width/2)-300,(height/2)-100 )
--- setBackgroundColor("messageBox", 255, 204, 0, 200)
--- echo("messageBox", [[<p style="font-size:35px"><b><center><font color="red">You are under attack!</font></center></b></p>]])
--- 
--- -- you can also make it react to clicks!
--- mynamespace = {
---   messageBoxClicked = function()
---     echo("hey you've clicked the box!\n")
---   end
--- }
--- 
--- setLabelClickCallback("messageBox", "mynamespace.messageBoxClicked")
--- 
--- 
--- -- uncomment code below to make it also hide after a short while
--- -- tempTimer(2.3, [[hideWindow("messageBox")]] ) -- close the warning message box after 2.3 seconds
--- ```
function createLabel(name_of_userwindow, name, Xpos, Ypos, width, height, fillBackground, enableClickthrough)
end

---  Opens a miniconsole window inside the main window of Mudlet. This is the ideal fast colored text display for everything that requires a bit more text, such as status screens, chat windows, etc. Unlike labels, you cannot have transparency in them.
---  You can use [[Manual:Lua_Functions#clearWindow|clearWindow()]] / [[Manual:Lua_Functions#moveCursor|moveCursor()]] and other functions for this window for custom printing as well as copy & paste functions for colored text copies from the main window. [[Manual:Lua_Functions#setWindowWrap|setWindowWrap()]] will allow you to set word wrapping, and move the main window to make room for miniconsole windows on your screen (if you want to do this as you can also layer mini console and label windows) see [[Manual:Lua_Functions#setBorderSizes|setBorderSizes()]], [[Manual:Lua_Functions#setBorderColor|setBorderColor()]] functions.
--- 
---  Returns true or false.
--- 
--- See also:
--- see: createLabel()
--- see: hideWindow()
--- see: showWindow()
--- see: resizeWindow()
--- see: setTextFormat()
--- see: getTextFormat()
--- see: moveWindow()
--- see: setMiniConsoleFontSize()
--- see: handleWindowResizeEvent()
--- see: setBorderSizes()
--- see: setWindowWrap()
--- see: getMainWindowSize()
--- see: setMainWindowSize()
--- see: calcFontSize()
--- ## Parameters
--- * `name of userwindow:`
---  Name of userwindow the miniconsole is created in. Optional, defaults to the main window if not provided.
--- * `name:`
---  The name of the miniconsole. Must be unique. Passed as a string.
--- * `x`, `y`, `width`, `height`
---  Parameters to set set the window size and location - in 2.1 and below it's best to set them via [[Manual:Lua_Functions#moveWindow|moveWindow()]] and [[Manual:Lua_Functions#resizeWindow|resizeWindow()]], as createMiniConsole() will only set them once. Starting with 3.0, however, that is fine and calling createMiniConsole() will re-position your miniconsole appropriately.
--- 
--- Note: 
--- userwindow argument only available in 4.6.1+
--- 
--- ## Example
function createMiniConsole(name_of_userwindow, name, x, y, width, height)
end

---  Replaces the output line from the MUD with a colour-tagged string.
--- See Also: [[Manual:Lua_Functions#cecho|cecho()]], [[Manual:Lua_Functions#cinsertText|cinsertText()]]
--- ## Parameters
--- * `window:`
--- *: The window to replace the selection in. Optional, defaults to the main window if not provided.
--- * `text:`
--- *: The text to display, with color names inside angle brackets as with [[Manual:Lua_Functions#cecho|cecho()]]. You can select any from this list: 
--- 
--- 
--- ## Example
--- ```lua
--- selectCaptureGroup(1)
--- creplace("<magenta>[ALERT!]: <reset>"..matches[2])
--- ```
function creplace(window, text)
end

---  Replaces the output line from the MUD with a colour-tagged string.
--- See Also: [[Manual:Lua_Functions#cecho|cecho()]], [[Manual:Lua_Functions#cinsertText|cinsertText()]]
--- ## Parameters
--- * `text:`
--- *: The text to display, with color names inside angle brackets <>, ie `<red>`. If you'd like to use a background color, put it after a colon : - `<:red>`. You can use the `<reset`> tag to reset to the default color. You can select any from this list: 
--- 
--- 
--- ## Example
---  ```lua
--- replaceLine("<magenta>[ALERT!]: <reset>"..line)
---  ```
function creplaceLine(text)
end

---  Color changes can be made using the format <FR,FG,FB:BR,BG,BB,[BA]> where each field is a number from 0 to 255. The background portion can be omitted using <FR,FG,FB> or the foreground portion can be omitted using <:BR,BG,BB,[BA]>. Arguments 2 and 3 set the default fore and background colors for the string using the same format as is used within the string, sans angle brackets, e.g. `decho("<50,50,0:0,255,0>test")`.
--- 
--- See also:
--- see: cecho()
--- see: hecho()
--- ## Parameters
--- * `name of console`
---  (Optional) Name of the console to echo to. If no name is given, this will defaults to the main window.
--- * `text:`
---  The text that you’d like to echo with embedded color tags. Tags take the RGB values only, see below for an explanation.
--- 
--- 
--- Note: 
--- Optional background transparancy parameter (BA) available in Mudlet 4.10+
--- 
--- ## Example
--- ```lua
--- decho("<50,50,0:0,255,0>test")
--- 
--- decho("miniconsolename", "<50,50,0:0,255,0>test")
--- ```
function decho(name_of_console, text)
end

---  Echos a piece of text as a clickable link, at the end of the current selected line - similar to [[Manual:Lua_Functions#decho|decho()]]. This version allows you to use colours within your link text.
--- 
--- ## Parameters
--- * `windowName:`
---  (optional) allows selection between sending the link to a miniconsole or the "main" window.
--- * `text:`
---  text to display in the echo. Same as a normal [[Manual:Lua_Functions#decho|decho()]].
--- * `command:`
---  lua code to do when the link is clicked.
--- * `hint:`
---  text for the tooltip to be displayed when the mouse is over the link.
--- * `true:`
---  requires argument for the colouring to work.
--- 
--- ## Example
--- ```lua
--- -- echo a link named 'press me!' that'll send the 'hi' command to the game
--- dechoLink("<50,50,0:0,255,0>press me!", [[send("hi")]], "This is a tooltip", true)
--- ```
function dechoLink(windowName, text, command, hint, true)
end

---  Creates text with a left-clickable link, and a right-click menu for more options at the end of the current line, like [[#decho|decho()]]. The added text, upon being left-clicked, will do the first command in the list. Upon being right-clicked, it'll display a menu with all possible commands. The menu will be populated with hints, one for each line.
--- 
--- ##  Parameters
--- * `windowName:`
---  (optional) name of the window to echo to. Use either `main` or omit for the main window, or the miniconsoles name otherwise.
--- * `text:`
---  the text to display
--- * `{commands}:`
---  a table of lua code strings to do. ie, ```lua" inline="
--- [[send("hello")]], [[echo("hi!"]]}```
--- * `{hints}:`
---  a table of strings which will be shown on the popup and right-click menu. ie, ```lua" inline="
--- "send the hi command", "echo hi to yourself"}```
--- * `useCurrentFormatElseDefault:`
---  (optional) a boolean value for using either the current formatting options (colour, underline, italic) or the link default (blue underline).
--- 
--- ## Example
--- ```lua
--- -- Create some text as a clickable with a popup menu:
--- dechoPopup("<255,0,0>activities<r> to do", {[[send "sleep"]], [[send "sit"]], [[send "stand"]]}, {"sleep", "sit", "stand"}, true)
--- ```
--- 
--- Note:  Available in Mudlet 4.1+
function dechoPopup(windowName, text, {commands}, {hints}, useCurrentFormatElseDefault)
end

---  Echos a piece of text as a clickable link, at the end of the current cursor position - similar to [[#dinsertText|dinsertText()]]. This version allows you to use colours within your link text.
--- 
--- See also:
--- see: insertLink()
--- see: hinsertLink()
--- ## Parameters
--- * `windowName:`
---  optional parameter, allows selection between sending the link to a miniconsole or the main window.
--- * `text:`
---  text to display in the echo. Same as a normal [[Manual:Lua_Functions#decho|decho()]].
--- * `command:`
---  lua code to do when the link is clicked.
--- * `hint:`
---  text for the tooltip to be displayed when the mouse is over the link.
--- * `true:`
---  requires argument for the colouring to work.
--- 
--- ## Example
--- ```lua
--- -- echo a link named 'press me!' that'll send the 'hi' command to the game
--- dinsertLink("<255,0,0>press <165,42,42:255,255,255>me!", [[send("hi")]], "This is a tooltip", true)
--- ```
--- 
--- Note:  Available in Mudlet 4.1+
function dinsertLink(windowName, text, command, hint, true)
end

---  Creates text with a left-clickable link, and a right-click menu for more options at the end of the current cursor position, like [[#dinsertText|dinsertText()]]. The added text, upon being left-clicked, will do the first command in the list. Upon being right-clicked, it'll display a menu with all possible commands. The menu will be populated with hints, one for each line.
--- 
--- ##  Parameters
--- * `windowName:`
---  (optional) name of the window to echo to. Use either `main` or omit for the main window, or the miniconsoles name otherwise.
--- * `text:`
---  the text to display
--- * `{commands}:`
---  a table of lua code strings to do. ie, ```lua" inline="
--- [[send("hello")]], [[echo("hi!"]]}```
--- * `{hints}:`
---  a table of strings which will be shown on the popup and right-click menu. ie, ```lua" inline="
--- "send the hi command", "echo hi to yourself"}```
--- * `useCurrentFormatElseDefault:`
---  (optional) a boolean value for using either the current formatting options (colour, underline, italic) or the link default (blue underline).
--- 
--- ## Example
--- ```lua
--- -- Create some text as a clickable with a popup menu:
--- dinsertPopup("<255,0,0>activities<r> to do", {[[send "sleep"]], [[send "sit"]], [[send "stand"]]}, {"sleep", "sit", "stand"}, true)
--- ```
--- 
--- Note:  Available in Mudlet 4.1+
function dinsertPopup(windowName, text, {commands}, {hints}, useCurrentFormatElseDefault)
end

--- 
---  Deletes and removes a label from the screen. Note that if you'd like to show the label again, it is much more performant to hide/show it instead.
--- 
---  Note that you shouldn't use the Geyser label associated with the label you delete afterwards - that doesn't make sense and Geyser right now wouldn't know that it's been deleted, either.
--- 
--- See also:
--- see: hideWindow()
--- see: showWindow()
--- see: createLabel()
--- ##  Parameters
--- 
--- * `labelName`: name of the label to delete.
--- 
--- ```lua
--- createLabel("a very basic label",300,400,100,200,1)
--- setBackgroundColor("a very basic label", 255, 204, 0, 200)
--- 
--- -- delete the label after 3 seconds
--- tempTimer(3, function()
---   deleteLabel("a very basic label")
--- end)
--- ```
--- 
--- {{Note}} Available in Mudlet 4.5+
function deleteLabel(labelName)
end

---  Deletes the current line under the user cursor. This is a high speed gagging tool and is very good at this task, but is only meant to be use when a line should be omitted entirely in the output. If you echo() to that line it will not be shown, and lines deleted with deleteLine() are simply no longer rendered. This is purely visual - triggers will still fire on the line as expected.
--- See also:
--- see: replace()
--- see: wrapLine()
--- ## Parameters
--- * `windowName:`
---  (optional) name of the window to delete the line in. If no name is given, it just deletes the line it is used on.
--- 
--- Note:  for replacing text, [[Manual:Lua_Functions#replace|replace()]] is the proper option; doing the following: <code>selectCurrentLine(); replace(""); cecho("new line!\n")</code> is better.
--- 
--- ## Example
--- ```lua
--- -- deletes the line - just put this command into the big script box. Keep the case the same -
--- -- it has to be deleteLine(), not Deleteline(), deleteline() or anything else
--- deleteLine()
--- 
--- --This example creates a temporary line trigger to test if the next line is a prompt, and if so gags it entirely.
--- --This can be useful for keeping a pile of prompts from forming if you're gagging chat channels in the main window
--- --Note: isPrompt() only works on servers which send a GA signal with their prompt.
--- tempLineTrigger(1, 1, [[if isPrompt() then deleteLine() end]])
--- 
--- -- example of deleting multiple lines:
--- deleteLine()                            -- delete the current line
--- moveCursor(0,getLineNumber()-1)         -- move the cursor back one line
--- deleteLine()                            -- delete the previous line now
--- ```
function deleteLine(windowName)
end

---  This is used to clear the current selection (to no longer have anything selected). Should be used after changing the formatting of text, to keep from accidentally changing the text again later with another formatting call.
--- See also:
--- see: selectString()
--- see: selectCurrentLine()
--- ## Parameters
--- * `window name:`
---  (optional) The name of the window to stop having anything selected in. If name is not provided the main window will have its selection cleared.
--- 
--- ## Example
--- ```lua
--- --This will change the background on an entire line in the main window to red, and then properly clear the selection to keep further
--- --changes from effecting this line as well.
--- selectCurrentLine()
--- bg("red")
--- deselect()
--- ```
function deselect(window_name)
end

---  Disables clickthrough for a label - making it act 'normal' again and receive clicks, doubleclicks, onEnter, and onLeave events. This is the default behaviour for labels.
--- See also:
--- see: enableClickthrough()
--- ## Parameters
--- * `label:`
---  Name of the label to restore clickability on.
--- 
--- Note: 
--- Available since Mudlet 3.17
function disableClickthrough(label)
end

---  Disables the command line for the miniConsole named `windowName`
---  See Also: [[Manual:Lua_Functions#enableCommandLine|enableCommandLine()]]
--- 
--- ## Parameters
--- * `windowName:`
---  The name of the miniConsole to disable the command line in.
--- 
--- Note: 
--- Available in Mudlet 4.10
function disableCommandLine(windowName)
end

---  Disables the horizontal scroll bar for the miniConsole/userwindow `windowName` or the main window
---  See Also: [[Manual:Lua_Functions#enableHorizontalScrollBar|enableHorizontalScrollBar()]]
--- 
--- ## Parameters
--- * `windowName:`
---  The name of the window to disable the scroll bar in. If "main" or not provided it is the main console.
--- 
--- Note:  available in Mudlet 4.10+
function disableHorizontalScrollBar(windowName)
end

---  Disables the scroll bar for the miniConsole/userwindow `windowName` or the main window
---  See Also: [[Manual:Lua_Functions#enableScrollBar|enableScrollBar()]]
--- 
--- ## Parameters
--- * `windowName:`
---  (optional) The name of the window to disable the scroll bar in. If "main" or not provided it is the main console.
function disableScrollBar(windowName)
end

---  Replaces the output line from the MUD with a colour-tagged string.
--- See Also: [[Manual:Lua_Functions#decho|decho()]], [[Manual:Lua_Functions#dinsertText|dinsertText()]]
--- ## Parameters
--- * `window:`
--- *: The window to replace the selection in. Optional, defaults to the main window if not provided.
--- * `text:`
--- *: The text to display, as with [[Manual:Lua_Functions#decho|decho()]]
--- 
--- 
--- ## Example
---  ```lua
---     selectCaptureGroup(1)
---     dreplace("<255,0,255>[ALERT!]: <r>"..matches[2])
---  ```
function dreplace(window, text)
end

---  Echos a piece of text as a clickable link, at the end of the current selected line - similar to [[Manual:Lua_Functions#echo|echo()]].
--- 
--- See also:
--- see: cechoLink()
--- see: hechoLink()
--- ## Parameters
--- * `windowName:`
---  (optional) either be none or "main" for the main console, or a miniconsole / userwindow name.
--- * `text:`
---  Text to display in the echo. Same as a normal echo().
--- * `command:`
---  Lua code to do when the link is clicked.
--- * `hint:`
---  Text for the tooltip to be displayed when the mouse is over the link.
--- * `useCurrentFormatElseDefault:`
---  If true, then the link will use the current selection style (colors, underline, etc). If missing or false, it will use the default link style - blue on black underlined text.
--- 
--- ## Example
--- ```lua
--- -- echo a link named 'press me!' that'll send the 'hi' command to the game
--- echoLink("press me!", [[send("hi")]], "This is a tooltip")
--- 
--- -- do the same, but send this link to a miniConsole
--- echoLink("my miniConsole", "press me!", [[send("hi")]], "This is a tooltip")
--- ```
function echoLink(windowName, text, command, hint, useCurrentFormatElseDefault)
end

--- This function will print text to both mini console windows, dock windows and labels. It is outdated however - [[#echo|echo()]] instead.
function echoUserWindow(windowName)
end

---  Creates text with a left-clickable link, and a right-click menu for more options at the end of the current line, like echo. The added text, upon being left-clicked, will do the first command in the list. Upon being right-clicked, it'll display a menu with all possible commands. The menu will be populated with hints, one for each line.
--- 
--- ##  Parameters
--- * `windowName:`
---  (optional) name of the window to echo to. Use either `main` or omit for the main window, or the miniconsoles name otherwise.
--- * `text:`
---  the text to display
--- * `{commands}:`
---  a table of lua code strings to do. ie, ```lua" inline="
--- [[send("hello")]], [[echo("hi!"]]}```
--- * `{hints}:`
---  a table of strings which will be shown on the popup and right-click menu. ie, ```lua" inline="
--- "send the hi command", "echo hi to yourself"}```
--- * `useCurrentFormatElseDefault:`
---  (optional) a boolean value for using either the current formatting options (colour, underline, italic) or the link default (blue underline).
--- 
--- ## Example
--- ```lua
--- -- Create some text as a clickable with a popup menu:
--- echoPopup("activities to do", {[[send "sleep"]], [[send "sit"]], [[send "stand"]]}, {"sleep", "sit", "stand"})
--- ```
function echoPopup(windowName, text, {commands}, {hints}, useCurrentFormatElseDefault)
end

---  Make a label 'invisible' to clicks - so if you have another label underneath, it'll be clicked on instead of this one on top.
---  This affects clicks, double-clicks, right-clicks, as well as the onEnter/onLeave events.
--- See also:
--- see: disableClickthrough()
--- ## Parameters
--- * `label:`
---  The name of the label to enable clickthrough on.
--- 
--- Note: 
--- Available since Mudlet 3.17
function enableClickthrough(label)
end

---  Enables the command line for the miniConsole named `windowName`
---  See Also: [[Manual:Lua_Functions#disableCommandLine|disableCommandLine()]]
--- 
--- ## Parameters
--- * `windowName:`
---  The name of the miniConsole to enable the command line in.
--- 
--- Note:  The command line name is the same as the miniConsole name
--- 
--- Note:  available in Mudlet 4.10+
function enableCommandLine(windowName)
end

---  Enables the horizontal scroll bar for the miniConsole/userwindow `windowName` or the main window
---  See Also: [[Manual:Lua_Functions#disableHorizontalScrollBar|disableHorizontalScrollBar()]]
--- 
--- ## Parameters
--- * `windowName:`
---  The name of the window to enable the scroll bar in. If "main" or not provided it is the main console.
--- 
--- Note:  available in Mudlet 4.10+
function enableHorizontalScrollBar(windowName)
end

---  Enables the scroll bar for the miniConsole/userwindow `windowName` or the main window
---  See Also: [[Manual:Lua_Functions#disableScrollBar|disableScrollBar()]]
--- 
--- ## Parameters
--- * `windowName:`
---  The name of the window to enable the scroll bar in. If "main" or not provided it is the main console.
function enableScrollBar(windowName)
end

---  If used on a selection, sets the foreground color to `colorName` - otherwise, it will set the color of the next text-inserting calls (`echo(), insertText, echoLink()`, and others)
---  See Also: [[Manual:Lua_Functions#bg|bg()]], [[Manual:Lua_Functions#setBgColor|setBgColor()]]
--- 
--- ## Parameters
--- * `window:`
---  (optional) name of the miniconsole to operate on. If you'd like it to work on the main window, don't specify anything or use `main` (since Mudlet 3.0).
--- * `colorName:`
---  The name of the color to set the foreground to - list of possible names: 
--- 
--- ## Example
--- ```lua
--- --This would change the color of the text on the current line to green
--- selectCurrentLine()
--- fg("green")
--- resetFormat()
--- 
--- --This will echo red, green, blue in their respective colors
--- fg("red")
--- echo("red ")
--- fg("green")
--- echo("green ")
--- fg("blue")
--- echo("blue ")
--- resetFormat()
--- 
--- -- example of working on a miniconsole
--- fg("my console", "red")
--- echo("my console", "red text")
--- ```
function fg(window, colorName)
end

---  This returns a "font - true" key-value list of available fonts which you can use to verify that Mudlet has access to a given font.
---  To install a new font with your package, include the font file in your zip/mpackage and it'll be automatically installed for you.
--- 
--- See also:
--- see: getFont()
--- see: setFont()
--- Note: 
--- Available since Mudlet 3.10
--- 
--- ## Example
--- ```lua
--- -- check if Ubuntu Mono is a font we can use
--- if getAvailableFonts()["Ubuntu Mono"] then
---   -- make the miniconsole use the font at size 16
---   setFont("my miniconsole", "Ubuntu Mono")
---   setFontSize("my miniconsole", 16)
--- end
--- ```
function getAvailableFonts()
end

---  This function returns the rgb values of the background color of the first character of the current selection on mini console (window) windowName. If windowName is omitted Mudlet will use the main screen.
--- 
--- See also:
--- see: setBgColor()
--- ## Parameters
--- * `windowName:`
---  A window to operate on - either a miniconsole or the main window.
--- 
--- ## Example
--- ```lua
--- local r,g,b;
--- selectString("troll",1)
--- r,g,b = getBgColor()
--- if r == 255 and g == 0 and b == 0 then
---     echo("HELP! troll is highlighted in red letters, the monster is aggressive!\n");
--- end
--- ```
--- 
--- With Mudlet 4.10, **getBgColor** returns a fourth integer: the number of (UTF-16) characters with the same color. You can use this length to efficiently split a line into same-color runs.
function getBgColor(windowName)
end

---  Returns the size of the bottom border of the main window in pixels. 
--- See also:
--- see: getBorderSizes()
--- see: setBorderBottom()
---  Note:  Available since Mudlet 4.0
--- 
--- ## Example
--- ```lua
--- setBorderBottom(150)
--- getBorderBottom()
--- -- returns: 150
--- ```
function getBorderBottom()
end

---  Returns the size of the left border of the main window in pixels. 
--- See also:
--- see: getBorderSizes()
--- see: setBorderLeft()
---  Note:  Available since Mudlet 4.0
--- 
--- ## Example
--- ```lua
--- setBorderLeft(5)
--- getBorderLeft()
--- -- returns: 5
--- ```
function getBorderLeft()
end

---  Returns the size of the right border of the main window in pixels. 
--- See also:
--- see: getBorderSizes()
--- see: setBorderRight()
---  Note:  Available since Mudlet 4.0
--- 
--- ## Example
--- ```lua
--- setBorderRight(50)
--- getBorderRight()
--- -- returns: 50
--- ```
function getBorderRight()
end

---  Returns the a named table with the sizes of all borders of the main window in pixels. 
--- See also:
--- see: setBorderSizes()
--- see: getBorderTop()
--- see: getBorderRight()
--- see: getBorderBottom()
--- see: getBorderLeft()
---  Note:  Available since Mudlet 4.0
--- 
--- ## Example
--- ```lua
--- setBorderSizes(100, 50, 150, 0)
--- getBorderSizes()
--- -- returns: { top = 100, right = 50, bottom = 150, left = 0 }
--- getBorderSizes().right
--- -- returns: 50
--- ```
function getBorderSizes()
end

---  Returns the size of the top border of the main window in pixels. 
--- See also:
--- see: getBorderSizes()
--- see: setBorderTop()
---  Note:  Available since Mudlet 4.0
--- 
--- ## Example
--- ```lua
--- setBorderTop(100)
--- getBorderTop()
--- -- returns: 100
--- ```
function getBorderTop()
end

---  Returns any text that is currently present in the clipboard. 
--- See also:
--- see:  setClipboardText()
---  Note:  Note: Available in Mudlet 4.10+
--- 
--- ## Example
--- ```lua
--- local clipboardContents = getClipboardText()
--- echo("Clipboard: " .. clipboardContents)
--- ```
function getClipboardText()
end

---  This function, given an ANSI color number ([[Manual:UI_Functions#isAnsiFgColor|list]]), will return all strings on the current line that match it.
--- 
--- See also:
--- see: isAnsiFgColor()
--- see: isAnsiBgColor()
--- ## Parameters
--- * `ansi color number:`
---  A color number ([[Manual:UI_Functions#isAnsiFgColor|list]]) to match.
--- 
--- ## Example
--- ```lua
--- -- we can run this script on a line that has the players name coloured differently to easily capture it from
--- -- anywhere on the line
--- local match = getColorWildcard(14)
--- 
--- if match then
---   echo("\nFound "..match.."!")
--- else
---   echo("\nDidn't find anyone.")
--- end
--- ```
function getColorWildcard(ansi_color_number)
end

---  Gets the maximum number of columns (characters) that a given window can display on a single row, taking into consideration factors such as window width, font size, spacing, etc.
--- 
--- ## Parameters:
--- * `windowName`:
---  (optional) name of the window whose number of columns we want to calculate. By default it operates on the main window.
--- 
--- Note: 
--- Available since Mudlet 3.7.0
--- 
--- ## Example
--- ```lua
--- print("Maximum number of columns on the main window "..getColumnCount())
--- ```
function getColumnCount(windowName)
end

---  Gets the absolute column number of the current user cursor.
--- 
--- ## Parameters
--- * `windowName:`
---  (optional) either be none or "main" for the main console, or a miniconsole / userwindow name.
--- 
--- Note:  the argument is available since Mudlet 3.0.
--- 
--- ## Example
--- ```lua
--- HelloWorld = Geyser.MiniConsole:new({
---   name="HelloWorld",
---   x="70%", y="50%",
---   width="30%", height="50%",
--- })
--- 
--- HelloWorld:echo("hello!\n")
--- HelloWorld:echo("hello!\n")
--- HelloWorld:echo("hello!\n")
--- 
--- moveCursor("HelloWorld", 3, getLastLineNumber("HelloWorld"))
--- -- should say 3, because we moved the cursor in the HellWorld window to the 3rd position in the line
--- print("getColumnNumber: "..tostring(getColumnNumber("HelloWorld")))
--- 
--- moveCursor("HelloWorld", 1, getLastLineNumber("HelloWorld"))
--- -- should say 3, because we moved the cursor in the HellWorld window to the 1st position in the line
--- print("getColumnNumber: "..tostring(getColumnNumber("HelloWorld")))
--- ```
function getColumnNumber(windowName)
end

---  Returns the content of the current line under the user cursor in the buffer. The Lua variable **line** holds the content of `getCurrentLine()` before any triggers have been run on this line. When triggers change the content of the buffer, the variable line will not be adjusted and thus hold an outdated string. `line = getCurrentLine()` will update line to the real content of the current buffer. This is important if you want to copy the current line after it has been changed by some triggers. `selectString( line,1 )` will return false and won't select anything because line no longer equals `getCurrentLine()`. Consequently, `selectString( getCurrentLine(), 1 )` is what you need.
--- 
--- ##  Parameters
--- * `windowName:`
---  (optional) name of the window in which to select text.
--- 
--- ## Example
--- ```lua
--- print("Currently selected line: "..getCurrentLine())
--- ```
function getCurrentLine(windowName)
end

---  This function returns the rgb values of the color of the first character of the current selection on mini console (window) windowName. If windowName is omitted Mudlet will use the main screen.
--- 
--- ## Parameters
--- * `windowName:`
---  A window to operate on - either a miniconsole or the main window.
--- 
--- ## Example
--- ```lua
--- selectString("troll",1)
--- local r,g,b = getFgColor()
--- if r == 255 and g == 0 and b == 0 then
---   echo("HELP! troll is written in red letters, the monster is aggressive!\n");
--- end
--- ```
--- 
--- With Mudlet 4.10, **getFgColor** returns a fourth integer: the number of (UTF-16) characters with the same color. You can use this length e.g. to efficiently split a line into same-color runs.
function getFgColor(windowName)
end

---  Gets the current font of the given window or console name. Can be used to get font of the main console, dockable userwindows and miniconsoles.
--- See also:
--- see: setFont()
--- see: setFontSize()
--- see: openUserWindow()
--- see: getAvailableFonts()
--- ## Parameters
--- * `windowName:`
---  The window name to get font size of - can either be none or "main" for the main console, or a miniconsole/userwindow name.
--- 
--- Note: 
--- Available in Mudlet 3.4+. Since Mudlet 3.10, returns the actual font that was used in case you didn't have the required font when using [[#setFont|setFont()]].
--- 
--- ## Example
--- ```lua
--- -- The following will get the "main" console font size.
--- display("Font in the main window: "..getFont())
--- 
--- display("Font in the main window: "..getFont("main"))
--- 
--- -- This will get the font size of a user window named "user window awesome".
--- display("Font size: " .. getFont("user window awesome"))
--- ```
function getFont(windowName)
end

---  Gets the current font size of the given window or console name. Can be used to get font size of the Main console as well as dockable UserWindows.
--- See also:
--- see: setFontSize()
--- see: openUserWindow()
--- ## Parameters
--- * `windowName:`
---  The window name to get font size of - can either be none or "main" for the main console, or a UserWindow name.
--- 
--- Note: 
--- Available in Mudlet 3.4+
--- 
--- ## Example
--- ```lua
--- -- The following will get the "main" console font size.
--- local mainWindowFontSize = getFontSize()
--- if mainWindowFontSize then
---     display("Font size: " .. mainWindowFontSize)
--- end
--- 
--- local mainWindowFontSize = getFontSize("main")
--- if mainWindowFontSize then
---     display("Font size: " .. fs2)
--- end
--- 
--- -- This will get the font size of a user window named "user window awesome".
--- local awesomeWindowFontSize = getFontSize("user window awesome")
--- if awesomeWindowFontSize then
---     display("Font size: " .. awesomeWindowFontSize)
--- end
--- ```
function getFontSize(windowName)
end

---  Returns the width and the height of the given image. If the image can't be found, loaded, or isn't a valid image file - nil+error message will be returned instead.
--- See also:
--- see: createLabel()
--- ## Parameters
--- * `imageLocation:`
---  Path to the image.
--- 
--- Note: 
--- Available in Mudlet 4.5+
--- 
--- ## Example
--- ```lua
--- local path = getMudletHomeDir().."/my-image.png"
--- 
--- cecho("Showing dimensions of the picture in: "..path.."\n")
--- 
--- local width, height = getImageSize(path)
--- 
--- if not width then
---   -- in case of an problem, we don't get a height back - but the error message
---   cecho("error: "..height.."\n")
--- else
---   cecho(string.format("They are: %sx%s", width, height))
--- end
--- ```
function getImageSize(imageLocation)
end

--- Returns the latest line's number in the main window or the miniconsole. This could be different from [[Manual:UI_Functions#getLineNumber|getLineNumber()]] if the cursor was moved around.
--- 
--- ## Parameters
--- * `windowName:`
---  name of the window to use. Either use `main` for the main window, or the name of the miniconsole.
--- 
--- ## Example
--- ```lua
--- -- get the latest line's # in the buffer
--- local latestline = getLastLineNumber("main")
--- ```
function getLastLineNumber(windowName)
end

--- Gets the absolute amount of lines in the current console buffer
--- 
--- ##  Parameters
--- None
--- 
--- ## Example
--- `Need example`
function getLineCount()
end

---  Returns a section of the content of the screen text buffer. Returns a Lua table with the content of the lines on a per line basis. The form value is `result = {relative_linenumber = line}`.
--- 
--- Absolute line numbers are used.
--- 
--- ## Parameters
--- * `windowName`
---  (optional) name of the miniconsole/userwindow to get lines for, or "main" for the main window (Mudlet 3.17+)
--- * `from_line_number:`
---  First line number
--- * `to_line_number:`
---  End line number
--- 
--- ## Example
--- ```lua
--- -- retrieve & echo the last line:
--- echo(getLines(getLineNumber()-1, getLineNumber())[1])
--- ```
--- 
--- ```lua
--- -- find out which server and port you are connected to (as per Mudlet settings dialog):
--- local t = getLines(0, getLineNumber())
--- 
--- local server, port
--- 
--- for i = 1, #t do
---   local s, p = t[i]:match("looking up the IP address of server:(.-):(%d+)")
---   if s then server, port = s, p break end
--- end
--- 
--- display(server)
--- display(port)
--- ```
function getLines(windowName, from_line_number, to_line_number)
end

---  Returns the absolute line number of the current user cursor (the y position). The cursor by default is on the current line the triggers are processing - which you can move around with [[Manual:Lua_Functions#moveCursor|moveCursor()]] and [[Manual:Lua_Functions#moveCursorEnd|moveCursorEnd()]]. This function can come in handy in combination when using with [[Manual:Lua_Functions#moveCursor|moveCursor()]] and [[Manual:Lua_Functions#getLines|getLines()]].
--- 
--- ## Parameters
--- * `windowName:`
---  (optional) name of the miniconsole to operate on. If you'd like it to work on the main window, don't specify anything.
--- 
--- Note: 
--- The argument is available since Mudlet 3.0.
--- 
--- ## Example
--- ```lua
--- -- use getLines() in conjuction with getLineNumber() to check if the previous line has a certain word
--- if getLines(getLineNumber()-1, getLineNumber())[1]:find("attacks") then echo("previous line had the word 'attacks' in it!\n") end
--- 
--- -- check how many lines you've got in your miniconsole after echoing some text.
--- -- Note the use of moveCursorEnd() to update getLineNumber()'s output
--- HelloWorld = Geyser.MiniConsole:new({
---   name="HelloWorld",
---   x="70%", y="50%",
---   width="30%", height="50%",
--- })
--- 
--- print(getLineNumber("HelloWorld"))
--- 
--- HelloWorld:echo("hello!\n")
--- HelloWorld:echo("hello!\n")
--- HelloWorld:echo("hello!\n")
--- 
--- -- update the cursors position, as it seems to be necessary to do
--- moveCursorEnd("HelloWorld")
--- print(getLineNumber("HelloWorld"))
--- ```
function getLineNumber(windowName)
end

---  Returns a single number; the width of the main console (game output) in pixels. This also accounts for any borders that have been set.
--- 
--- See also:
--- see: getMainWindowSize()
--- ##  Parameters
--- None
--- 
--- ## Example
--- ```lua
--- -- Save width of the main console to a variable for future use.
--- consoleWidth = getMainConsoleWidth()
--- ```
function getMainConsoleWidth()
end

---  Returns the coordinates of the mouse's position, relative to the Mudlet window itself.
--- 
--- ##  Parameters
--- None
--- 
--- Note:  Available since Mudlet 3.1+
--- 
--- ## Example
--- ```lua
--- -- Retrieve x and y position of the mouse to determine where to create a new label, then use that position to create a new label
--- local x, y = getMousePosition()
--- createLabel("clickGeneratedLabel", x, y, 100, 100, 1)
--- -- if the label already exists, just move it
--- moveWindow("clickGeneratedLabel", x, y)
--- -- and make it easier to notice
--- setBackgroundColor("clickGeneratedLabel", 255, 204, 0, 200)
--- ```
function getMousePosition()
end

---  Returns two numbers, the width and height in pixels. This is useful for calculating the window dimensions and placement of custom GUI toolkit items like labels, buttons, mini consoles etc.
--- See also:
--- see: getUserWindowSize()
--- see: setMainWindowSize()
--- see: getMainConsoleWidth()
--- ##  Parameters
--- None
--- 
--- ## Example
--- ```lua
--- --this will get the size of your main mudlet window and save them
--- --into the variables mainHeight and mainWidth
--- mainWidth, mainHeight = getMainWindowSize()
--- ```
function getMainWindowSize()
end

---  Gets the maximum number of rows that a given window can display at once, taking into consideration factors such as window height, font type, spacing, etc.
--- 
--- ## Parameters:
--- * `windowName`:
---  (optional) name of the window whose maximum number of rows we want to calculate. By default it operates on the main window.
--- 
--- Note: 
--- Available since Mudlet 3.7.0
--- 
--- ## Example
--- ```lua
--- print("Maximum of rows on the main window "..getRowCount())
--- ```
function getRowCount(windowName)
end

---  Returns the text currently selected with [[#selectString|selectString()]], [[#selectSection|selectSection()]], or [[#selectCurrentLine|selectCurrentLine()]]. Note that this isn't the text currently selected with the mouse.
---  Also returns the start offset and length of the selection as second and third value.
--- 
--- ## Parameters:
--- * `windowName`:
---  (optional) name of the window to get the selection from. By default it operates on the main window.
--- 
--- Note: 
--- Available since Mudlet 3.16.0
--- 
--- ## Example
--- ```lua
--- selectCurrentLine()
--- print("Current line contains: "..getSelection())
--- ```
--- 
--- ## retrieving the selection
--- ```lua
--- text,offset,len = getSelection()
--- -- manipulate the selection, e.g. to discover the color of characters other than the first
--- -- then restore it
--- selectSection(offset, len)
--- ```
function getSelection(windowName)
end

---  Gets the current text format of the currently selected text. May be used with other console windows. The returned values come in a table containing text attribute names and their values. The values given will be booleans for: bold, italics, underline, overline, strikeout, and reverse - followed by color triplet tables for the foreground and background colors.
---  See Also: [[Manual:Lua_Functions#setTextFormat|setTextFormat()]]
--- 
--- ## Parameters
--- * `windowName`
---  (optional) Specify name of selected window. If no name or "main" is given, the format will be gathered from the main console.
--- 
--- Note:  Available since Mudlet 3.20.
--- 
--- ## Example:
--- ```lua
--- -- A suitable test for getTextFormat()
--- -- (copy it into an alias or a script)
--- 
--- clearWindow()
--- 
--- echo("\n")
--- 
--- local SGR = string.char(27)..'['
--- feedTriggers("Format attributes: '"..SGR.."1mBold"..SGR.."0m' '"..SGR.."3mItalic"..SGR.."0m' '"..SGR.."4mUnderline"..SGR.."0m' '"..SGR.."5mBlink"..SGR.."0m' '"..SGR.."6mF.Blink"..SGR.."0m' '"..SGR.."7mReverse"..SGR.."0m' '"..SGR.."9mStruckout"..SGR.."0m' '"..SGR.."53mOverline"..SGR.."0m'.\n")
--- 
--- moveCursor(1,1)
--- selectSection(1,1)
--- 
--- local results = getTextFormat()
--- echo("For first character in test line:\nBold detected: " .. tostring(results["bold"]))
--- echo("\nItalic detected: " .. tostring(results["italic"]))
--- echo("\nUnderline detected: " .. tostring(results["underline"]))
--- echo("\nReverse detected: " .. tostring(results["reverse"]))
--- echo("\nStrikeout detected: " .. tostring(results["strikeout"]))
--- echo("\nOverline detected: " .. tostring(results["overline"]))
--- echo("\nForeground color: (" .. results["foreground"][1] .. ", " .. results["foreground"][2] .. ", " .. results["foreground"][3] .. ")")
--- echo("\nBackground color: (" .. results["background"][1] .. ", " .. results["background"][2] .. ", " .. results["background"][3] .. ")")
--- 
--- selectSection(21,1)
--- echo("\n\nFor individual parts of test text:")
--- echo("\nBold detected (character 21): " .. tostring(results["bold"]))
--- 
--- selectSection(28,1)
--- echo("\nItalic detected (character 28): " .. tostring(results["italic"]))
--- 
--- selectSection(37,1)
--- echo("\nUnderline detected (character 37): " .. tostring(results["underline"]))
--- 
--- selectSection(67,1)
--- echo("\nReverse detected (character 67): " .. tostring(results["reverse"]))
--- 
--- selectSection(77,1)
--- echo("\nStrikeout detected (character 77): " .. tostring(results["strikeout"]))
--- 
--- selectSection(89,1)
--- echo("\nOverline detected (character 89): " .. tostring(results["overline"]))
--- echo("\n")
--- ```
function getTextFormat(windowName)
end

--- Note:  available in Mudlet 4.6.1+
---  Returns two numbers, the width and height in pixels. This is useful for calculating the given userwindow dimensions and placement of custom GUI toolkit items like labels, buttons, mini consoles etc.
--- See also:
--- see: getMainWindowSize()
--- ##  Parameters
--- * `windowName`
--- the name of the userwindow we will get the dimensions from
--- 
--- ## Example
--- ```lua
--- --this will get the size of your userwindow named "ChatWindow" and save them
--- --into the variables mainHeight and mainWidth
--- mainWidth, mainHeight = getUserWindowSize("ChatWindow")
--- ```
function getUserWindowSize(windowName)
end

---  (`depreciated`) This function is depreciated and should not be used; it's only documented here for historical reference - use the [[Manual:Technical_Manual#sysWindowResizeEvent|sysWindowResizeEvent]] event instead.
--- 
--- The standard implementation of this function does nothing. However, this function gets called whenever the main window is being manually resized. You can overwrite this function in your own scripts to handle window resize events yourself and e. g. adjust the screen position and size of your mini console windows, labels or other relevant GUI elements in your scripts that depend on the size of the main Window. To override this function you can simply put a function with the same name in one of your scripts thus overwriting the original empty implementation of this.
--- 
--- ##  Parameters
--- None
--- 
--- ##  Example
--- ```lua
--- function handleWindowResizeEvent()
---    -- determine the size of your screen
---    WindowWidth=0;
---    WindowHeight=0;
---    WindowWidth, WindowHeight = getMainWindowSize();
--- 
---    -- move mini console "sys" to the far right side of the screen whenever the screen gets resized
---    moveWindow("sys",WindowWidth-300,0)
--- end
--- ```
function handleWindowResizeEvent()
end

---  Returns `true` or `false` depending if Mudlet's main window is currently in focus (ie, the user isn't focused on another window, like a browser). If multiple profiles are loaded, this can also be used to check if a given profile is in focus.
--- 
--- ##  Parameters
--- None
--- 
--- ## Example
--- ```lua
--- if attacked and not hasFocus() then
---   runaway()
--- else
---   fight()
--- end
--- ```
function hasFocus()
end

---  Echoes text that can be easily formatted with colour tags in the hexadecimal format.
---  See Also: [[Manual:Lua_Functions#decho|decho()]], [[Manual:Lua_Functions#cecho|cecho()]]
--- 
--- ## Parameters
--- * `windowName:`
---  (optional) name of the window to echo to. Can either be omitted or "main" for the main window, else specify the miniconsoles name.
--- * `text:`
---  The text to display, with color changes made within the string using the format |cFRFGFB,BRBGBB or #FRFGFB,BRBGBB where FR is the foreground red value, FG is the foreground green value, FB is the foreground blue value, BR is the background red value, etc., BRBGBB is optional. |r or #r can be used within the string to reset the colors to default. Hexadecimal color codes can be found here: https://www.color-hex.com/
--- 
--- Note: 
--- Transparency for background in hex-format available in Mudlet 4.10+
--- 
--- ## Example
--- ```lua
--- hecho("\n#ffffff White text!")
--- -- your text in white
--- hecho("\n#ca0004 Red text! And now reset #rit to the default color")
--- -- your text in red, then reset to default using #r
--- hecho("\n#ffffff,ca0004 White text with a red background!")
--- -- your text in white, against a red background
--- hecho("\n|c0000ff Blue text, this time using |c instead of #")
--- -- your text in blue, activated with |c vs #.
--- ```
function hecho(windowName, text)
end

---  Echos a piece of text as a clickable link, at the end of the current selected line - similar to [[Manual:Lua_Functions#hecho|hecho()]]. This version allows you to use colours within your link text.
--- 
--- See also:
--- see: cechoLink()
--- see: dechoLink()
--- ## Parameters
--- * `windowName:`
---  (optional) - allows selection between sending the link to a miniconsole or the `main` window.
--- * `text:`
---  text to display in the echo. Same as a normal [[Manual:Lua_Functions#hecho|hecho()]].
--- * `command:`
---  lua code to do when the link is clicked.
--- * `hint:`
---  text for the tooltip to be displayed when the mouse is over the link.
--- * `true:`
---  requires argument for the colouring to work.
--- 
--- ## Example
--- ```lua
--- -- echo a link named 'press me!' that'll send the 'hi' command to the game
--- hechoLink("|ca00040black!", [[send("hi")]], "This is a tooltip", true)
--- -- # format also works
--- hechoLink("#ca00040black!", [[send("hi")]], "This is a tooltip", true)
--- ```
function hechoLink(windowName, text, command, hint, true)
end

---  Creates text with a left-clickable link, and a right-click menu for more options at the end of the current line, like [[#hecho|hecho()]]. The added text, upon being left-clicked, will do the first command in the list. Upon being right-clicked, it'll display a menu with all possible commands. The menu will be populated with hints, one for each line.
--- 
--- ##  Parameters
--- * `windowName:`
---  (optional) name of the window to echo to. Use either `main` or omit for the main window, or the miniconsoles name otherwise.
--- * `text:`
---  the text to display
--- * `{commands}:`
---  a table of lua code strings to do. ie, ```lua" inline="
--- [[send("hello")]], [[echo("hi!"]]}```
--- * `{hints}:`
---  a table of strings which will be shown on the popup and right-click menu. ie, ```lua" inline="
--- "send the hi command", "echo hi to yourself"}```
--- * `useCurrentFormatElseDefault:`
---  (optional) a boolean value for using either the current formatting options (colour, underline, italic) or the link default (blue underline).
--- 
--- ## Example
--- ```lua
--- -- Create some text as a clickable with a popup menu:
--- hechoPopup("#ff0000activities#r to do", {[[send "sleep"]], [[send "sit"]], [[send "stand"]]}, {"sleep", "sit", "stand"}, true)
--- ```
--- 
--- Note:  Available in Mudlet 4.1+
function hechoPopup(windowName, text, {commands}, {hints}, useCurrentFormatElseDefault)
end

---  Echos a piece of text as a clickable link, at the end of the current cursor position - similar to [[#hinsertText|hinsertText()]]. This version allows you to use colours within your link text.
--- 
--- See also:
--- see: insertLink()
--- see: dinsertLink()
--- ## Parameters
--- * `windowName:`
---  optional parameter, allows selection between sending the link to a miniconsole or the main window.
--- * `text:`
---  text to display in the echo. Same as a normal [[Manual:Lua_Functions#hecho|hecho()]].
--- * `command:`
---  lua code to do when the link is clicked.
--- * `hint:`
---  text for the tooltip to be displayed when the mouse is over the link.
--- * `true:`
---  requires argument for the colouring to work.
--- 
--- ## Example
--- ```lua
--- -- echo a link named 'press me!' that'll send the 'hi' command to the game
--- hinsertLink("#ff0000press #a52a2a,ffffffme!", [[send("hi")]], "This is a tooltip", true)
--- ```
--- 
--- Note:  Available in Mudlet 4.1+
function hinsertLink(windowName, text, command, hint, true)
end

---  Creates text with a left-clickable link, and a right-click menu for more options at the end of the current cursor position, like [[#hinsertText|hinsertText()]]. The added text, upon being left-clicked, will do the first command in the list. Upon being right-clicked, it'll display a menu with all possible commands. The menu will be populated with hints, one for each line.
--- 
--- ##  Parameters
--- * `windowName:`
---  (optional) name of the window to echo to. Use either `main` or omit for the main window, or the miniconsoles name otherwise.
--- * `text:`
---  the text to display
--- * `{commands}:`
---  a table of lua code strings to do. ie, ```lua" inline="
--- [[send("hello")]], [[echo("hi!"]]}```
--- * `{hints}:`
---  a table of strings which will be shown on the popup and right-click menu. ie, ```lua" inline="
--- "send the hi command", "echo hi to yourself"}```
--- * `useCurrentFormatElseDefault:`
---  (optional) a boolean value for using either the current formatting options (colour, underline, italic) or the link default (blue underline).
--- 
--- ## Example
--- ```lua
--- -- Create some text as a clickable with a popup menu:
--- hinsertPopup("#ff0000activities#r to do", {[[send "sleep"]], [[send "sit"]], [[send "stand"]]}, {"sleep", "sit", "stand"}, true)
--- ```
--- 
--- Note:  Available in Mudlet 4.1+
function hinsertPopup(windowName, text, {commands}, {hints}, useCurrentFormatElseDefault)
end

---  Replaces the output line from the MUD with a colour-tagged string.
--- See Also: [[Manual:Lua_Functions#hecho|hecho()]], [[Manual:Lua_Functions#hinsertText|hinsertText()]]
--- ## Parameters
--- * `window:`
--- *: The window to replace the selection in. Optional, defaults to the main window if not provided.
--- * `text:`
--- *: The text to display, as with [[Manual:Lua_Functions#hecho|hecho()]]
--- 
--- 
--- ## Example
---  ```lua
---     selectCaptureGroup(1)
---     hreplace("#EE00EE[ALERT!]: #r"..matches[2])
---  ```
--- 
--- Note:  Available in Mudlet 4.5+
function hreplace(window, text)
end

---  Hides the toolbar with the given name name and makes it disappear. If all toolbars of a tool bar area (top, left, right) are hidden, the entire tool bar area disappears automatically.
--- 
--- ## Parameters
--- * `name:`
---  name of the button group to hide
--- 
--- ## Example
--- ```lua
--- hideToolBar("my offensive buttons")
--- ```
function hideToolBar(name)
end

---  This function hides a **mini console**, a **user window** or a **label** with the given name. To show it again, use [[Manual:Lua_Functions#showWindow|showWindow()]].
--- 
--- See also:
--- see: createMiniConsole()
--- see: createLabel()
--- see: deleteLabel()
--- ## Parameters
--- * `name`
---  specifies the label or console you want to hide.
--- 
--- ## Example
--- ```lua
--- function miniconsoleTest()
---   local windowWidth, windowHeight = getMainWindowSize()
--- 
---   -- create the miniconsole
---   createMiniConsole("sys", windowWidth-650,0,650,300)
---   setBackgroundColor("sys",255,69,0,255)
---   setMiniConsoleFontSize("sys", 8)
---   -- wrap lines in window "sys" at 40 characters per line - somewhere halfway, as an example
---   setWindowWrap("sys", 40)
--- 
---   print("created red window top-right")
--- 
---   tempTimer(1, function()
---     hideWindow("sys")
---     print("hid red window top-right")
---   end)
--- 
---   tempTimer(3, function()
---     showWindow("sys")
---     print("showed red window top-right")
---   end)
--- end
--- 
--- miniconsoleTest()
--- ```
function hideWindow(name)
end

---  Inserts a piece of text as a clickable link at the current cursor position - similar to [[Manual:Lua_Functions#insertText|insertText()]].
--- 
--- ## Parameters
--- * `windowName:`
---  (optional) the window to insert the link in - use either "main" or omit for the main window.
--- * `text:`
---  text to display in the window. Same as a normal [[Manual:Lua_Functions#echo|echo()]].
--- * `command:`
---  lua code to do when the link is clicked.
--- * `hint:`
---  text for the tooltip to be displayed when the mouse is over the link.
--- * `useCurrentLinkFormat:`
---  (optional) true or false. If true, then the link will use the current selection style (colors, underline, etc). If missing or false, it will use the default link style - blue on black underlined text.
--- 
--- ## Example
--- ```lua
--- -- link with the default blue on white colors
--- insertLink("hey, click me!", [[echo("you clicked me!\n")]], "Click me popup")
--- 
--- -- use current cursor colors by adding true at the end
--- fg("red")
--- insertLink("hey, click me!", [[echo("you clicked me!\n")]], "Click me popup", true)
--- resetFormat()
--- ```
function insertLink(windowName, text, command, hint, useCurrentLinkFormat)
end

---  Creates text with a left-clickable link, and a right-click menu for more options exactly where the cursor position is, similar to [[Manual:Lua_Functions#insertText|insertText()]]. The inserted text, upon being left-clicked, will do the first command in the list. Upon being right-clicked, it'll display a menu with all possible commands. The menu will be populated with hints, one for each line.
--- 
--- ##  Parameters
--- * `windowName:`
---  (optional) name of the window to echo to - use either `main` or omit for the main window, or the miniconsoles name otherwise.
--- * `name:`
---  the name of the console to operate on. If not using this in a miniConsole, use "main" as the name.
--- * `{lua code}:`
---  a table of lua code strings to do. ie, ```lua" inline="
--- [[send("hello")]], [[echo("hi!"]]}```.
--- * `{hints}:`
---  a table of strings which will be shown on the popup and right-click menu. ie, ```lua" inline="
--- "send the hi command", "echo hi to yourself"}```.
--- * `useCurrentLinkFormat:`
---  (optional) boolean value for using either the current formatting options (colour, underline, italic) or the link default (blue underline).
--- 
--- ## Example
--- ```lua
--- -- Create some text as a clickable with a popup menu:
--- insertPopup("activities to do", {[[send "sleep"]], [[send "sit"]], [[send "stand"]]}, {"sleep", "sit", "stand"})
--- ```
function insertPopup(windowName, text, {commands}, {hints}, useCurrentLinkFormat)
end

---  Inserts text at cursor postion in window - unlike [[Manual:Lua_Functions#echo|echo()]], which inserts the text at the end of the last line in the buffer (typically the one being processed by the triggers). You can use [[Manual:Lua_Functions#moveCursor|moveCursor()]] to move the cursor into position first.
--- 
---  insertHTML() also does the same thing as insertText, if you ever come across it.
--- 
--- See also:
--- see: cinsertText()
--- ##  Parameters
--- * `windowName:`
---  (optional) The window to insert the text to.
--- * `text:`
---  The text you will insert into the current cursor position.
--- 
--- ## Example
--- ```lua
--- -- move the cursor to the end of the previous line and insert some text
--- 
--- -- move to the previous line
--- moveCursor(0, getLineNumber()-1)
--- -- move the end the of the previous line
--- moveCursor(#getCurrentLine(), getLineNumber())
--- 
--- fg("dark_slate_gray")
--- insertText(' <- that looks nice.')
--- 
--- deselect()
--- resetFormat()
--- moveCursorEnd()
--- ```
function insertText(windowName, text)
end

--- Prints text to the to the stdout. This is only available if you [http://www.wikihow.com/Run-a-Program-on-Command-Prompt launched Mudlet from cmd.exe] on Windows, [http://www.wikihow.com/Open-Applications-Using-Terminal-on-Mac from the terminal] on Mac, or from the terminal on a Linux OS (launch the terminal program, type `mudlet` and press enter).
--- 
--- Similar to [[Manual:Lua_Functions#echo|echo()]], but does not require a "\n" at the end for a newline and can print several items given to it. It cannot print whole tables. This function works similarly to the print() you will see in guides for Lua.
--- 
--- This function is useful in working out potential crashing problems with Mudlet due to your scripts - as you will still see whatever it printed when Mudlet crashes.
--- 
--- ## Parameters
--- * `text:`
---  The information you want to display.
--- ## Example:
--- ```lua
--- ioprint("hi!")
--- ioprint(1,2,3)
--- ioprint(myvariable, someothervariable, yetanothervariable)
--- ```
function ioprint(text, some_more_text, ...)
end

---  This function tests if the first character of **the current selection** in the main console has the background color specified by bgColorCode.
--- 
--- ## Parameters
--- * `bgColorCode:`
---  A color code to test for, possible codes are:
--- 
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
--- ## Example
--- ```lua
--- selectString( matches[1], 1 )
--- if isAnsiBgColor( 5 ) then
---     bg( "red" );
---     resetFormat();
---     echo( "yes, the background of the text is light green" )
--- else
---     echo( "no sorry, some other background color" )
--- end
--- ```
--- 
--- Note: 
--- The variable named matches[1] holds the matched trigger pattern - even in substring, exact match, begin of line substring trigger patterns or even color triggers that do not know about the concept of capture groups. Consequently, you can always test if the text that has fired the trigger has a certain color and react accordingly. This function is faster than using getBgColor() and then handling the color comparison in Lua.
--- 
--- `Also note that the color code numbers are Mudlet specific, though they do represent the colors in the 16 ANSI color-set for the main console they are not in the same order and they additionally have the default background color in the zeroth position.`
function isAnsiBgColor(bgColorCode)
end

---  This function tests if the first character of **the current selection** in the main console has the foreground color specified by fgColorCode.
--- 
--- ## Parameters
--- * `fgColorCode:`
---  A color code to test for, possible codes are:
--- 
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
--- ## Example
--- ```lua
--- selectString( matches[1], 1 )
--- if isAnsiFgColor( 5 ) then
---     bg( "red" );
---     resetFormat();
---     echo( "yes, the text is light green" )
--- else
---     echo( "no sorry, some other foreground color" )
--- end
--- ```
--- 
--- Note: 
--- The variable named matches[1] holds the matched trigger pattern - even in substring, exact match, begin of line substring trigger patterns or even color triggers that do not know about the concept of capture groups. Consequently, you can always test if the text that has fired the trigger has a certain color and react accordingly. This function is faster than using getFgColor() and then handling the color comparison in Lua.
--- 
--- `Also note that the color code numbers are Mudlet specific, though they do represent the colors in the 16 ANSI color-set for the main console they are not in the same order and they additionally have the default foreground color in the zeroth position.`
function isAnsiFgColor(fgColorCode)
end

--- Moves the referenced label/console below all other labels/consoles. For the opposite effect, see: [[#raiseWindow | raiseWindow()]].
--- 
--- ## Parameters
--- * `labelName:`
---  the name of the label/console you wish to move below the rest.
--- 
--- Note: 
--- Available since Mudlet 3.1.0
--- 
--- ##  Example:
--- ```lua
--- createLabel("blueLabel", 300, 300, 100, 100, 1)   --creates a blue label
--- setBackgroundColor("blueLabel", 50, 50, 250, 255)
--- 
--- createLabel("redLabel", 350, 350, 100, 100, 1)    --creates a red label which is placed on TOP of the blue label, as the last made label will sit at the top of the rest
--- setBackgroundColor("redLabel", 250, 50, 50, 255)
--- 
--- lowerWindow("redLabel")                          --lowers redLabel, causing blueLabel to be back on top
--- ```
function lowerWindow(labelName)
end

---  Moves the user cursor of the window windowName, or the main window, to the absolute point (x,y). This function returns false if such a move is impossible e.g. the coordinates don’t exist. To determine the correct coordinates use [[Manual:Lua_Functions#getLineNumber|getLineNumber()]], [[Manual:Lua_Functions#getColumnNumber|getColumnNumber()]] and [[Manual:Lua_Functions#getLastLineNumber|getLastLineNumber()]]. The trigger engine will always place the user cursor at the beginning of the current line before the script is run. If you omit the windowName argument, the main screen will be used.
--- 
---  Returns `true` or `false` depending on if the cursor was moved to a valid position. Check this before doing further cursor operations - because things like deleteLine() might invalidate this.
--- 
--- ## Parameters
--- * `windowName:`
---  (optional) The window you are going to move the cursor in.
--- * `x:`
---  The horizontal axis in the window - that is, the letter position within the line.
--- * `y:`
---  The vertical axis in the window - that is, the line number.
--- 
--- ## Example
--- ```lua
--- -- move cursor to the start of the previous line and insert -<(
--- -- the first 0 means we want the cursor right at the start of the line,
--- -- and getLineNumber()-1 means we want the cursor on the current line# - 1 which
--- -- equals to the previous line
--- moveCursor(0, getLineNumber()-1)
--- insertText("-<(")
--- 
--- -- now we move the cursor at the end of the previous line. Because the
--- -- cursor is on the previous line already, we can use #getCurrentLine()
--- -- to see how long it is. We also just do getLineNumber() because getLineNumber()
--- -- returns the current line # the cursor is on
--- moveCursor(#getCurrentLine(), getLineNumber())
--- insertText(")>-")
--- 
--- -- finally, reset it to the end where it was after our shenaningans - other scripts
--- -- could expect the cursor to be at the end
--- moveCursorEnd()
--- ```
--- 
--- ```lua
--- -- a more complicated example showing how to work with Mudlet functions
--- 
--- -- set up the small system message window in the top right corner
--- -- determine the size of your screen
--- local WindowWidth, WindowHeight = getMainWindowSize()
--- 
--- -- define a mini console named "sys" and set its background color
--- createMiniConsole("sys",WindowWidth-650,0,650,300)
--- setBackgroundColor("sys",85,55,0,255)
--- 
--- -- you *must* set the font size, otherwise mini windows will not work properly
--- setMiniConsoleFontSize("sys", 12)
--- -- wrap lines in window "sys" at 65 characters per line
--- setWindowWrap("sys", 60)
--- -- set default font colors and font style for window "sys"
--- setTextFormat("sys",0,35,255,50,50,50,0,0,0)
--- -- clear the window
--- clearUserWindow("sys")
--- 
--- moveCursorEnd("sys")
--- setFgColor("sys", 10,10,0)
--- setBgColor("sys", 0,0,255)
--- echo("sys", "test1---line1\n<this line is to be deleted>\n<this line is to be deleted also>\n")
--- echo("sys", "test1---line2\n")
--- echo("sys", "test1---line3\n")
--- setTextFormat("sys",158,0,255,255,0,255,0,0,0);
--- --setFgColor("sys",255,0,0);
--- echo("sys", "test1---line4\n")
--- echo("sys", "test1---line5\n")
--- moveCursor("sys", 1,1)
--- 
--- -- deleting lines 2+3
--- deleteLine("sys")
--- deleteLine("sys")
--- 
--- -- inserting a line at pos 5,2
--- moveCursor("sys", 5,2)
--- setFgColor("sys", 100,100,0)
--- setBgColor("sys", 255,100,0)
--- insertText("sys","############## line inserted at pos 5/2 ##############")
--- 
--- -- inserting a line at pos 0,0
--- moveCursor("sys", 0,0)
--- selectCurrentLine("sys")
--- setFgColor("sys", 255,155,255)
--- setBold( "sys", true );
--- setUnderline( "sys", true )
--- setItalics( "sys", true )
--- insertText("sys", "------- line inserted at: 0/0 -----\n")
--- 
--- setBold( "sys", true )
--- setUnderline( "sys", false )
--- setItalics( "sys", false )
--- setFgColor("sys", 255,100,0)
--- setBgColor("sys", 155,155,0)
--- echo("sys", "*** This is the end. ***\n")
--- ```
function moveCursor(windowName, x, y)
end

---  Moves the cursor in the given window down a specified number of lines.
--- See also:
--- see: moveCursor()
--- see: moveCursorUp()
--- see: moveCursorEnd()
--- ## Parameters
--- * `windowName:`
---  (optional) name of the miniconsole/userwindow, or "main" for the main window.
--- 
--- * `lines:`
---  (optional) number of lines to move cursor down by, or 1 by default.
--- 
--- * `keepHorizontal:`
---  (optional) true/false to specify if horizontal position should be retained, or reset to the start of the line otherwise.
--- 
--- {{Note}}
--- Available since Mudlet 3.17+
--- 
--- ## Example
--- ` Need example`
function moveCursorDown(windowName, lines, keepHorizontal)
end

---  Moves the cursor in the given window up a specified number of lines.
--- See also:
--- see: moveCursor()
--- see: moveCursorDown()
--- see: moveCursorEnd()
--- ## Parameters
--- * `windowName:`
---  (optional) name of the miniconsole/userwindow, or "main" for the main window.
--- 
--- * `lines:`
---  (optional) number of lines to move cursor up by, or 1 by default.
--- 
--- * `keepHorizontal:`
---  (optional) true/false to specify if horizontal position should be retained, or reset to the start of the line otherwise.
--- 
--- {{Note}}
--- Available since Mudlet 3.17+
--- 
--- ## Example
--- ` Need example`
function moveCursorUp(windowName, lines, keepHorizontal)
end

---  Moves the cursor to the end of the buffer. "main" is the name of the main window, otherwise use the name of your user window.
---  See Also: [[Manual:Lua_Functions#moveCursor|moveCursor()]]
--- 
---  Returns true or false
--- 
--- ## Parameters
--- * `windowName:`
---  (optional) name of the miniconsole/userwindow, or "main" for the main window.
--- 
--- ## Example
--- ` Need example`
function moveCursorEnd(windowName)
end

--- Moves a gauge created with createGauge to the new x,y coordinates. Remember the coordinates are relative to the top-left corner of the output window.
--- 
--- ## Parameters
--- * `gaugeName:`
---  The name of your gauge
--- * `newX:`
---  The horizontal pixel location
--- * `newY:`
---  The vertical pixel location
--- 
--- ## Example
--- ```lua
--- -- This would move the health bar gauge to the location 1200, 400
--- moveGauge("healthBar", 1200, 400)
--- ```
function moveGauge(gaugeName, newX, newY)
end

--- This function moves window name to the given x/y coordinate. The main screen cannot be moved. Instead you’ll have to set appropriate border values → preferences to move the main screen e.g. to make room for chat or information mini consoles, or other GUI elements. In the future moveWindow() will set the border values automatically if the name parameter is omitted.
--- 
--- See Also: [[#createMiniConsole | createMiniConsole()]], [[#createLabel | createLabel()]], [[#handleWindowResizeEvent | handleWindowResizeEvent()]], [[#resizeWindow | resizeWindow()]], [[#setBorderSizes | setBorderSizes()]], [[#openUserWindow | openUserWindow()]]
--- 
--- ## Parameters
--- * `name:`
---  The name of your window
--- * `newX:`
---  The horizontal pixel location
--- * `newY:`
---  The vertical pixel location
--- 
--- Note: 
--- Since Mudlet 3.7 this method can also be used on UserWindow consoles.
function moveWindow(name, x, y)
end

---  Opens a user dockable console window for user output e.g. statistics, chat etc. If a window of such a name already exists, nothing happens. You can move these windows (even to a different screen on a system with a multi-screen display), dock them on any of the four sides of the main application window, make them into notebook tabs or float them.
--- 
--- ## Parameters
--- * `windowName:`
---  name of your window, it must be unique across ALL profiles if more than one is open (for multi-playing).
--- * `restoreLayout:`
---  (optional) - only relevant, if `false` is provided. Then the window won't be restored to its last known position.
--- * `autoDock:`
---  (optional) - only relevant, if `false` is provided. Then the window won't dock automatically at the corners.
--- * `dockingArea:`
---  (optional) - the area your UserWindow will be docked at. possible docking areas your UserWindow will be created in (f" floating "t" top "b" bottom "r" right and "l" left). Docking area is "right" if not given any value.
--- 
--- Note: 
--- Since Mudlet version 3.2, Mudlet will automatically remember the windows last position and the `restoreLayout` argument is available as well.
--- 
--- Note: 
--- The parameters autoDock and dockingArea are available since Mudlet 4.7+ 
--- 
--- ## Examples
--- ```lua
--- openUserWindow("My floating window")
--- cecho("My floating window", "<red>hello <blue>bob!")
--- 
--- -- if you don't want Mudlet to remember its last position:
--- openUserWindow("My floating window", false)
--- ```
--- 
--- See also:
--- see: resetUserWindowTitle()
--- see: setUserWindowTitle()
function openUserWindow(windowName, restoreLayout, autoDock, dockingArea)
end

---  Pastes the previously copied text including all format codes like color, font etc. at the current user cursor position. The [[#copy | copy()]] and [[#paste | paste()]] functions can be used to copy formated text from the main window to a user window without losing colors e. g. for chat windows, map windows etc.
--- 
--- ## Parameters
--- * `windowName:`
---  The name of your window
function paste(windowName)
end

--- Prefixes text at the beginning of the current line when used in a trigger.
--- 
--- ## Parameters
--- * `text:`
---  the information you want to prefix
--- * "writingFunction:"
---  optional parameter, allows the selection of different functions to be used to write the text, valid options are: echo, cecho, decho, and hecho.
--- * "foregroundColor:"
---  optional parameter, allows a foreground color to be specified if using the echo function using a color name, as with the fg() function
--- * "backgroundColor:"
---  optional parameter, allows a background color to be specified if using the echo function using a color name, as with the bg() function
--- * "windowName:"
---  optional parameter, allows the selection a miniconsole or the main window for the line that will be prefixed
--- ## Example:
--- ```lua
--- -- Prefix the hours, minutes and seconds onto our prompt even though Mudlet has a button for that
--- prefix(os.date("%H:%M:%S "))
--- -- Prefix the time in red into a miniconsole named "my_console"
--- prefix(os.date("<red>%H:%M:%S<reset>", cecho, nil, nil, "my_console"))
--- ```
--- 
--- See also:
--- see:  suffix()
function prefix(text, writingFunction, foregroundColor, backgroundColor, windowName)
end

--- Prints text to the main window. Similar to [[Manual:Lua_Functions#echo|echo()]], but does not require a "\n" at the end for a newline and can print several items given to it. It cannot print whole tables - use [[Manual:Lua_Functions#display|display()]] for those. This function works similarly to the print() you will see in guides for Lua.
--- 
--- ## Parameters
--- * `text:`
---  The information you want to display.
--- ## Example:
--- ```lua
--- print("hi!")
--- print(1,2,3)
--- print(myvariable, someothervariable, yetanothervariable)
--- ```
function print(text, some_more_text, ...)
end

--- Raises the referenced label/console above all over labels/consoles. For the opposite effect, see: [[#lowerWindow | lowerWindow()]].
--- 
--- ## Parameters
--- * `labelName:`
---  the name of the label/console you wish to bring to the top of the rest.
--- 
--- Note: 
--- Available since Mudlet 3.1.0
--- 
--- ##  Example:
--- ```lua
--- createLabel("blueLabel", 300, 300, 100, 100, 1)   --creates a blue label
--- setBackgroundColor("blueLabel", 50, 50, 250, 255)
--- 
--- createLabel("redLabel", 350, 350, 100, 100, 1)    --creates a red label which is placed on TOP of the bluewindow, as the last made label will sit at the top of the rest
--- setBackgroundColor("redLabel", 250, 50, 50, 255)
--- 
--- raiseWindow("blueLabel")                          --raises blueLabel back at the top, above redLabel
--- ```
function raiseWindow(labelName)
end

--- Replaces the currently selected text with the new text. To select text, use [[#selectString | selectString()]], [[#selectSection | selectSection()]] or a similar function.
--- 
--- Note: 
--- If you’d like to delete/gag the whole line, use [[#deleteLine | deleteLine()]] instead.
--- 
--- Note: 
--- when used outside of a trigger context (for example, in a timer instead of a trigger), replace() won't trigger the screen to refresh. Instead, use `replace("")` and `insertText("new text")` as [[#insertText | insertText()]] does.
--- 
--- See also:
--- see: creplace()
--- ## Parameters
--- * `windowName:`
---  (optional) name of window (a miniconsole)
--- * `with:`
---  the new text to display.
--- * `keepcolor:`
---  (optional) argument, setting this to `true` will keep the existing colors (since Mudlet 3.0+)
--- 
--- ##  Example:
--- ```lua
--- -- replace word "troll" with "cute trolly"
--- selectString("troll",1)
--- replace("cute trolly")
--- 
--- -- replace the whole line
--- selectCurrentLine()
--- replace("Out with the old, in with the new!")
--- ```
function replace(windowName, with, keepcolor)
end

---  Replaces all occurrences of `what` in the current line with `with`.
--- 
--- ## Parameters
--- * `what:`
---  the text to replace
--- Note: 
--- This accepts [https://www.lua.org/pil/20.2.html Lua patterns]
--- * `with:`
---  the new text to have in place
--- * `keepcolor:`
---  setting this to true will keep the existing colors.
--- Note:  keepcolor is available in Mudlet 4.10+
--- 
--- ## Examples:
--- ```lua
--- -- replace all occurrences of the word "south" in the line with "north"
--- replaceAll("south", "north")
--- ```
--- 
--- ```lua
--- -- replace all occurrences of the text that the variable "target" has
--- replaceAll(target, "The Bad Guy")
--- ```
function replaceAll(what, with, keepcolor)
end

---  Replaces the given wildcard (as a number) with the given text. Equivalent to doing:
--- 
--- ```lua
--- selectString(matches[2], 1)
--- replace("text")
--- ```
--- 
--- ## Parameters
--- * `which:`
---  Wildcard to replace.
--- * `replacement:`
---  Text to replace the wildcard with.
--- * `keepcolor:`
---  setting this to true will keep the existing colors
--- Note:  keepcolor available in Mudlet 4.10+
--- 
--- ## Example
--- ```lua
--- replaceWildcard(2, "hello") -- on a perl regex trigger of ^You wave (goodbye)\.$, it will make it seem like you waved hello
--- ```
function replaceWildcard(which, replacement, keepcolor)
end

---  Resets the action on the command line so the it behaves like the main command line again.
--- ## Parameters
--- 
--- * `commandLineName`
---  The name of the command line the action will be resetet.
--- See also:
--- see:  setCmdLineAction()
function resetCmdLineAction(commandLineName)
end

---  Resets the console background-image
--- ## Parameters
--- 
--- * `windowName`
---  (optional) name of the console the image will be reset
--- See also:
--- see:  setBackgroundImage()
function resetBackgroundImage(windowName)
end

---  Resets the colour/bold/italics formatting. Always use this function when done adjusting formatting, so make sure what you've set doesn't 'bleed' onto other triggers/aliases.
--- 
--- ##  Parameters
--- None
--- 
--- ## Example
--- ```lua
--- -- select and set the 'Tommy' to red in the line
--- if selectString("Tommy", 1) ~= -1 then fg("red") end
--- 
--- -- now reset the formatting, so our echo isn't red
--- resetFormat()
--- echo(" Hi Tommy!")
--- 
--- -- another example: just highlighting some words
--- for _, word in ipairs{"he", "she", "her", "their"} do
---   if selectString(word, 1) ~= -1 then
---     bg("blue")
---   end
--- end
--- resetFormat()
--- ```
function resetFormat()
end

---  Resets your mouse cursor to the default one.
--- 
--- See also:
--- see: setLabelCursor()
--- see: setLabelCustomCursor()
--- {{Note}} Available in Mudlet 4.8+
--- 
--- ## Parameters
--- * `labelName`: label for which to reset the cursor for.
--- 
--- ## Example
--- ```lua
--- resetLabelCursor("myLabel")
--- -- This will reset the mouse cursor over myLabel to the default one
--- ```
function resetLabelCursor(labelName)
end

---  Resets the tooltip on the given label.
--- Note:  available in Mudlet 4.6.1+
--- ## Parameters
--- 
--- * `labelName:`
---  The name of the label the tooltip will be reseted.
--- See also:
--- see:  setLabelToolTip()
function resetLabelToolTip(labelName)
end

---  resets the title of the popped out map window to default.
--- 
--- Note:  Available in Mudlet 4.8+
--- 
--- See also:
--- see: setMapWindowTitle()
function resetMapWindowTitle()
end

---  resets the title of the UserWindow windowName
--- 
--- ## Parameters
--- * `windowName:`
---  Name of the userwindow for which the title will be resetet
--- 
--- Note:  Available in Mudlet 4.8+
--- 
--- See also:
--- see: setUserWindowTitle()
--- see: openUserWindow()
function resetUserWindowTitle(windowName)
end

---  Resizes a mini console, label, or floating User Windows.
--- See also:
--- see:  createMiniConsole()
--- see:  createLabel()
--- see:  handleWindowResizeEvent()
--- see:  resizeWindow()
--- see:  setBorderSizes()
--- see:  openUserWindow()
--- ## Parameters
--- * `windowName:`
---  The name of your window
--- * `width:`
---  The new width you want
--- * `height:`
---  The new height you want
--- 
--- Note: 
--- Since Mudlet 3.7 this method can also be used on UserWindow consoles, only if they are floating.
function resizeWindow(windowName, width, height)
end

---  Selects the content of the capture group number in your Perl regular expression (from matches[]). It does not work with multimatches.
--- 
--- See also:
--- see:  selectCurrentLine()
--- ## Parameters
--- * `groupNumber:`
---  number of the capture group you want to select
--- 
--- ## Example
--- ```lua
--- --First, set a Perl Reqular expression e.g. "you have (\d+) Euro".
--- --If you want to color the amount of money you have green you do:
--- 
--- selectCaptureGroup(1)
--- setFgColor(0,255,0)
--- ```
function selectCaptureGroup(groupNumber)
end

---  Selects the content of the current line that the cursor at. By default, the cursor is at the start of the current line that the triggers are processing, but you can move it with the moveCursor() function.
--- 
--- Note: 
--- This selects the whole line, including the linebreak - so it has a subtle difference from the slightly slower `selectString(line, 1)` selection method.
--- See also:
--- see: selectString()
--- see:  selectCurrentLine()
--- see:  getSelection()
--- see: getCurrentLine()
--- ##  Parameters
--- * `windowName:`
---  (optional) name of the window in which to select text.
--- 
--- ## Example
--- ```lua
--- -- color the whole line green!
--- selectCurrentLine()
--- fg("green")
--- deselect()
--- resetFormat()
--- 
--- -- to select the previous line, you can do this:
--- moveCursor(0, getLineNumber()-1)
--- selectCurrentLine()
--- 
--- -- to select two lines back, this:
--- moveCursor(0, getLineNumber()-2)
--- selectCurrentLine()
--- 
--- ```
function selectCurrentLine(windowName)
end

---  Selects the specified parts of the line starting `from` the left and extending to the right for however `how long`. The line starts from 0.
---  Returns true if the selection was successful, and false if the line wasn't actually long enough or the selection couldn't be done in general.
--- 
--- See also:
--- see:  selectString()
--- see:  selectCurrentLine()
--- see:  getSelection()
--- ## Parameters
--- * "windowName:"
---  (optional) name of the window in which to select text. By default the main window, if no windowName is given.
---  Will not work if "main" is given as the windowName to try to select from the main window.
--- * `fromPosition:`
---  number to specify at which position in the line to begin selecting
--- * `length:`
---  number to specify the amount of characters you want to select
--- 
--- ## Example
--- ```lua
--- -- select and colour the first character in the line red
--- if selectSection(0,1) then fg("red") end
--- 
--- -- select and colour the second character green (start selecting from the first character, and select 1 character)
--- if selectSection(1,1) then fg("green") end
--- 
--- -- select and colour three character after the first two grey (start selecting from the 2nd character for 3 characters long)
--- if selectSection(2,3) then fg("grey") end
--- ```
function selectSection(_windowName, fromPosition, length_)
end

---  Selects a substring from the line where the user cursor is currently positioned - allowing you to edit selected text (apply colour, make it be a link, copy to other windows or other things).
--- 
--- Note: 
--- You can move the user cursor with [[#moveCursor | moveCursor()]]. When a new line arrives from the MUD, the user cursor is positioned at the beginning of the line. However, if one of your trigger scripts moves the cursor around you need to take care of the cursor position yourself and make sure that the cursor is in the correct line if you want to call one of the select functions. To deselect text, see [[#deselect | deselect()]].
--- 
--- ## Parameters
--- * `windowName:`
---  (optional) name of the window in which to select text. By default the main window, if no windowName or an empty string is given.
--- * `text:`
---  The text to select. It is matched as a substring match (so the text anywhere within the line will get selected).
--- * `number_of_match:`
---  The occurrence of text on the line that you'd like to select. For example, if the line was "Bob and Bob", 1 would select the first Bob, and 2 would select the second Bob.
--- 
---  Returns position in line or -1 on error (text not found in line)
--- 
--- Note: 
--- To prevent working on random text if your selection didn't actually select anything, check the -1 return code before doing changes:
--- 
--- ## Example
--- ```lua
--- if selectString( "big monster", 1 ) > -1 then fg("red") end
--- ```
function selectString(_windowName, text, number_of_match_)
end

---  Sets a stylesheet for the entire Mudlet application and every open profile. Because it affects other profiles that might not be related to yours, it's better to use [[#setProfileStyleSheet|setProfileStyleSheet()]] instead of this function.
--- 
---  Raises the sysAppStyleSheetChange event which comes with two arguments in addition to the event name. The first is the optional tag which was passed into the function, or "" if nothing was given. The second is the profile which made the stylesheet changes.
--- 
--- See also:
--- see: setProfileStyleSheet()
--- ## Parameters
--- 
--- * `stylesheet:`
---  The entire stylesheet you'd like to use.
--- 
--- * `tag:` (with Mudlet 3.19+)
---  An optional string tag or identifier that will be passed as a second argument in the `sysAppStyleSheetChange` event that is provided by that or later versions of Mudlet.
--- 
--- ## References
---  See [http://qt-project.org/doc/qt-5/stylesheet-reference.html Qt Style Sheets Reference] for the list of widgets you can style and CSS properties you can apply on them.
---  See also [https://github.com/vadi2/QDarkStyleSheet/blob/master/qdarkstyle/style.qss QDarkStyleSheet], a rather extensive stylesheet that shows you all the different configuration options you could apply, available as an [http://forums.mudlet.org/viewtopic.php?f=6&t=17624 mpackage here].
--- 
--- ## Example
--- ```lua
--- -- credit to Akaya @ http://forums.mudlet.org/viewtopic.php?f=5&t=4610&start=10#p21770
--- local background_color = "#26192f"
--- local border_color = "#b8731b"
--- 
--- setAppStyleSheet([[
---   QMainWindow {
---      background: ]]..background_color..[[;
---   }
---   QToolBar {
---      background: ]]..background_color..[[;
---   }
---   QToolButton {
---      background: ]]..background_color..[[;
---      border-style: solid;
---      border-width: 2px;
---      border-color: ]]..border_color..[[;
---      border-radius: 5px;
---      font-family: BigNoodleTitling;
---      color: white;
---      margin: 2px;
---      font-size: 12pt;
---   }
---   QToolButton:hover { background-color: grey;}
---   QToolButton:focus { background-color: grey;}
--- ]])
--- ```
--- 
--- Note: 
--- Available since Mudlet 3.0.
--- 
--- Enhanced in Mudlet version 3.19.0 to generate an event that profiles/packages can utilise to redraw any parts of the UI that they themselves had previously styled so their effects can be re-applied to the new application style.
--- 
--- It is anticipated that the Mudlet application itself will make further use of application styling effects and two strings are provisionally planned for the second parameter in the `sysAppStyleSheetChange` event: "`mudlet-theme-dark`" and "`mudlet-theme-light`"; it will also set the third parameter to "`system`".
function setAppStyleSheet(stylesheet_, _tag)
end

---  Sets the background for the given label, miniconsole, or userwindow. Colors are from 0 to 255 (0 being black), and transparency is from 0 to 255 (0 being completely transparent).
--- 
--- ## Parameters
--- 
--- * `windowName:`
---  (optional) name of the label/miniconsole/userwindow to change the background color on, or "main" for the main window.
--- * `r:`
---  Amount of red to use, from 0 (none) to 255 (full).
--- * `g:`
---  Amount of green to use, from 0 (none) to 255 (full).
--- * `b:`
---  Amount of red to use, from 0 (none) to 255 (full).
--- * `transparency:`
---  Amount of transparency to use, from 0 (fully transparent) to 255 (fully opaque).
--- 
--- Note: 
--- Transparency also available for main/miniconsoles in Mudlet 4.10+
--- 
--- ## Example
--- ```lua
--- -- make a red label that's somewhat transparent
--- setBackgroundColor("some label",255,0,0,200)
--- ```
function setBackgroundColor(windowName, r, g, b, transparency)
end

--- ## setBackgroundImage([windowname], imageLocation, [mode])
---  Loads an image file (png) as a background image for a label or console. This can be used to display clickable buttons in combination with [[Manual:Lua_Functions#setLabelClickCallback|setLabelClickCallback()]] and such.
--- 
--- Note: 
--- You can also load images on labels via [[Manual:Lua_Functions#setLabelStyleSheet|setLabelStyleSheet()]].
--- 
--- ## Parameters (label)
--- 
--- * `labelName:`
---  The name of the label to change it's background color.
--- * `imageLocation:`
---  The full path to the image location. It's best to use [[ ]] instead of "" for it - because for Windows paths, backslashes need to be escaped.
--- 
--- ## Parameters (consoles)
--- 
--- * `windowName:`
---  (optional) name of the miniconsole/userwindow to change the background image on, or "main" for the main window.
--- * `imageLocation:`
---  The full path to the image location. It's best to use [[ ]] instead of "" for it - because for Windows paths, backslashes need to be escaped.
--- * `mode:`
---  (optional) allows different modes for drawing the background image. Possible modes areː 
--- 
--- ** border - the background image is stretched (1)
--- ** center - the background image is in the center (2), 
--- ** tile - the background image is 'tiled' (3)
--- ** style - choose your own background image stylesheet, see example below (4)
--- 
--- See also:
--- see:  resetBackgroundImage()
--- ## Example (label)
--- ```lua
--- -- give the top border a nice look
--- setBackgroundImage("top bar", [[/home/vadi/Games/Mudlet/games/top_bar.png]])
--- ```
--- 
--- ## Example (main/miniconsole)
--- ```lua
--- -- give the main window a background image
--- setBackgroundImage("main", [[:/Mudlet_splashscreen_development.png]], "center")
--- 
--- -- or use your own for the main window:
--- setBackgroundImage("main", [[C:\Documents and Settings\bub\Desktop\mypicture.png]], "center")
--- 
--- -- give my_miniconsole a nice background image and put it in the center
--- setBackgroundImage("my_miniconsole", [[:/Mudlet_splashscreen_development.png]], "center")
--- 
--- -- give my_miniconsole a nice background image with own stylesheet option
--- setBackgroundImage("my_miniconsole", [[background-image: url(:/Mudlet_splashscreen_development.png); background-repeat: no-repeat; background-position: right;]], "style")
--- ```
--- Note:  setBackgroundImage for main/miniconsoles and userwindows available in Mudlet 4.10+
function setBackgroundImage(labelName, imageLocation)
end

--- Sets the current text background color in the main window unless windowName parameter given. If you have selected text prior to this call, the selection will be highlighted otherwise the current text background color will be changed. If you set a foreground or background color, the color will be used until you call resetFormat() on all further print commands.
--- 
--- If you'd like to change the background color of a window, see [[#setBackgroundColor|setBackgroundColor()]].
--- 
---  `See also:` [[#cecho|cecho()]], [[#setBackgroundColor|setBackgroundColor()]]
--- 
--- ## Parameters
--- * `windowName:`
---  (optional) either be none or "main" for the main console, or a miniconsole / userwindow name.
--- * `r:`
---  The red component of the gauge color. Passed as an integer number from 0 to 255
--- * `g:`
---  The green component of the gauge color. Passed as an integer number from 0 to 255
--- * `b:`
---  The blue component of the gauge color. Passed as an integer number from 0 to 255
--- * `transparency:`
---  Amount of transparency to use, from 0 (fully transparent) to 255 (fully opaque). Optional, if not used color is fully opaque
--- 
--- 
--- 
--- Note: 
--- Transparency parameter available in Mudlet 4.10+
--- 
--- ## Example
--- 
--- ```lua
--- --highlights the first occurrence of the string "Tom" in the current line with a red background color.
--- selectString( "Tom", 1 )
--- setBgColor( 255,0,0 )
--- ```
--- ```lua
--- --prints "Hello" on red background and "You" on blue.
--- setBgColor(255,0,0)
--- echo("Hello")
--- setBgColor(0,0,255)
--- echo(" You!")
--- resetFormat()
--- ```
function setBgColor(windowName, r, g, b, transparency)
end

---  Sets the current text font to bold (true) or non-bold (false) mode. If the windowName parameters omitted, the main screen will be used. If you've got text currently selected in the Mudlet buffer, then the selection will be bolded. Any text you add after with [[Manual:Lua_Functions#echo|echo()]] or [[Manual:Lua_Functions#insertText|insertText()]] will be bolded until you use [[Manual:Lua_Functions#resetFormat|resetFormat()]].
--- 
--- * `windowName:`
---  Optional parameter set the current text background color in windowname given.
--- 
--- * `boolean:`
---  A <code>true</code> or <code>false</code> that enables or disables bolding of text
--- 
--- ## Example
--- ```lua
--- -- enable bold formatting
--- setBold(true)
--- -- the following echo will be bolded
--- echo("hi")
--- -- turns off bolding, italics, underlines and colouring. It's good practice to clean up after you're done with the formatting, so other your formatting doesn't "bleed" into other echoes.
--- resetFormat()
--- ```
function setBold(windowName, boolean)
end

---  Sets the size of the bottom border of the main window in pixels. A border means that the MUD text won't go on it, so this gives you room to place your graphical elements there.
---  See Also: [[Manual:Lua_Functions#setBorderSizes|setBorderSizes()]], [[Manual:Lua_Functions#setBorderColor|setBorderColor()]], [[Manual:Lua_Functions#getBorderBottom|getBorderBottom()]]
--- 
--- ## Parameters
--- * `size:`
---  Height of the border in pixels - with 0 indicating no border.
--- 
--- ## Example
--- ```lua
--- setBorderBottom(150)
--- ```
function setBorderBottom(size)
end

---  Sets the color of the main windows border that you can create either with lua commands, or via the main window settings.
---  See Also: [[Manual:Lua_Functions#setBorderSizes|setBorderSizes()]]
--- 
--- ## Parameters
--- * `red:`
---  Amount of red color to use, from 0 to 255.
--- * `green:`
---  Amount of green color to use, from 0 to 255.
--- * `blue:`
---  Amount of blue color to use, from 0 to 255.
--- 
--- ## Example
--- ```lua
--- -- set the border to be completely blue
--- setBorderColor(0, 0, 255)
--- 
--- -- or red, using a name
--- setBorderColor( unpack(color_table.red) )
--- ```
function setBorderColor(red, green, blue)
end

---  Sets the size of the left border of the main window in pixels. A border means that the MUD text won't go on it, so this gives you room to place your graphical elements there.
---  See Also: [[Manual:Lua_Functions#setBorderSizes|setBorderSizes()]], [[Manual:Lua_Functions#setBorderColor|setBorderColor()]], [[Manual:Lua_Functions#getBorderLeft|getBorderLeft()]]
--- 
--- ## Parameters
--- * `size:`
---  Width of the border in pixels - with 0 indicating no border.
--- 
--- ## Example
--- ```lua
--- setBorderLeft(5)
--- ```
function setBorderLeft(size)
end

---  Sets the size of the right border of the main window in pixels. A border means that the MUD text won't go on it, so this gives you room to place your graphical elements there.
---  See Also: [[Manual:Lua_Functions#setBorderSizes|setBorderSizes()]], [[Manual:Lua_Functions#setBorderColor|setBorderColor()]], [[Manual:Lua_Functions#getBorderRight|getBorderRight()]]
--- 
--- ## Parameters
--- * `size:`
---  Width of the border in pixels - with 0 indicating no border.
--- 
--- ## Example
--- ```lua
--- setBorderRight(50)
--- ```
function setBorderRight(size)
end

---  Sets the size of all borders of the main window in pixels. A border means that the MUD text won't go on it, so this gives you room to place your graphical elements there.
---  The exact result of this function depends on how many numbers you give to it as arguments.
--- See also:
--- see: getBorderSizes()
--- see: setBorderTop()
--- see: setBorderRight()
--- see: setBorderBottom()
--- see: setBorderLeft()
--- see: setBorderColor()
---  Note:  Available since Mudlet 4.0
--- 
--- ## Arguments
--- * **setBorderSizes(top, right, bottom, left)**
---  `4 arguments:` All borders will be set to their new given size.
--- * **setBorderSizes(top, width, bottom)** 
---  `3 arguments:` Top and bottom borders will be set to their new given size, and right and left will gain the same width. 
--- * **setBorderSizes(height, width)**
---  `2 arguments:` Top and bottom borders will gain the same height, and right and left borders gain the same width. 
--- * **setBorderSizes(size)**
---  `1 argument:` All borders will be set to the same size.
--- * **setBorderSizes()**
---  `0 arguments:` All borders will be hidden or set to size of 0 = no border.
--- 
--- ## Example
--- ```lua
--- setBorderSizes(100, 50, 150, 0) 
--- -- big border at the top, bigger at the bottom, small at the right, none at the left
--- 
--- setBorderSizes(100, 50, 150) 
--- -- big border at the top, bigger at the bottom, small at the right and the left
--- 
--- setBorderSizes(100, 50) 
--- -- big border at the top and the bottom, small at the right and the left
--- 
--- setBorderSizes(100) 
--- -- big borders at all four sides
--- 
--- setBorderSizes() 
--- -- no borders at all four sides
--- ```
function setBorderSizes(top, right, bottom, left)
end

---  Sets the size of the top border of the main window in pixels. A border means that the MUD text won't go on it, so this gives you room to place your graphical elements there.
---  See Also: [[Manual:Lua_Functions#setBorderSizes|setBorderSizes()]], [[Manual:Lua_Functions#setBorderColor|setBorderColor()]], [[Manual:Lua_Functions#getBorderTop|getBorderTop()]]
--- 
--- ## Parameters
--- * `size:`
---  Height of the border in pixels - with 0 indicating no border.
--- 
--- ## Example
--- ```lua
--- setBorderTop(100)
--- ```
function setBorderTop(size)
end

--- Sets the current text foreground color in the main window unless windowName parameter given.
--- 
--- * `windowName:`
---  (optional) either be none or "main" for the main console, or a miniconsole / userwindow name.
--- * `red:`
---  The red component of the gauge color. Passed as an integer number from 0 to 255
--- * `green:`
---  The green component of the gauge color. Passed as an integer number from 0 to 255
--- * `blue:`
---  The blue component of the gauge color. Passed as an integer number from 0 to 255
--- 
--- See also:
--- see:  setBgColor()
--- see:  setHexFgColor()
--- see:  setHexBgColor()
--- see:  resetFormat()
--- ## Example
--- ```lua
--- --highlights the first occurrence of the string "Tom" in the current line with a red foreground color.
--- selectString( "Tom", 1 )
--- setFgColor( 255, 0, 0 )
--- ```
function setFgColor(windowName, red, green, blue)
end

---  Applies Qt style formatting to a button via a special markup language.
--- 
--- ##  Parameters
--- * `button:`
---  The name of the button to be formatted.
--- * `markup:`
---  The string instructions, as specified by the Qt Style Sheet reference.
---  Note: You can instead use QWidget { markup }. QWidget will reference 'button', allowing the use of pseudostates like QWidget:hover and QWidget:selected
--- 
--- ## References
---  http://qt-project.org/doc/qt-5/stylesheet-reference.html
--- 
--- ## Example
--- ```lua
--- setButtonStyleSheet("my test button", [[
---   QWidget {
---     background-color: #999999;
---     border: 3px #777777;
---   }
---   QWidget:hover {
---     background-color: #bbbbbb;
---   }
---   QWidget:checked {
---     background-color: #77bb77;
---     border: 3px #559955;
---   }
---   QWidget:hover:checked {
---     background-color: #99dd99;
---   } ]])```
function setButtonStyleSheet(button, markup)
end

---  Sets the value of the computer's clipboard to the string data provided.
--- See also:
--- see:  getClipboardText()
--- ##  Parameters
--- * `textContent:`
---  The text to be put into the clipboard.
--- 
---  Note:  Note: Available in Mudlet 4.10+
--- 
--- ## Example
--- ```lua
--- setClipboardText("New Clipboard Contents")
--- echo("Clipboard: " .. getClipboardText()) -- should echo "Clipboard: New Clipboard Contents"
--- ```
function setClipboardText(textContent)
end

---  Specifies a Lua function to be called if the user sends text to the command line. This function can pass any number of string or integer number values as additional parameters. These parameters are then used in the callback - thus you can associate data with the command line action. Additionally, this function passes the command line input text as the final argument.
--- Note:  If no action is set the command line behaves like the main command line and sends commands directly to the game or alias engine.
--- 
--- The function specified in `luaFunctionName` is called like so:
--- 
--- ```lua
--- luaFuncName(optional number of arguments, text)
--- ```
--- 
--- See also:
--- see: resetCmdLineAction()
--- ## Parameters
--- 
--- * `commandLineName:`
---  The name of the command line to attach the action function to.
--- * `luaFunctionName:`
---  The Lua function name to call, as a string.
--- * `any arguments:`
---  (optional) Any amount of arguments you'd like to pass to the calling function.
--- 
--- Note:  You can also pass a function directly instead of using a string
--- 
--- 
--- ## Example
--- ```lua
--- function sendTextToMiniConsole(miniConsoleName, cmdLineText)
---   echo(miniConsoleName, cmdLineText.."\n")
--- end
--- 
--- setCmdLineAction("myCmdLine", "sendTextToMiniConsole", "myMiniConsole")
--- 
--- ```
--- Note:  available in Mudlet 4.10+
function setCmdLineAction(commandLineName, luaFunctionName, any_arguments)
end

---  Applies Qt style formatting to a command line via a special markup language.
--- 
--- ## Parameters
--- * `commandLineName:`
---  (optional) Name of the command line (or miniconsole the command line is in). If not given the stylesheet will be applied to the main command line.
--- * `markup`
---  The string instructions, as specified by the Qt Style Sheet reference.
--- 
--- Note:  Available in Mudlet 4.10+
--- 
--- See also:
--- see: enableCommandLine()
--- see: createCommandLine()
--- ## Examples
--- ```lua
--- -- move the main command line over to the right
--- setCmdLineStyleSheet("main", [[
---   QPlainTextEdit {
---     padding-left: 100px; /* change 100 to your number */
---     background-color: black; /* change it to your background color */
---   }
--- ]])
--- 
--- --only change font-size of your main command line
--- setCmdLineStyleSheet("main", [[
---   QPlainTextEdit {
---     font-sizeː20pt; 
---   }
--- ]])
--- 
--- --change bg/fg color of your miniconsole command line (name of the miniconsole is 'myMiniconsole'
--- --the command line in the miniconsole has to be enabled
--- setCmdLineStyleSheet("myMiniConsole", [[
---   QPlainTextEdit {
---     background: rgb(0,100,0);
---     color: rgb(0,200,255);
---     font-size: 10pt;
---   }
--- ]])
--- ```
function setCmdLineStyleSheet(commandLineName, markup)
end

---  Sets the font on the given window or console name. Can be used to change font of the main console, miniconsoles, and userwindows. Prefer a monospaced font - those work best with text games. See here [https://doc.qt.io/qt-5/qfont.html#setFamily for more].
--- See also:
--- see: getFont()
--- see: setFontSize()
--- see: getFontSize()
--- see: openUserWindow()
--- see: getAvailableFonts()
--- ## Parameters
--- * `name:`
---  Optional - the window name to set font size of - can either be none or "main" for the main console, or a miniconsole / userwindow name.
--- * `font:`
---  The font to use.
--- 
--- Note: 
--- Available in Mudlet 3.9+
--- 
--- ## Example
--- ```lua
--- -- The following will set the "main" console window font to Ubuntu Mono, another font included in Mudlet.
--- setFont("Ubuntu Mono")
--- setFont("main", "Ubuntu Mono")
--- 
--- -- This will set the font size of a miniconsole named "combat" to Ubuntu Mono.
--- setFont("combat", "Ubuntu Mono")
--- ```
function setFont(name, font)
end

---  Sets a font size on the given window or console name. Can be used to change font size of the Main console as well as dockable UserWindows.
---  See Also: [[#getFontSize|getFontSize()]], [[#openUserWindow|openUserWindow()]]
--- 
--- ## Parameters
--- * `name:`
---  Optional - the window name to set font size of - can either be none or "main" for the main console, or a UserWindow name.
--- * `size:`
---  The font size to apply to the window.
--- 
--- Note: 
--- Available in Mudlet 3.4+
--- 
--- ## Example
--- ```lua
--- -- The following will set the "main" console window font to 12-point font.
--- setFontSize(12)
--- setFontSize("main", 12)
--- 
--- -- This will set the font size of a user window named "uw1" to 12-point font.
--- setFontSize("uw1", 12)
--- ```
function setFontSize(name, size)
end

---  Use this function when you want to change the gauges look according to your values. Typical usage would be in a prompt with your current health or whatever value, and throw in some variables instead of the numbers.
--- 
--- See also:
--- see: moveGauge()
--- see: createGauge()
--- see: setGaugeText()
--- ## Example
--- ```lua
--- -- create a gauge
--- createGauge("healthBar", 300, 20, 30, 300, nil, "green")
--- 
--- --Change the looks of the gauge named healthBar and make it
--- --fill to half of its capacity. The height is always remembered.
--- setGauge("healthBar", 200, 400)
--- ```
--- 
--- ```lua
--- --If you wish to change the text on your gauge, you’d do the following:
--- setGauge("healthBar", 200, 400, "some text")
--- ```
function setGauge(gaugeName, currentValue, maxValue, gaugeText)
end

---  Sets the CSS stylesheets on a gauge - one on the front (the part that resizes accoding to the values on the gauge) and one in the back. You can use [https://build-system.fman.io/qt-designer-download Qt Designer] to create stylesheets.
--- 
--- ## Example
--- ```lua
--- setGaugeStyleSheet("hp_bar", [[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #f04141, stop: 0.1 #ef2929, stop: 0.49 #cc0000, stop: 0.5 #a40000, stop: 1 #cc0000);
--- border-top: 1px black solid;
--- border-left: 1px black solid;
--- border-bottom: 1px black solid;
--- border-radius: 7;
--- padding: 3px;]],
--- [[background-color: QLinearGradient( x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #bd3333, stop: 0.1 #bd2020, stop: 0.49 #990000, stop: 0.5 #700000, stop: 1 #990000);
--- border-width: 1px;
--- border-color: black;
--- border-style: solid;
--- border-radius: 7;
--- padding: 3px;]])
--- ```
function setGaugeStyleSheet(gaugeName, css, cssback, csstext)
end

---  Set the formatting of the text used inside the inserted gaugename.
--- 
--- ## Example:
--- ```lua
--- setGaugeText("healthBar", [[<p style="font-weight:bold;color:#C9C9C9;letter-spacing:1pt;word-spacing:2pt;font-size:12px;text-align:center;font-family:arial black, sans-serif;">]]..MY_NUMERIC_VARIABLE_HERE..[[</p>]])```
--- 
--- ## Useful resources:
--- http://csstxt.com - Generate the text exactly how you like it before pasting it into the css slot.
--- https://www.w3schools.com/colors/colors_picker.asp - Can help you choose colors for your text!
function setGaugeText(gaugename, css, ccstext_)
end

--- Sets the current text nackground color in the main window unless windowName parameter given. This function allows to specify the color as a 6 character hexadecimal string.
--- 
--- * `windowName:`
---  Optional parameter set the current text background color in windowname given.
--- * `hexColorString`
---  6 character long hexadecimal string to set the color to. The first two characters 00-FF represent the red part of the color, the next two the green and the last two characters stand for the blue part of the color
--- 
--- See also:
--- see:  setBgColor()
--- see:  setHexFgColor()
--- ## Example
--- ```lua
--- --highlights the first occurrence of the string "Tom" in the current line with a red Background color.
--- selectString( "Tom", 1 )
--- setHexBgColor( "FF0000" )
--- ```
function setHexBgColor(windowName, hexColorString)
end

--- Sets the current text foreground color in the main window unless windowName parameter given. This function allows to specify the color as a 6 character hexadecimal string.
--- 
--- * `windowName:`
---  Optional parameter set the current text foreground color in windowname given.
--- * `hexColorString`
---  6 character long hexadecimal string to set the color to. The first two characters 00-FF represent the red part of the color, the next two the green and the last two characters stand for the blue part of the color
--- 
--- See also:
--- see:  setFgColor()
--- see:  setHexBgColor()
--- ## Example
--- ```lua
--- --highlights the first occurrence of the string "Tom" in the current line with a red foreground color.
--- selectString( "Tom", 1 )
--- setHexFgColor( "FF0000" )
--- ```
function setHexFgColor(windowName, hexColorString)
end

---  Sets the current text font to italics/non-italics mode. If the windowName parameters omitted, the main screen will be used.
function setItalics(windowName, bool)
end

---  Sets a tooltip on the given label.
--- Note:  available in Mudlet 4.6.1+
--- ## Parameters
--- 
--- * `labelName:`
---  The name of the label to set the tooltip to.
--- * `duration:`
---  Duration of the tooltip timeout in seconds. Optional, if not set the default duration will be set.
--- 
--- See also:
--- see: resetLabelToolTip()
function setLabelToolTip(labelName, duration)
end

---  Specifies a Lua function to be called if the user clicks on the label/image. This function can pass any number of string or integer number values as additional parameters. These parameters are then used in the callback - thus you can associate data with the label/button. Additionally, this function passes an event table as the final argument. This table contains information about the mouse button clicked, other buttons that were pressed at the time, and the mouse cursor's local (relative to the label) and global (relative to the Mudlet window) position. The function specified in `luaFunctionName` is called like so:
--- 
--- ```lua
--- luaFuncName(optional number of arguments, event)
--- ```
--- 
--- where **event** has the following structure:
--- 
--- ```lua
--- event = {
---   x = 100,
---   y = 200,
---   globalX = 300,
---   globalY = 320,
---   button = "LeftButton",
---   buttons = {"RightButton", "MidButton"},
--- }
--- ```
--- 
--- See also:
--- see: setLabelDoubleClickCallback()
--- see: setLabelReleaseCallback()
--- see: setLabelMoveCallback()
--- see: setLabelWheelCallback()
--- see: setLabelOnEnter()
--- see: setLabelOnLeave()
--- ## Parameters
--- 
--- * `labelName:`
---  The name of the label to attach a callback function to.
--- * `luaFunctionName:`
---  The Lua function name to call, as a string.
--- * `any arguments:`
---  (optional) Any amount of arguments you'd like to pass to the calling function.
--- 
--- Note:  Event argument is available in 3.6+, and in 4.8+ you can pass a function directly instead of a string.
--- 
--- Note: 
--- While **event.button** may contain a single string of any listed below, **event.buttons** will only ever contain some combination of "LeftButton", "MidButton", and "RightButton"
--- The following mouse button strings are defined:
--- ```
--- "LeftButton"        "RightButton"        "MidButton"
--- "BackButton"        "ForwardButton"      "TaskButton"
--- "ExtraButton4"      "ExtraButton5"       "ExtraButton6"
--- "ExtraButton7"      "ExtraButton8"       "ExtraButton9"
--- "ExtraButton10"     "ExtraButton11"      "ExtraButton12"
--- "ExtraButton13"     "ExtraButton14"      "ExtraButton15"
--- "ExtraButton16"     "ExtraButton17"      "ExtraButton18"
--- "ExtraButton19"     "ExtraButton20"      "ExtraButton21"
--- "ExtraButton22"     "ExtraButton23"      "ExtraButton24"
--- ```
--- ## Example
--- ```lua
--- function onClickGoNorth(event)
---   if event.button == "LeftButton" then
---     send("walk north")
---   else if event.button == "RightButton" then
---     send("swim north")
---   else if event.button == "MidButton" then
---     send("gallop north")
---   end
--- end
--- 
--- setLabelClickCallback( "compassNorthImage", "onClickGoNorth" )
--- 
--- -- you can also use them within tables now:
--- mynamespace = {
---   onClickGoNorth = function()
---     echo("the north button was clicked!")
---   end
--- }
--- 
--- setLabelClickCallback( "compassNorthImage", "mynamespace.onClickGoNorth" )
--- 
--- ```
function setLabelClickCallback(labelName, luaFunctionName, any_arguments)
end

---  Specifies a Lua function to be called if the user double clicks on the label/image. This function can pass any number of string or integer number values as additional parameters. These parameters are then used in the callback - thus you can associate data with the label/button. Additionally, this function passes an event table as the final argument, as in [[Manual:UI_Functions#setLabelClickCallback|setLabelClickCallback()]]
--- 
--- Note: 
--- Available in Mudlet 3.6+
--- 
--- See also:
--- see: setLabelClickCallback()
--- see: setLabelReleaseCallback()
--- see: setLabelMoveCallback()
--- see: setLabelWheelCallback()
--- see: setLabelOnEnter()
--- see: setLabelOnLeave()
--- ## Parameters
--- 
--- * `labelName:`
---  The name of the label to attach a callback function to.
--- * `luaFunctionName:`
---  The Lua function name to call, as a string.
--- * `any arguments:`
---  (optional) Any amount of arguments you'd like to pass to the calling function.
function setLabelDoubleClickCallback(labelName, luaFunctionName, any_arguments)
end

---  Specifies a Lua function to be called when the mouse moves while inside the specified label/console. This function can pass any number of string or integer number values as additional parameters. These parameters are then used in the callback - thus you can associate data with the label/button. Additionally, this function passes an event table as the final argument, as in [[Manual:UI_Functions#setLabelClickCallback|setLabelClickCallback()]]
--- 
---  See Also: [[Manual:UI_Functions#setLabelClickCallback|setLabelClickCallback()]], [[Manual:UI_Functions#setLabelDoubleClickCallback|setLabelDoubleClickCallback()]], [[Manual:UI_Functions#setLabelReleaseCallback|setLabelReleaseCallback()]], [[Manual:UI_Functions#setLabelWheelCallback|setLabelWheelCallback()]], [[Manual:UI_Functions#setLabelOnEnter|setLabelOnEnter()]], [[Manual:UI_Functions#setLabelOnLeave|setLabelOnLeave()]]
--- 
--- ## Parameters
--- 
--- * `labelName:`
---  The name of the label to attach a callback function to.
--- * `luaFunctionName:`
---  The Lua function name to call, as a string.
--- * `any arguments:`
---  (optional) Any amount of arguments you'd like to pass to the calling function.
--- 
--- Note: 
--- Available since Mudlet 3.6
function setLabelMoveCallback(labelName, luaFunctionName, any_arguments)
end

---  Specifies a Lua function to be called when the mouse enters within the labels borders. This function can pass any number of string or integer number values as additional parameters. These parameters are then used in the callback - thus you can associate data with the label/button. Additionally, this function passes an event table as the final argument, similar to [[Manual:UI_Functions#setLabelClickCallback|setLabelClickCallback()]], but with slightly different information.
---  For this callback, the **event** argument has the following structure:
--- 
--- ```lua
--- event = {
---   x = 100,
---   y = 200,
---   globalX = 300,
---   globalY = 320,
--- }
--- ```
--- 
---  See Also: [[Manual:UI_Functions#setLabelClickCallback|setLabelClickCallback()]], [[Manual:UI_Functions#setLabelDoubleClickCallback|setLabelDoubleClickCallback()]], [[Manual:UI_Functions#setLabelReleaseCallback|setLabelReleaseCallback()]], [[Manual:UI_Functions#setLabelMoveCallback|setLabelMoveCallback()]], [[Manual:UI_Functions#setLabelWheelCallback|setLabelWheelCallback()]], [[Manual:UI_Functions#setLabelOnLeave|setLabelOnLeave()]]
--- 
--- ## Parameters
--- 
--- * `labelName:`
---  The name of the label to attach a callback function to.
--- * `luaFunctionName:`
---  The Lua function name to call, as a string - it must be registered as a global function, and not inside any namespaces (tables).
--- * `any arguments:`
---  (optional) Any amount of arguments you'd like to pass to the calling function.
--- 
--- ## Example
--- 
--- ```lua
--- function onMouseOver()
---   echo("The mouse is hovering over the label!\n")
--- end
--- 
--- setLabelOnEnter( "compassNorthImage", "onMouseOver" )
--- ```
function setLabelOnEnter(labelName, luaFunctionName, any_arguments)
end

---  Specifies a Lua function to be called when the mouse leaves the labels borders. This function can pass any number of string or integer number values as additional parameters. These parameters are then used in the callback - thus you can associate data with the label/button.
--- 
---  See Also: [[Manual:UI_Functions#setLabelClickCallback|setLabelClickCallback()]], [[Manual:UI_Functions#setLabelOnEnter|setLabelOnEnter()]]
--- 
--- ## Parameters
--- 
--- * `labelName:`
---  The name of the label to attach a callback function to.
--- * `luaFunctionName:`
---  The Lua function name to call, as a string - it must be registered as a global function, and not inside any namespaces (tables).
--- * `any arguments:`
---  (optional) Any amount of arguments you'd like to pass to the calling function.
--- 
--- ## Example
--- 
--- ```lua
--- function onMouseLeft(argument)
---   echo("The mouse quit hovering over the label the label! We also got this as data on the function: "..argument)
--- end
--- 
--- setLabelOnLeave( "compassNorthImage", "onMouseLeft", "argument to pass to function" )
--- ```
function setLabelOnLeave(labelName, luaFunctionName, any_arguments)
end

---  Specifies a Lua function to be called when a mouse click ends that originated on the specified label/console. This function is called even if you drag the mouse off of the label/console before releasing the click. This function can pass any number of string or integer number values as additional parameters. These parameters are then used in the callback - thus you can associate data with the label/button. Additionally, this function passes an event table as the final argument, as in [[Manual:UI_Functions#setLabelClickCallback|setLabelClickCallback()]]
--- 
---  See Also: [[Manual:UI_Functions#setLabelClickCallback|setLabelClickCallback()]], [[Manual:UI_Functions#setLabelDoubleClickCallback|setLabelDoubleClickCallback()]], [[Manual:UI_Functions#setLabelMoveCallback|setLabelMoveCallback()]], [[Manual:UI_Functions#setLabelWheelCallback|setLabelWheelCallback()]], [[Manual:UI_Functions#setLabelOnEnter|setLabelOnEnter()]], [[Manual:UI_Functions#setLabelOnLeave|setLabelOnLeave()]]
--- 
--- ## Parameters
--- 
--- * `labelName:`
---  The name of the label to attach a callback function to.
--- * `luaFunctionName:`
---  The Lua function name to call, as a string.
--- * `any arguments:`
---  (optional) Any amount of arguments you'd like to pass to the calling function.
--- 
--- Note: 
--- This command was added in version 3.0.0
--- 
--- Note: 
--- The `event` argument only available since Mudlet 3.6
--- 
--- ## Example
--- ```lua
--- function onReleaseNorth()
---   echo("the north button was released!")
--- end
--- 
--- setLabelReleaseCallback( "compassNorthImage", "onReleaseNorth" )
--- 
--- -- you can also use them within tables:
--- mynamespace = {
---   onReleaseNorth = function()
---     echo("the north button was released!")
---   end
--- }
--- 
--- setLabelReleaseCallback( "compassNorthImage", "mynamespace.onReleaseNorth" )
--- ```
function setLabelReleaseCallback(labelName, luaFunctionName, any_arguments)
end

---  Applies Qt style formatting to a label via a special markup language.
--- 
--- ##  Parameters
--- * `label:`
---  The name of the label to be formatted (passed when calling createLabel).
--- * `markup:`
---  The string instructions, as specified by the Qt Style Sheet reference.
---  Note that when specifying a file path for styling purposes, forward slashes, / , must be used, even if your OS uses backslashes, \ , normally.
--- 
--- ## References
---  http://qt-project.org/doc/qt-5/stylesheet-reference.html
--- 
--- ## Example
--- ```lua
--- -- This creates a label with a white background and a green border, with the text "test"
--- -- inside.
--- createLabel("test", 50, 50, 100, 100, 0)
--- setLabelStyleSheet("test", [[
---   background-color: white;
---   border: 10px solid green;
---   font-size: 12px;
---   ]])
--- echo("test", "test")
--- ```
--- ```lua
--- -- This creates a label with a single image, that will tile or clip depending on the
--- -- size of the label. To use this example, please supply your own image.
--- createLabel("test5", 50, 353, 164, 55, 0)
--- setLabelStyleSheet("test5", [[
---   background-image: url("C:/Users/Administrator/.config/mudlet/profiles/Midkemia Online/Vyzor/MkO_logo.png");
---   ]])
--- ```
--- ```lua
--- -- This creates a label with a single image, that can be resized (such as during a
--- -- sysWindowResizeEvent). To use this example, please supply your own image.
--- createLabel("test9", 215, 353, 100, 100, 0)
--- setLabelStyleSheet("test9", [[
---   border-image: url("C:/Users/Administrator/.config/mudlet/profiles/Midkemia Online/Vyzor/MkO_logo.png");
---   ]])
--- ```
--- ```lua
--- --This creates a label whose background changes when the users mouse hovers over it.
--- 
--- --putting the styleSheet in a variable allows us to easily change the styleSheet. We also are placing colors in variables that have been preset.  
--- local labelBackgroundColor = "#123456"
--- local labelHoverColor = "#654321"
--- local labelFontSize = 12
--- local labelName = "HoverLabel"
--- local ourLabelStyle = [[
--- QLabel{
--- 	background-color: ]]..labelBackgroundColor..[[;
--- 	font-size: ]]..labelFontSize..[[px;
--- 	qproperty-alignment: 'AlignCenter | AlignCenter';
--- }
--- QLabel::hover{
--- 	background-color: ]]..labelHoverColor..[[;
--- 	font-size: ]]..labelFontSize..[[px;
--- 	qproperty-alignment: 'AlignCenter | AlignCenter';
--- }
--- ]]
--- 
--- --Creating the label using the labelName and ourLabelStyle variables created above.
--- createLabel(labelName,0,0,400,400,1)
--- setLabelStyleSheet(labelName, ourLabelStyle)
--- echo("HoverLabel","This text shows while mouse is or is not over the label.")
--- ```
--- ```lua
--- --Using QLabel::hover mentioned above. Lets "trick" the label into changing it's text.
--- --Please keep in mind that the setLabelMoveCallback allows for much more control over not just your label but your entire project.
--- 
--- --putting the styleSheet in a variable allows us to easily change the styleSheet. We also are placing colors in variables that have been preset.  
--- local labelBackgroundColor = "#123456"
--- local labelHoverColor = "#654321"
--- local labelFontSize = 12
--- local labelName = "HoverLabel"
--- --Notice we are adding a string returned from a function. In this case, the users profile directory.
--- local ourLabelStyle = [[
--- QLabel{
--- 	border-image: url("]]..getMudletHomeDir()..[[/imagewithtext.png");
--- }
--- QLabel::hover{
--- 	border-image: url("]]..getMudletHomeDir()..[[/imagewithhovertext.png");
--- }
--- ]]
--- 
--- --Creating the label using the labelName and ourLabelStyle variables created above.
--- createLabel(labelName,0,0,400,400,1)
--- setLabelStyleSheet(labelName, ourLabelStyle)
--- --This is just to example that echos draw on top of the label. You would not want to echo onto a label you were drawing text on with images, because echos would draw on top of them.
--- echo("HoverLabel","This text shows while mouse is or is not over the label.")
--- ```
function setLabelStyleSheet(label, markup)
end

---  Changes how the mouse cursor looks like when over the label. To reset the cursor shape, use [[#resetLabelCursor|resetLabelCursor()]].
--- 
--- See also:
--- see: resetLabelCursor()
--- see: setLabelCustomCursor()
--- {{Note}} Available in Mudlet 4.8+
--- 
--- ## Parameters
--- * `labelName:`
---  Name of the label which you want the mouse cursor change at.
--- * `cursorShape`
---  Shape of the mouse cursor. List of possible cursor shapes is [[CursorShapes| available here]].
--- ## Example
--- ```lua
--- setLabelCursor("myLabel", "Cross")
--- -- This will change the mouse cursor to a cross if it's over the label myLabel
--- ```
function setLabelCursor(labelName, cursorShape)
end

---  Changes the mouse cursor shape over your label to a custom cursor. To reset the cursor shape, use [[#resetLabelCursor|resetLabelCursor()]].
--- 
--- See also:
--- see: resetLabelCursor()
--- see: setLabelCursor()
--- {{Note}} Available in Mudlet 4.8+
--- 
--- ## Parameters
--- * `labelName:`
---  Name of the label which you want the mouse cursor change at.
--- * `custom cursor`
---  Location of your custom cursor file. To be compatible with all systems it is recommended to use png files with size of 32x32.
--- * `hotX`
---  X-coordinate of the cursors hotspot position. Optional, if not set it is set to -1 which is in the middle of your custom cursor.
--- * `hotY`
---  Y-coordinate of the cursors hotspot position. Optional, if not set it is set to -1 which is in the middle of your custom cursor.
--- ## Example
--- ```lua
--- setLabelCustomCursor("myLabel", getMudletHomeDir().."/custom_cursor.png")
--- -- This will change the mouse cursor to your custom cursor if it's over the label myLabel
--- ```
function setLabelCustomCursor(labelName, custom_cursor, hotX, hotY)
end

---  Specifies a Lua function to be called when the mouse wheel is scrolled while inside the specified label/console. This function can pass any number of string or integer number values as additional parameters. These parameters are then used in the callback - thus you can associate data with the label/button. Additionally, this function passes an event table as the final argument, similar to [[Manual:UI_Functions#setLabelClickCallback|setLabelClickCallback()]], but with slightly different information.
---  For this callback, the `event` argument has the following structure:
--- 
--- ```lua
--- event = {
---   x = 100,
---   y = 200,
---   globalX = 300,
---   globalY = 320,
---   buttons = {"RightButton", "MidButton"},
---   angleDeltaX = 0,
---   angleDeltaY = 120
--- }
--- ```
--- 
---  Keys `angleDeltaX` and `angleDeltaY` correspond with the horizontal and vertical scroll distance, respectively. For most mice, these values will be multiples of 120.
--- 
---  See Also: [[Manual:UI_Functions#setLabelClickCallback|setLabelClickCallback()]], [[Manual:UI_Functions#setLabelDoubleClickCallback|setLabelDoubleClickCallback()]], [[Manual:UI_Functions#setLabelReleaseCallback|setLabelReleaseCallback()]], [[Manual:UI_Functions#setLabelMoveCallback|setLabelMoveCallback()]], [[Manual:UI_Functions#setLabelOnEnter|setLabelOnEnter()]], [[Manual:UI_Functions#setLabelOnLeave|setLabelOnLeave()]]
--- 
--- ## Parameters
--- 
--- * `labelName:`
---  The name of the label to attach a callback function to.
--- * `luaFunctionName:`
---  The Lua function name to call, as a string.
--- * `any arguments:`
---  (optional) Any amount of arguments you'd like to pass to the calling function.
--- 
--- Note: 
--- Available since Mudlet 3.6
--- 
--- ## Example
--- ```lua
--- function onWheelNorth(event)
---   if event.angleDeltaY > 0 then
---     echo("the north button was wheeled forwards over!")
---   else
---     echo("the north button was wheeled backwards over!")
---   end
--- end
--- 
--- setLabelWheelCallback( "compassNorthImage", "onWheelNorth" )
--- 
--- -- you can also use them within tables:
--- mynamespace = {
---   onWheelNorth = function()
---     echo("the north button was wheeled over!")
---   end
--- }
--- 
--- setWheelReleaseCallback( "compassNorthImage", "mynamespace.onWheelNorth" )
--- ```
function setLabelWheelCallback(labelName, luaFunctionName, any_arguments)
end

---  Turns the [[Manual:Lua_Functions#selectString|selected()]] text into a clickable link - upon being clicked, the link will do the command code. Tooltip is a string which will be displayed when the mouse is over the selected text.
--- 
--- ## Parameters
--- * `windowName:`
---  (optional) name of a miniconsole or a userwindow in which to select the text in.
--- * `command:`
---  command to do when the text is clicked.
--- * `tooltip:`
---  tooltip to show when the mouse is over the text - explaining what would clicking do.
--- 
--- ## Example
--- 
--- ```lua
--- -- you can clickify a lot of things to save yourself some time - for example, you can change
--- --  the line where you receive a message to be clickable to read it!
--- -- prel regex trigger:
--- -- ^You just received message #(\w+) from \w+\.$
--- -- script:
--- selectString(matches[2], 1)
--- setUnderline(true) setLink([[send("msg read ]]..matches[2]..[[")]], "Read #"..matches[2])
--- resetFormat()
--- 
--- -- an example of selecting text in a miniconsole and turning it into a link:
--- 
--- HelloWorld = Geyser.MiniConsole:new({
---   name="HelloWorld",
---   x="70%", y="50%",
---   width="30%", height="50%",
--- })
--- HelloWorld:echo("hi")
--- selectString("HelloWorld", "hi", 1)
--- setLink("HelloWorld", "echo'you clicked hi!'", "click me!")
--- ```
function setLink(windowName, command, tooltip)
end

---  Changes the size of your main Mudlet window to the values given.
---  See Also: [[Manual:Lua_Functions#getMainWindowSize|getMainWindowSize()]]
--- 
--- ##  Parameters
--- * `mainWidth:`
---  The new width in pixels.
--- * `mainHeight:`
---  The new height in pixels.
--- 
--- ## Example
--- ```lua
--- --this will resize your main Mudlet window
--- setMainWindowSize(1024, 768)
--- ```
function setMainWindowSize(mainWidth, mainHeight)
end

---  Changes the title shown in the mapper window when it's popped out.
--- See also:
--- see: resetMapWindowTitle()
--- ##  Parameters
--- * `text:`
---  New window title to set.
--- 
--- Note:  Available in Mudlet 4.8+
--- 
--- ## Example
--- ```lua
--- setMapWindowTitle("my cool game map")
--- ```
function setMapWindowTitle(text)
end

---  Sets the font size of the mini console. see also: [[#createMiniConsole | createMiniConsole()]], [[#createLabel | createLabel()]]
function setMiniConsoleFontSize(name, fontSize)
end

---  Sets the current text font to be overlined (true) or not overlined (false) mode. If the windowName parameters omitted, the main screen will be used. If you've got text currently selected in the Mudlet buffer, then the selection will be overlined. Any text you add after with [[Manual:Lua_Functions#echo|echo()]] or [[Manual:Lua_Functions#insertText|insertText()]] will be overlined until you use [[Manual:Lua_Functions#resetFormat|resetFormat()]].
--- 
--- * `windowName:`
---  (optional) name of the window to set the text to be overlined or not.
--- 
--- * `boolean:`
---  A `true` or `false` that enables or disables overlining of text
--- 
--- ## Example
--- 
--- ```lua
--- -- enable overlined text
--- setOverline(true)
--- -- the following echo will be have an overline
--- echo("hi")
--- -- turns off bolding, italics, underlines, colouring, and strikethrough (and, after this and reverse have been added, them as well). It's good practice to clean up after you're done with the formatting, so other your formatting doesn't "bleed" into other echoes.
--- resetFormat()
--- ```
--- 
--- Note:  Available since Mudlet 3.17+
function setOverline(windowName, boolean)
end

---  Turns the [[Manual:Lua_Functions#selectString|selected()]] text into a left-clickable link, and a right-click menu for more options. The selected text, upon being left-clicked, will do the first command in the list. Upon being right-clicked, it'll display a menu with all possible commands. The menu will be populated with hints, one for each line.
--- 
--- ##  Parameters
--- * `windowName:`
---  the name of the console to operate on. If not using this in a miniConsole, use "main" as the name.
--- * `{lua code}:`
---  a table of lua code strings to do. ie, ```lua" inline="
--- [[send("hello")]], [[echo("hi!"]]}```
--- * `{hints}:`
---  a table of strings which will be shown on the popup and right-click menu. ie, ```lua" inline="
--- "send the hi command", "echo hi to yourself"}```.
--- 
--- ## Example
--- ```lua
--- -- In a `Raising your hand in greeting, you say "Hello!"` exact match trigger,
--- -- the following code will make left-clicking on `Hello` show you an echo, while right-clicking
--- -- will show some commands you can do.
--- 
--- selectString("Hello", 1)
--- setPopup("main", {[[send("bye")]], [[echo("hi!")]]}, {"left-click or right-click and do first item to send bye", "click to echo hi"})
--- ```
function setPopup(windowName, {lua_code}, {hints})
end

---  Sets a stylesheet for the current Mudlet profile - allowing you to customise content outside of the main window (the profile tabs, the scrollbar, and so on). This function is better than setAppStyleSheet() because it affects only the current profile and not every other one as well.
--- 
--- See also:
--- see: setAppStyleSheet()
--- ## Parameters
--- 
--- * `stylesheet:`
---  The entire stylesheet you'd like to use. See [http://qt-project.org/doc/qt-5/stylesheet-reference.html Qt Style Sheets Reference] for the list of widgets you can style and CSS properties you can apply on them.
---  
---  See also [https://github.com/vadi2/QDarkStyleSheet/blob/master/qdarkstyle/style.qss QDarkStyleSheet], a rather extensive stylesheet that shows you all the different configuration options you could apply, available as an [http://forums.mudlet.org/viewtopic.php?f=6&t=17624 mpackage here].
--- 
--- ## Example
--- ```lua
--- -- credit to Akaya @ http://forums.mudlet.org/viewtopic.php?f=5&t=4610&start=10#p21770
--- local background_color = "#26192f"
--- local border_color = "#b8731b"
--- 
--- setProfileStyleSheet([[
---   QMainWindow {
---      background: ]]..background_color..[[;
---   }
---   QToolBar {
---      background: ]]..background_color..[[;
---   }
---   QToolButton {
---      background: ]]..background_color..[[;
---      border-style: solid;
---      border-width: 2px;
---      border-color: ]]..border_color..[[;
---      border-radius: 5px;
---      font-family: BigNoodleTitling;
---      color: white;
---      margin: 2px;
---      font-size: 12pt;
---   }
---   QToolButton:hover { background-color: grey;}
---   QToolButton:focus { background-color: grey;}
--- 
---   QTreeView {
---      background: ]]..background_color..[[;
---      color: white;
---   }
--- 
---   QMenuBar{ background-color: ]]..background_color..[[;}
--- 
---   QMenuBar::item{ background-color: ]]..background_color..[[;}
--- 
---   QDockWidget::title {
---      background: ]]..border_color..[[;
---   }
---   QStatusBar {
---      background: ]]..border_color..[[;
---   }
---   QScrollBar:vertical {
---      background: ]]..background_color..[[;
---      width: 15px;
---      margin: 22px 0 22px 0;
---   }
---   QScrollBar::handle:vertical {
---      background-color: ]]..background_color..[[;
---      min-height: 20px;
---      border-width: 2px;
---      border-style: solid;
---      border-color: ]]..border_color..[[;
---      border-radius: 7px;
---   }
---   QScrollBar::add-line:vertical {
---    background-color: ]]..background_color..[[;
---    border-width: 2px;
---    border-style: solid;
---    border-color: ]]..border_color..[[;
---    border-bottom-left-radius: 7px;
---    border-bottom-right-radius: 7px;
---         height: 15px;
---         subcontrol-position: bottom;
---         subcontrol-origin: margin;
---   }
---   QScrollBar::sub-line:vertical {
---    background-color: ]]..background_color..[[;
---    border-width: 2px;
---    border-style: solid;
---    border-color: ]]..border_color..[[;
---    border-top-left-radius: 7px;
---    border-top-right-radius: 7px;
---         height: 15px;
---         subcontrol-position: top;
---         subcontrol-origin: margin;
---   }
---   QScrollBar::up-arrow:vertical, QScrollBar::down-arrow:vertical {
---      background: white;
---      width: 4px;
---      height: 3px;
---   }
---   QScrollBar::add-page:vertical, QScrollBar::sub-page:vertical {
---      background: none;
---   }
--- ]])
--- 
--- -- if you'd like to reset it, use:
--- setProfileStyleSheet("")
--- 
--- -- to only affect scrollbars within the main window and miniconsoles, prefix them with 'TConsole':
--- setProfileStyleSheet[[
---   TConsole QScrollBar:vertical {
---       border: 2px solid grey;
---       background: #32CC99;
---       width: 15px;
---       margin: 22px 0 22px 0;
---   }
---   TConsole QScrollBar::handle:vertical {
---       background: white;
---       min-height: 20px;
---   }
---   TConsole QScrollBar::add-line:vertical {
---       border: 2px solid grey;
---       background: #32CC99;
---       height: 20px;
---       subcontrol-position: bottom;
---       subcontrol-origin: margin;
---   }
---   TConsole QScrollBar::sub-line:vertical {
---       border: 2px solid grey;
---       background: #32CC99;
---       height: 20px;
---       subcontrol-position: top;
---       subcontrol-origin: margin;
---   }
---   TConsole QScrollBar::up-arrow:vertical, QScrollBar::down-arrow:vertical {
---       border: 2px solid grey;
---       width: 3px;
---       height: 3px;
---       background: white;
---   }
---   TConsole QScrollBar::add-page:vertical, QScrollBar::sub-page:vertical {
---       background: none;
---   }
--- ]]
--- ```
--- 
--- Note: 
--- Available since Mudlet 4.6.
function setProfileStyleSheet(stylesheet)
end

---  Sets the current text to swap foreground and background color settings (true) or not (false) mode. If the windowName parameters omitted, the main screen will be used. If you've got text currently selected in the Mudlet buffer, then the selection will have it's colors swapped. Any text you add after with [[Manual:Lua_Functions#echo|echo()]] or [[Manual:Lua_Functions#insertText|insertText()]] will have their foreground and background colors swapped until you use [[Manual:Lua_Functions#resetFormat|resetFormat()]].
--- 
--- * `windowName:`
---  (optional) name of the window to set the text colors to be reversed or not.
--- 
--- * `boolean:`
---  A `true` or `false` that enables or disables reversing of the fore- and back-ground colors of text
--- 
--- ## Example
--- 
--- ```lua
--- -- enable fore/back-ground color reversal of text
--- setReverse(true)
--- -- the following echo will have the text colors reversed
--- echo("hi")
--- -- turns off bolding, italics, underlines, colouring, and strikethrough (and, after this and overline have been added, them as well). It's good practice to clean up after you're done with the formatting, so other your formatting doesn't "bleed" into other echoes.
--- resetFormat()
--- ```
--- 
--- Note:  Available since Mudlet 3.17+
--- 
--- Note:  Although the visual effect on-screen is the same as that of text being selected if both apply to a piece of text they neutralise each other - however the effect of the reversal `will` be carried over in copies made by the "Copy to HTML" and in logs made in HTML format log file mode.
function setReverse(windowName, boolean)
end

---  Sets the current text font to be striken out (true) or not striken out (false) mode. If the windowName parameters omitted, the main screen will be used. If you've got text currently selected in the Mudlet buffer, then the selection will be bolded. Any text you add after with [[Manual:Lua_Functions#echo|echo()]] or [[Manual:Lua_Functions#insertText|insertText()]] will be striken out until you use [[Manual:Lua_Functions#resetFormat|resetFormat()]].
--- 
--- * `windowName:`
---  (optional) name of the window to set the text to be stricken out or not.
--- 
--- * `boolean:`
---  A `true` or `false` that enables or disables striking out of text
--- 
--- ## Example
--- 
--- ```lua
--- -- enable striken-out text
--- setStrikeOut(true)
--- -- the following echo will be have a strikethrough
--- echo("hi")
--- -- turns off bolding, italics, underlines, colouring, and strikethrough. It's good practice to clean up after you're done with the formatting, so other your formatting doesn't "bleed" into other echoes.
--- resetFormat()
--- ```
function setStrikeOut(windowName, boolean)
end

---  Sets current text format of selected window. This is a more convenient means to set all the individual features at once compared to using [[#setFgColor|setFgColor]]( windowName, r,g,b ), [[#setBold|setBold]]( windowName, true ), [[#setItalics|setItalics]]( windowName, true ), [[#setUnderline|setUnderline]]( windowName, true ), [[#setStrikeOut|setStrikeOut]]( windowName, true ).
---  See Also: [[Manual:Lua_Functions#getTextFormat|getTextFormat()]]
--- 
--- ## Parameters
--- * `windowName`
---  Specify name of selected window. If empty string "" or "main" format will be applied to the main console
--- * `r1,g1,b1`
---  To color text background, give number values in RBG style
--- * `r2,g2,b2`
---  To color text foreground, give number values in RBG style
--- * `bold`
---  To format text bold, set to 1 or true, otherwise 0 or false
--- * `underline`
---  To underline text, set to 1 or true, otherwise 0 or false
--- * `italics`
---  To format text italic, set to 1 or true, otherwise 0 or false
--- * `strikeout
---  (optional) To strike text out, set to 1 or true, otherwise 0 or false or simply no argument
--- * `overline
---  (optional) To use overline, set to 1 or true, otherwise 0 or false or simply no argument
--- * `reverse
---  (optional) To swap foreground and background colors, set to 1 or true, otherwise 0 or false or simply no argument
--- 
--- ## Example:
--- ```lua
--- --This script would create a mini text console and write with bold, struck-out, yellow foreground color and blue background color "This is a test".
--- createMiniConsole( "con1", 0,0,300,100);
--- setTextFormat("con1",0,0,255,255,255,0,true,0,false,1);
--- echo("con1","This is a test")
--- ```
--- 
--- Note:  In versions prior to 3.7.0 the error messages `and this wiki` were wrong in that they had the foreground color parameters as r1, g1 and b1 and the background ones as r2, g2 and b2.
function setTextFormat(windowName, r1, g1, b1, r2, g2, b2, bold, underline, italics, strikeout, overline, reverse)
end

---  Sets the current text font to underline/non-underline mode. If the windowName parameters omitted, the main screen will be used.
function setUnderline(windowName, bool)
end

---  sets a new title text for the UserWindow windowName
--- 
--- ## Parameters
--- * `windowName:`
---  Name of the userwindow
--- * `text`
---  new title text
--- 
--- Note:  Available in Mudlet 4.8+
--- 
--- See also:
--- see: resetUserWindowTitle()
--- see: openUserWindow()
function setUserWindowTitle(windowName, text)
end

---  Applies Qt style formatting to the border/title area of a userwindow via a special markup language.
--- 
--- ## Parameters
--- * `windowName:`
---  Name of the userwindow
--- * `markup`
---  The string instructions, as specified by the Qt Style Sheet reference.
---  Note that when you dock the userwindow the border style is not provided by this
--- 
--- Note:  Available in Mudlet 4.10+
--- 
--- ## Example
--- ```lua
--- -- changes the title area style of the UserWindow 'myUserWindow'
--- setUserWindowStyleSheet("myUserWindow", [[QDockWidget::title{ 
---     background-color: rgb(0,255,150);
---     border: 2px solid red;
---     border-radius: 8px;
---     text-align: center;    
---     }]])
--- ```
--- 
--- See also:
--- see: openUserWindow()
function setUserWindowStyleSheet(windowName, markup)
end

---  Changes the parent window of an element.
--- {{Note}} Available in Mudlet 4.8+
--- 
--- ## Parameters
--- * `windowName:`
---  Name of the userwindow which you want the element put in. If you want to put the element into the main window, use windowName "main".
--- * `name`
---  Name of the element which you want to switch the parent from. Elements can be labels, miniconsoles and the embedded mapper. If you want to move the mapper use the name "mapper"
--- * `Xpos:`
---  X position of the element. Measured in pixels, with 0 being the very left. Passed as an integer number. Optional, if not given it will be 0.
--- * `Ypos:`
---  Y position of the element. Measured in pixels, with 0 being the very top. Passed as an integer number. Optional, if not given it will be 0.
--- * `show:`
---  true or false to decide if the element will be shown or not in the new parent window. Optional, if not given it will be true.
--- ## Example
--- ```lua
--- setWindow("myuserwindow", "mapper")
--- -- This will put your embedded mapper in your userwindow "myuserwindow".
--- ```
function setWindow(windowName, name, Xpos, Ypos, show)
end

---  sets at what position in the line the will start word wrap.
--- 
--- ## Parameters
--- * `windowName:`
---  Name of the "main" console or user-created miniconsole which you want to be wrapped differently. If you want to wrap the main window, use windowName "main".
--- * `wrapAt:`
---  Number of characters at which the wrap must happen at the latest. This means, it probably will be wrapped earlier than that.
--- 
--- ## Example
--- ```lua
--- setWindowWrap("main", 10)
--- display("This is just a test")
--- 
--- -- The following output will result in the main window console:
--- "This is
--- just a
--- test"
--- ```
function setWindowWrap(windowName, wrapAt)
end

---  sets how many spaces wrapped text will be indented with (after the first line of course).
--- 
--- ## Parameters
--- * `windowName:`
---  Name of the "main" console or user-created miniconsole which you want to be wrapped differently. If you want to wrap the main window, use windowName "main".
--- * `wrapTo:`
---  Number of spaces which wrapped lines are prefixed with.
--- 
--- ## Example
--- ```lua
--- setWindowWrap("main", 10)
--- setWindowWrapIndent("main", 3)
--- display("This is just a test")
--- 
--- -- The following output will result in the main window console:
--- "This is
---    just a
---    test"
--- ```
function setWindowWrapIndent(windowName, wrapTo)
end

--- Lua debug function that highlights in random colors all capture groups in your trigger regex on the screen. This is very handy if you make complex regex and want to see what really matches in the text. This function is defined in LuaGlobal.lua.
--- 
--- ## Example:
--- Make a trigger with the regex (\w+) and call this function in a trigger. All words in the text will be highlighted in random colors.
function showCaptureGroups()
end

--- Lua helper function to show you what the table multimatches[n][m] contains. This is very useful when debugging multiline triggers - just doing showMultimatches() in your script will make it give the info.
function showMultimatches()
end

---  Makes a hidden window (label or miniconsole) be shown again.
--- 
--- See also:
--- see:  hideWindow()
function showWindow(name)
end

---  shows the named colors currently available in Mudlet's color table. These colors are stored in **color_table**, in table form. The format is `color_table.colorName = {r, g, b}`.
--- 
---  See Also: [[Manual:Lua_Functions#bg|bg()]], [[Manual:Lua_Functions#fg|fg()]], [[Manual:Lua_Functions#cecho|cecho()]]
--- 
--- ## Parameters
--- * `columns:`
---  (optional) number of columns to print the color table in.
--- * `filterColor:`
---  (optional) filter text. If given, the colors displayed will be limited to only show colors containing this text.
--- * `sort:`
---  (optional) sort colors alphabetically.
--- 
--- ## Example:
--- 
--- ```lua
--- -- display as four columns:
--- showColors(4)
--- 
--- -- show only red colours:
--- showColors("red")
--- ```
--- The output for this is:
function showColors(columns, filterColor, sort)
end

---  Makes a toolbar (a button group) appear on the screen.
--- 
--- ## Parameters
--- * `name:`
---  name of the button group to display
--- 
--- ## Example
--- ```lua
--- showToolBar("my attack buttons")
--- ```
function showToolBar(name)
end

---  Suffixes text at the end of the current line. This is similar to [[Manual:Lua_Functions#echo | echo()]], which also suffixes text at the end of the line, but different - [[Manual:Lua_Functions#echo | echo()]] makes sure to do it on the last line in the buffer, while suffix does it on the line the cursor is currently on.
--- 
--- ## Parameters
--- * `text`
---  the information you want to prefix
--- * `writingFunction`
---  optional parameter, allows the selection of different functions to be used to write the text, valid options are: echo, cecho, decho, and hecho.
--- * `foregroundColor`
---  optional parameter, allows a foreground color to be specified if using the echo function using a color name, as with the fg() function
--- * `backgroundColor`
---  optional parameter, allows a background color to be specified if using the echo function using a color name, as with the bg() function
--- * `windowName`
---  optional parameter, allows the selection a miniconsole or the main window for the line that will be prefixed
--- 
--- See also:
--- see:  prefix()
--- see:  echo()
function suffix(text, writingFunction, foregroundColor, backgroundColor, windowName)
end

---  wraps the line specified by `lineNumber` of mini console (window) `windowName`. This function will interpret \n characters, apply word wrap and display the new lines on the screen. This function may be necessary if you use deleteLine() and thus erase the entire current line in the buffer, but you want to do some further echo() calls after calling deleteLine(). You will then need to re-wrap the last line of the buffer to actually see what you have echoed and get your \n interpreted as newline characters properly. Using this function is no good programming practice and should be avoided. There are better ways of handling situations where you would call deleteLine() and echo afterwards e.g.:
--- 
--- ```lua
--- electString(line,1)
--- replace("")```
--- 
--- This will effectively have the same result as a call to deleteLine() but the buffer line will not be entirely removed. Consequently, further calls to echo() etc. sort of functions are possible without using wrapLine() unnecessarily.
--- 
---  See Also: [[Manual:Lua_Functions#replace|replace()]], [[Manual:Lua_Functions#deleteLine|deleteLine()]]
--- 
--- ## Parameters
--- * `windowName:`
---  The miniconsole or the main window (use `main` for the main window)
--- * `lineNumber:`
---  The line number which you'd like re-wrapped.
--- 
--- ## Example
--- ```lua
--- -- re-wrap the last line in the main window
--- wrapLine("main", getLineCount())
--- ```
function wrapLine(windowName, lineNumber)
end

