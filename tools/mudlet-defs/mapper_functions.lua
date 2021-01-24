--- 
--- Adds a new area name and returns the new (positive) area ID for the new name. If the name already exists, older versions of Mudlet returned -1 though since 3.0 the code will return `nil` and an error message.
--- See also:
--- see: deleteArea()
--- see: addRoom()
--- ## Example
--- ```lua
--- local newId, err = addAreaName(string.random(10))
--- 
--- if newId == nil or newId < 1 or err then
---   echo("That area name could not be added - error is: ".. err.."\n")
--- else
---   cecho("<green>Created new area with the ID of "..newId..".\n")
--- end
--- ```
function addAreaName(areaName)
end

--- See also:
--- see: getCustomLines()
--- see: removeCustomLine()
--- Adds a new/replaces an existing custom exit line to the 2D mapper for the room with the Id given.
--- 
--- ## Parameters
--- * `roomID:`
---  Room ID to attach the custom line to.
--- * `id_to:`
---  EITHER: a room Id number, of a room on same area who's x and y coordinates are used as the other end of a SINGLE segment custom line (it does NOT imply that is what the exit it represent goes to, just the location of the end of the line);
---  OR: a table of sets of THREE (x,y and z) coordinates in that order, x and y can be decimals, z is an integer (**and must be present and be the same for all points on the line**, though it is irrelevant to what is produced as the line is drawn on the same z-coordinate as the room that the line is attached to!)
--- * `direction:` a string to associate the line with a valid exit direction, "n", "ne", "e", "se", "s", "sw", "w", "nw", "up", "down", "in" or "out" or a special exit (before Mudlet 3.17 this was case-sensitive and cardinal directions had to be uppercase).
--- * `style:` a string, one of: "solid line", "dot line", "dash line", "dash dot line" or "dash dot dot line" exactly.
--- * `color:` a table of three integers between 0 and 255 as the custom line color as the red, green and blue components in that order.
--- * `arrow:` a boolean which if true will set the custom line to have an arrow on the end of the last segment.
--- 
--- Note:  Available since Mudlet 3.0.
--- 
--- ## Examples
--- ```lua
--- -- create a line from roomid 1 to roomid 2
--- addCustomLine(1, 2, "N", "dot line", {0, 255, 255}, true)
--- 
--- addCustomLine(1, {{4.5, 5.5, 3}, {4.5, 9.5, 3}, {6.0, 9.5, 3}}, "climb Rope", "dash dot dot line", {128, 128, 0}, false)
--- ```
--- 
--- A bigger example that'll create a new area and the room in it:
--- 
--- ```lua
--- local areaid = addAreaName("my first area")
--- local newroomid = createRoomID()
--- addRoom(newroomid)
--- setRoomArea(newroomid, "my first area")
--- setRoomCoordinates(newroomid, 0, 0, 0)
--- 
--- addCustomLine(newroomid, {{4.5, 5.5, 3}, {4.5, 9.5, 3}, {6.0, 9.5, 3}}, "climb Rope", "dash dot dot line", {128, 128, 0}, false)
--- 
--- centerview(newroomid)
--- ```
--- 
--- Note: At the time of writing there is no Lua command to remove a custom exit line and, for Normal exits in the X-Y plane, revert to the standard straight line between the start room and the end room (or colored arrow for out of area exits) however this can be done from the GUI interface to the 2D mapper.
function addCustomLine(roomID, id_to, direction, style, color, arrow)
end

--- 
--- Adds a new entry to an existing mapper right-click entry. You can add one with addMapMenu. If there is no display name, it will default to the unique name (which otherwise isn't shown and is just used to differentiate this entry from others). `event name` is the Mudlet event that will be called when this is clicked on, and `arguments` will be passed to the handler function.
--- See also:
--- see: addMapMenu()
--- see: removeMapEvent()
--- see: getMapEvents()
--- ## Example
--- ```lua
--- addMapEvent("room a", "onFavorite") -- will make a label "room a" on the map menu's right click that calls onFavorite
--- 
--- addMapEvent("room b", "onFavorite", "Favorites", "Special Room!", 12345, "arg1", "arg2", "argn") 
--- ```
--- The last line will make a label "Special Room!" under the "Favorites" menu that on clicking will send all the arguments.
function addMapEvent(uniquename, event_name, parent, display_name, arguments)
end

--- 
--- Adds a new submenu to the right-click menu that opens when you right-click on the mapper. You can then add more submenus to it, or add entries with [[#addMapEvent|addMapEvent()]].
--- See also:
--- see: addMapEvent()
--- see: removeMapEvent()
--- see: getMapEvents()
--- ## Example
--- ```lua
--- -- This will create a menu named: Favorites.
--- addMapMenu("Favorites")
--- 
--- -- This will create a submenu with the unique id 'Favorites123' under 'Favorites' with the display name of 'More Favorites'.
--- addMapMenu("Favorites1234343", "Favorites", "More Favorites") 
--- ```
function addMapMenu(uniquename, parent, display_name)
end

--- 
--- Creates a new room with the given ID, returns true if the room was successfully created. 
--- 
--- Note:  If you're not using incremental room IDs but room IDs stitched together from other factors or in-game hashes for room IDs - and your room IDs are starting off at 250+million numbers, you need to look into incrementally creating Mudlets room IDs with [[#createRoomID|createRoomID()]] and associating your room IDs with Mudlets via [[#setRoomIDbyHash|setRoomIDbyHash()]] and [[#getRoomIDbyHash|getRoomIDbyHash()]]. The reason being is that Mudlet's A* pathfinding implementation from boost cannot deal with extremely large room IDs because the resulting matrices it creates for pathfinding are enormously huge.
--- See also:
--- see: createRoomID()
--- ## Example
--- ```lua
--- local newroomid = createRoomID()
--- addRoom(newroomid)
--- ```
function addRoom(roomID)
end

--- 
--- Creates a one-way from one room to another, that will use the given command for going through them.
--- See also:
--- see: clearSpecialExits()
--- see: removeSpecialExit()
--- ## Example
--- ```lua
--- -- add a one-way special exit going from room 1 to room 2 using the 'pull rope' command
--- addSpecialExit(1, 2, "pull rope")
--- ```
--- 
--- Example in an alias:
--- ```lua
--- -- sample alias pattern: ^spe (\d+) (.*?)$
--- -- currentroom is your current room ID in this example
--- addSpecialExit(currentroom,tonumber(matches[2]), matches[3])
--- echo("\n SPECIAL EXIT ADDED TO ROOMID:"..matches[2]..", Command:"..matches[3])
--- centerview(currentroom)
--- ```
function addSpecialExit(roomIDFrom, roomIDTo, moveCommand)
end

--- 
--- Centers the map view onto the given room ID. The map must be open to see this take effect. This function can also be used to see the map of an area if you know the number of a room there and the area and room are mapped.
--- 
--- See also:
--- see: getPlayerRoom()
--- see: updateMap()
function centerview(roomID)
end

--- 
--- ##  Parameter
--- * areaID - ID number for area to clear.
--- 
--- Clears all user data from a given area. Note that this will not touch the room user data.
--- See also:
--- see: setAreaUserData()
--- see: getAllAreaUserData()
--- see: clearAreaUserDataItem()
--- see: clearRoomUserData()
--- ## Example
--- ```lua
--- display(clearAreaUserData(34))
--- -- I did have data in that area, so it returns:
--- true
--- 
--- display(clearAreaUserData(34))
--- -- There is no data NOW, so it returns:
--- false
--- ```
--- 
--- Note:  Available since Mudlet 3.0.
function clearAreaUserData(areaID)
end

--- 
--- Removes the specific key and value from the user data from a given area.
--- See also:
--- see: setAreaUserData()
--- see: clearAreaUserData()
--- see: clearRoomUserDataItem()
--- Note:  Available since Mudlet 3.0.
--- 
--- ## Example
--- ```lua
--- display(getAllAreaUserData(34))
--- {
---   description = [[<area description here>]],
---   ruler = "Queen Morgase Trakand"
--- }
--- 
--- display(clearAreaUserDataItem(34,"ruler"))
--- true
--- 
--- display(getAllAreaUserData(34))
--- {
---   description = [[<area description here>]],
--- }
--- 
--- display(clearAreaUserDataItem(34,"ruler"))
--- false
--- ```
function clearAreaUserDataItem(areaID, key)
end

--- 
--- Clears all user data stored for the map itself. Note that this will not touch the area or room user data.
--- 
--- See also:
--- see: setMapUserData()
--- see: clearRoomUserData()
--- see: clearAreaUserData()
--- Note:  Available since Mudlet 3.0.
--- 
--- ## Example
--- ```lua
--- display(clearMapUserData())
--- -- I did have user data stored for the map, so it returns:
--- true
--- 
--- display(clearMapUserData())
--- -- There is no data NOW, so it returns:
--- false
--- ```
function clearMapUserData()
end

--- 
--- Removes the specific key and value from the user data from the map user data.
--- See also:
--- see: setMapUserData()
--- see: clearMapUserData()
--- see: clearAreaRoomUserData()
--- ## Example
--- ```lua
--- display(getAllMapUserData())
--- {
---   description = [[<map description here>]],
---   last_modified = "1483228799"
--- }
--- 
--- display(clearMapUserDataItem("last_modified"))
--- true
--- 
--- display(getAllMapUserData())
--- {
---   description = [[<map description here>]],
--- }
--- 
--- display(clearMapUserDataItem("last_modified"))
--- false
--- ```
--- 
--- Note:  Available since Mudlet 3.0.
function clearUserDataItem(mapID, key)
end

--- 
--- Clears all user data from a given room.
--- See also:
--- see: setRoomUserData()
--- see: clearRoomUserDataItem()
--- Note:  Returns a boolean true if any data was removed from the specified room and false if there was nothing to erase since Mudlet 3.0.
--- 
--- ## Example
--- ```lua
--- display(clearRoomUserData(3441))
--- -- I did have data in that room, so it returns:
--- true
--- 
--- display(clearRoomUserData(3441))
--- -- There is no data NOW, so it returns:
--- false
--- ```
function clearRoomUserData(roomID)
end

--- 
--- Removes the specific key and value from the user data from a given room.
--- Returns a boolean true if data was found against the give key in the user data for the given room and it is removed, will return false if exact key not present in the data. Returns nil if the room for the roomID not found.
--- See also:
--- see: setRoomUserData()
--- see: clearRoomUserData()
--- see: clearAreaUserDataItem()
--- ## Example
--- ```lua
--- display(getAllRoomUserData(3441))
--- {
---   description = [[
--- From this ledge you can see out across a large cavern to the southwest. The
--- east side of the cavern is full of stalactites and stalagmites and other
--- weird rock formations. The west side has a path through it and an exit to the
--- south. The sound of falling water pervades the cavern seeming to come from
--- every side. There is a small tunnel to your east and a stalactite within arms
--- reach to the south. It appears to have grown till it connects with the
--- stalagmite below it. Something smells... Yuck you are standing in bat guano!]],
---   doorname_up = "trapdoor"
--- }
--- 
--- display(clearRoomUserDataItem(3441,"doorname_up"))
--- true
--- 
--- display(getAllRoomUserData(3441))
--- {
---   description = [[
--- From this ledge you can see out across a large cavern to the southwest. The
--- east side of the cavern is full of stalactites and stalagmites and other
--- weird rock formations. The west side has a path through it and an exit to the
--- south. The sound of falling water pervades the cavern seeming to come from
--- every side. There is a small tunnel to your east and a stalactite within arms
--- reach to the south. It appears to have grown till it connects with the
--- stalagmite below it. Something smells... Yuck you are standing in bat guano!]],
--- }
--- 
--- display(clearRoomUserDataItem(3441,"doorname_up"))
--- false
--- ```
--- 
--- Note:  Available since Mudlet 3.0+
function clearRoomUserDataItem(roomID, key)
end

--- 
--- Removes all special exits from a room.
--- See also:
--- see: addSpecialExit()
--- see: removeSpecialExit()
--- ## Example
--- ```lua
--- clearSpecialExits(1337)
--- 
--- if #getSpecialExits(1337) == 0 then -- clearSpecialExits will never fail on a valid room ID, this is an example
---   echo("All special exits successfully cleared from 1337.\n")
--- end
--- ```
function clearSpecialExits(roomID)
end

--- closes (hides) the map window (similar to clicking on the map icon)
--- 
--- Note:  available in Mudlet 4.7+
--- See also:
--- see: openMapWidget()
--- see: moveMapWidget()
--- see: resizeMapWidget()
function closeMapWidget()
end

--- 
--- Connects existing rooms with matching exit stubs. If you only give it a roomID and a direction, it'll work out which room should be linked to it that has an appropriate opposite exit stub and is located in the right direction. You can also just specify from and to room IDs, and it'll smartly use the right direction to link in. Lastly, you can specify all three arguments - fromID, toID and the direction (in that order) if you'd like to be explicit, or use [[#setExit|setExit()]] for the same effect.
--- 
--- ## Parameters
--- * `fromID:`
---  Room ID to set the exit stub in.
--- * `direction:`
---  You can either specify the direction to link the room in, and/or a specific room ID (see below). Direction can be specified as a number, short direction name ("nw") or long direction name ("northwest").
--- * `toID:`
---  The room ID to link this room to. If you don't specify it, the mapper will work out which room should be logically linked.
--- 
--- See also:
--- see: setExitStub()
--- see: getExitStubs()
--- ## Example
--- ```lua
--- -- try and connect all stubs that are in a room
--- local stubs = getExitStubs(roomID)
---   if stubs then
---     for i,v in pairs(stubs) do
---     connectExitStub(roomID, v)
---   end
--- end
--- ```
function connectExitStub(fromID, direction)_or_connectExitStub(fromID, toID, direction)
end

--- 
--- Creates a text label on the map at given coordinates, with the given background and foreground colors. It can go above or below the rooms, scale with zoom or stay a static size. It returns a label ID that you can use later for deleting it.
--- 
--- The coordinates 0,0 are in the middle of the map, and are in sync with the room coordinates - so using the x,y values of [[#getRoomCoordinates|getRoomCoordinates()]] will place the label near that room.
--- 
--- See also:
--- see: getMapLabel()
--- see: getMapLabels()
--- ## Parameters
--- * `areaID:`
---  Area ID where to put the label.
--- * `text:`
---  The text to put into the label. To get a multiline text label add a '\n' between the lines.
--- * `posx, posy, posz:`
---  Position of the label in room coordinates.
--- * `fgRed, fgGreen fgBlue:`
---  Foreground color or text color of the label.
--- * `bgRed, bgGreen bgBlue:`
---  Background color of the label.
--- * `zoom:`
---  Zoom factor of the label if noScaling is false. Higher zoom will give higher resolution of the text and smaller size of the label. Default is 30.0.
--- * `fontSize:`
---  Size of the font of the text. Default is 50.
--- * `showOnTop:`
---  If true the label will be drawn on top of the rooms and if it is false the label will be drawn as a background.
--- * `noScaling:`
---  If true the label will have the same size when you zoom in and out in the mapper. If it is false the label will scale when you zoom the mapper. 
--- 
--- See also:
--- see: deleteMapLabel()
--- ## Example
--- ```lua
--- -- the first 50 is some area id, the next three 0,0,0 are coordinates - middle of the area
--- -- 255,0,0 would be the foreground in RGB, 23,0,0 would be the background RGB
--- -- zoom is only relevant when when you're using a label of a static size, so we use 0
--- -- and we use a font size of 20 for our label, which is a small medium compared to the map
--- local labelid = createMapLabel( 50, "my map label", 0,0,0, 255,0,0, 23,0,0, 0,20)
--- 
--- -- to create a multi line text label we add '\n' between lines
--- -- the position is placed somewhat to the northeast of the center of the map
--- -- this label will be scaled as you zoom the map.
--- local labelid = createMapLabel( 50, "1. Row One\n2. Row 2", .5,5.5,0, 255,0,0, 23,0,0, 30,50, true,false)
--- 
--- ```
function createMapLabel(areaID, text, posx, posy, posz, fgRed, fgGreen, fgBlue, bgRed, bgGreen, bgBlue, zoom, fontSize, showOnTop, noScaling)
end

--- 
--- Creates an image label on the map at the given coordinates, with the given dimensions and zoom. You might find the default room and image size correlation to be too big - try reducing the width and height of the image then, while also zooming in the same amount.
--- 
--- The coordinates 0,0 are in the middle of the map, and are in sync with the room coordinates - so using the x,y values of [[#getRoomCoordinates|getRoomCoordinates()]] will place the label near that room.
--- See also:
--- see: deleteMapLabel()
--- ## Example:
--- ```lua
--- -- 138 is our pretend area ID
--- -- next, inside [[]]'s, is the exact location of our image
--- -- 0,0,0 are the x,y,z coordinates - so this will place it in the middle of the map
--- -- 482 is the width of the image - we divide it by 100 to scale it down, and then we'll zoom it by 100 - making the image take up about 4 rooms in width then
--- -- 555 is the original height of the image
--- -- 100 is how much we zoom it by, 1 would be no zoom
--- -- and lastly, false to make it go below our rooms
--- createMapImageLabel(138, [[/home/vadi/Pictures/You only see what shown.png]], 0,0,0, 482/100, 555/100, 100, false)
--- ```
function createMapImageLabel(areaID, filePath, posx, posy, posz, width, height, zoom, showOnTop)
end

--- 
--- Creates a miniconsole window for the mapper to render in, the with the given dimensions. You can only create one mapper at a time, and it is not currently possible to have a label on or under the mapper - otherwise, clicks won't register.
--- 
--- Note: 
--- userwindow argument only available in 4.6.1+
--- 
--- ## Example
--- ```lua
--- createMapper(0,0,300,300) -- creates a 300x300 mapper in the top-left corner of Mudlet
--- setBorderLeft(305) -- adds a border so text doesn't underlap the mapper display
--- ```
--- 
--- ```lua
--- -- another example:
--- local main = Geyser.Container:new({x=0,y=0,width="100%",height="100%",name="mapper container"})
---  
--- local mapper = Geyser.Mapper:new({
---   name = "mapper",
---   x = "70%", y = 0, -- edit here if you want to move it
---   width = "30%", height = "50%"
--- }, main)
--- ```
--- 
--- {{Note}} If this command is `not` used then clicking on the Main Toolbar's **Map** button will create a dock-able widget (that can be floated free to anywhere on the Desktop, it can be resized and does not have to even reside on the same monitor should there be multiple screens in your system). Further clicks on the **Map** button will toggle between showing and hiding the map whether it was created using the `createMapper` function or as a dock-able widget.
function createMapper(name_of_userwindow, x, y, width, height)
end

--- 
--- Returns the lowest possible room ID you can use for creating a new room. If there are gaps in room IDs your map uses it, this function will go through the gaps first before creating higher IDs. 
--- 
--- ## Parameters
--- * `minimumStartingRoomId` (optional):
---  If provided, specifies a roomID to start searching for an empty one at, instead of 1. Useful if you'd like to ensure certain areas have specific room number ranges, for example. If you you're working with a huge map, provide the last used room ID to this function for an available roomID to be found a lot quicker.
--- 
--- Note:  `minimumStartingRoomId` is available since Mudlet 3.0.
--- 
--- See also:
--- see: addRoom()
function createRoomID(minimumStartingRoomId)
end

--- 
--- Deletes the given area and all rooms in it. Returns `true` on success or `nil` + `error message` otherwise.
--- See also:
--- see: addAreaName()
--- ## Parameters
--- * `areaID:`
---  Area ID to delete.
--- * `areaName:`
---  Area name to delete (available since Mudlet 3.0).
--- 
--- 
--- ## Example
--- ```lua
--- -- delete by areaID
--- deleteArea(23)
--- -- or since Mudlet 3.0, by area name
--- deleteArea("Big city")
--- ```
function deleteArea(areaID_or_areaName)
end

--- 
--- Deletes a map label from  a specfic area.
--- See also:
--- see: createMapLabel()
--- ## Example
--- ```lua
--- deleteMapLabel(50, 1)
--- ```
function deleteMapLabel(areaID, labelID)
end

--- 
--- Deletes an individual room, and unlinks all exits leading to and from it.
--- 
--- ## Example
--- ```lua
--- deleteRoom(335)
--- ```
function deleteRoom(roomID)
end

--- 
--- Exports the area as an image into your profile's directory.
--- 
--- ## Example
--- ```lua
--- -- save the area with ID 1 as a map
--- exportAreaImage(1)
--- ```
--- 
--- Note:  This command is currently inoperable in current 3.0+ versions of Mudlet.
function exportAreaImage(areaID)
end

--- 
--- Returns all the user data items stored in the given area ID; will return an empty table if there is no data stored or nil if there is no such area with that ID.
--- 
--- See also:
--- see: clearAreaUserData()
--- see: clearAreaUserDataItem()
--- see: searchAreaUserData()
--- see: setAreaUserData()
--- ## Example
--- ```lua
--- display(getAllAreaUserData(34))
--- --might result in:--
--- {
---   country = "Andor",
---   ruler = "Queen Morgase Trakand"
--- }
--- ```
--- 
--- Note:  Available in Mudlet 3.0.
function getAllAreaUserData(areaID)
end

--- 
--- Returns all the user data items stored at the map level; will return an empty table if there is no data stored.
--- 
--- See also:
--- see: getMapUserData()
--- ## Example
--- ```lua
--- display(getAllMapUserData())
--- --might result in:--
--- {
---   description = [[This map is about so and so game]],
---   author = "Bob",
---   ["last updated"] = "December 5, 2020"
--- }
--- ```
--- 
--- Note:  Available in Mudlet 3.0+
function getAllMapUserData()
end

--- 
--- Returns an indexed list of normal and special exits leading into this room. In case of two-way exits, this'll report exactly the same rooms as [[#getRoomExits|getRoomExits()]], but this function has the ability to pick up one-way exits coming into the room as well.
--- 
--- Note:  Available since Mudlet 3.0.
--- 
--- ## Example
--- ```lua
--- -- print the list of rooms that have exits leading into room 512
--- for _, roomid in ipairs(getAllRoomEntrances(512)) do 
---   print(roomid)
--- end
--- ```
--- 
--- See also:
--- see: getRoomExits()
function getAllRoomEntrances(roomID)
end

--- 
--- Returns all the user data items stored in the given room ID; will return an empty table if there is no data stored or nil if there is no such room with that ID. `Can be useful if the user was not the one who put the data in the map in the first place!`
--- 
--- See also:
--- see: getRoomUserDataKeys()
--- ## Example
--- ```lua
--- display(getAllRoomUserData(3441))
--- --might result in:--
--- {
---   description = [[
--- From this ledge you can see out across a large cavern to the southwest. The
--- east side of the cavern is full of stalactites and stalagmites and other
--- weird rock formations. The west side has a path through it and an exit to the
--- south. The sound of falling water pervades the cavern seeming to come from
--- every side. There is a small tunnel to your east and a stalactite within arms
--- reach to the south. It appears to have grown till it connects with the
--- stalagmite below it. Something smells... Yuck you are standing in bat guano!]],
---   doorname_up = "trapdoor"
--- }
--- ```
--- 
--- Note:  Available in Mudlet 3.0.
function getAllRoomUserData(roomID)
end

--- 
---  Returns a table (indexed or key-value) of the rooms in the given area that have exits leading out to other areas - that is, border rooms.
--- 
--- ## Parameters
--- * `areaID:`
---  Area ID to list the exits for.
--- * `showExits:`
---  Boolean argument, if true then the exits that lead out to another area will be listed for each room.
--- 
--- See also:
--- see: setExit()
--- see: getRoomExits()
--- ## Example
--- ```lua
--- -- list all border rooms for area 44:
--- getAreaExits(44)
--- 
--- -- returns:
--- --[[
--- {
---   7091,
---   10659,
---   11112,
---   11122,
---   11133,
---   11400,
---   12483,
---   24012
--- }
--- ]]
--- 
--- -- list all border rooms for area 44, and the exits within them that go out to other areas:
--- getAreaExits(44, true)
--- --[[
--- {
---   [12483] = {
---     north = 27278
---   },
---   [11122] = {
---     ["enter grate"] = 14551
---   },
---   [11112] = {
---     ["enter grate"] = 14829
---   },
---   [24012] = {
---     north = 22413
---   },
---   [11400] = {
---     south = 10577
---   },
---   [11133] = {
---     ["enter grate"] = 15610
---   },
---   [7091] = {
---     down = 4411
---   },
---   [10659] = {
---     ["enter grate"] = 15510
---   }
--- }
--- ]]
--- ```
function getAreaExits(areaID, showExits)
end

--- 
--- Returns an indexed table with all rooms IDs for a given area ID (room IDs are values), or `nil` if no such area exists. 
--- 
--- ## Example
--- ```lua
--- -- using the sample findAreaID() function defined in the getAreaTable() example, 
--- -- we'll define a function that echo's us a nice list of all rooms in an area with their ID
--- function echoRoomList(areaname)
---   local id, msg = findAreaID(areaname)
---   if id then
---     local roomlist, endresult = getAreaRooms(id), {}
---   
---     -- obtain a room list for each of the room IDs we got
---     for _, id in pairs(roomlist) do
---       endresult[id] = getRoomName(id)
---     end
---   
---     -- now display something half-decent looking
---     cecho(string.format(
---       "List of all rooms in %s (%d):\n", msg, table.size(endresult)))
--- 
---     for roomid, roomname in pairs(endresult) do
---       cecho(string.format(
---         "%6s: %s\n", roomid, roomname))
---     end
---   elseif not id and msg then
---     echo("ID not found; " .. msg)
---   else
---     echo("No areas matched the query.")
---   end
--- end
--- ```
function getAreaRooms(area_id)
end

--- 
--- Returns a key(area name)-value(area id) table with all known areas and their IDs. Some older versions of Mudlet return an area with an empty name and an ID of 0 included in it, you should ignore that.
--- 
--- See also:
--- see: getAreaTableSwap()
--- ## Example
--- ```lua
--- -- example function that returns the area ID for a given area
--- 
--- function findAreaID(areaname)
---   local list = getAreaTable()
--- 
---   -- iterate over the list of areas, matching them with substring match. 
---   -- if we get match a single area, then return it's ID, otherwise return
---   -- 'false' and a message that there are than one are matches
---   local returnid, fullareaname
---   for area, id in pairs(list) do
---     if area:find(areaname, 1, true) then
---       if returnid then return false, "more than one area matches" end
---       returnid = id; fullareaname = area
---     end
---   end
---   
---   return returnid, fullareaname
--- end
--- 
--- -- sample use:
--- local id, msg = findAreaID("blahblah")
--- if id then
---   echo("Found a matching ID: " .. id)
--- elseif not id and msg then
---   echo("ID not found: " .. msg)
--- else
---   echo("No areas matched the query.")
--- end
--- ```
function getAreaTable()
end

--- 
--- Returns a key(area id)-value(area name) table with all known areas and their IDs. Unlike getAreaTable which won't show you all areas with the same name by different IDs, this function will. Some older versions of Mudlet return an area with an empty name and an ID of 0 included in it, you should ignore that.
function getAreaTableSwap()
end

--- 
--- Returns a specific data item stored against the given key for the given area ID number.  This is very like the corresponding Room User Data command but intended for per area rather than for per room data (for storage of data relating to the whole map see the corresponding Map User Data commands.) 
--- 
--- Returns the user data value (string) stored at a given room with a given key (string), or a Lua `nil` and an error message if the key is not present in the Area User Data for the given Area ID. Use [[#setAreaUserData|setAreaUserData()]] function for storing the user data.
--- 
--- ## Example
--- ```lua
--- display(getAreaUserData(34, "country"))
--- -- might produce --
--- "Andor"
--- ```
--- 
--- Note:  
--- 
--- See also:
--- see: clearAreaUserData()
--- see: clearAreaUserDataItem()
--- see: getAllAreaUserData()
--- see: searchAreaUserData()
--- see: setAreaUserData()
function getAreaUserData(areaID, key)
end

--- 
--- Returns a table with customized environments, where the key is the environment ID and the value is a indexed table of rgb values.
--- See also:
--- see: setCustomEnvColor()
--- ## Example
--- ```lua
--- {
---   envid1 = {r,g,b},
---   envid2 = {r,g,b}
--- }
--- ```
function getCustomEnvColorTable()
end

--- See also:
--- see: addCustomLine()
--- see: removeCustomLine()
--- Returns a table including all the details of the custom exit lines, if any, for the room with the id given.
--- 
--- ## Parameters
--- * `roomID:`
---  Room ID to return the custom line details of.
--- 
--- Note:  
--- Available since Mudlet 3.0.
--- 
--- ## Example
--- ```lua
--- display getCustomLines(1)
--- {
---   ["climb Rope"] = {
---     attributes = {
---       color = {
---         b = 0,
---         g = 128,
---         r = 128
---       },
---       style = "dash dot dot line",
---       arrow = false
---     },
---     points = {
---       {
---         y = 9.5,
---         x = 4.5
---       },
---       {
---         y = 9.5,
---         x = 6
---       },
---       [0] = {
---         y = 5.5,
---         x = 4.5
---       }
---     }
---   },
---   N = {
---     attributes = {
---       color = {
---         b = 255,
---         g = 255,
---         r = 0
---       },
---       style = "dot line",
---       arrow = true
---     },
---     points = {
---       [0] = {
---         y = 27,
---         x = -3
---       }
---     }
---   }
--- }
--- ```
function getCustomLines(roomID)
end

--- 
--- Returns a key-value table with the cardinal direction as the key and the door value as a number. If there are no doors in a room, it returns an empty table.
--- 
--- ## Parameters
--- * `roomID:`
---  Room ID to check for doors in.
--- 
--- See also:
--- see: setDoor()
--- ## Example
--- ```lua
--- -- an example that displays possible doors in room 2334
--- local doors = getDoors(2334)
--- 
--- if not next(doors) then cecho("\nThere aren't any doors in room 2334.") return end
--- 
--- local door_status = {"open", "closed", "locked"}
--- 
--- for direction, door in pairs(doors) do
---   cecho("\nThere's a door leading in "..direction.." that is "..door_status[door]..".")
--- end
--- ```
function getDoors(roomID)
end

--- 
--- Returns an indexed table (starting at 0) of the direction #'s that have an exit stub marked in them. You can use this information to connect earlier-made exit stubs between rooms when mapping.
--- 
--- See also:
--- see: setExitStub()
--- see: connectExitStub()
--- see: getExitStubs1()
--- ## Example
--- ```lua
--- -- show the exit stubs in room 6 as numbers
--- local stubs = getExitStubs(6)
--- for i = 0, #stubs do print(stubs[i]) end
--- ```
--- 
--- Note:  Previously would throw a lua error on non-existent room - now returns nil plus error message (as does other run-time errors) - previously would return just a nil on NO exit stubs but now returns a notification error message as well, to aide disambiguation of the nil value.
function getExitStubs(roomid)
end

--- 
--- Returns an indexed table (starting at 1) of the direction #'s that have an exit stub marked in them. You can use this information to connect earlier-made exit stubs between rooms when mapping. As this function starts indexing from 1 as it is default in Lua, you can use ipairs() to iterate over the results.
--- 
--- ##  See also: [[#getExitStubs|getExitStubs()]]
--- 
--- ## Example
--- ```lua
--- -- show the exit stubs in room 6 as numbers
--- for k,v in ipairs(getExitStubs1(6)) do print(k,v) end
--- ```
function getExitStubs1(roomid)
end

--- 
--- Returns a key-value table of the exit weights that a room has, with the direction or special exit as a key and the value as the exit weight. If a weight for a direction wasn't yet set, it won't be listed.
--- 
--- ## Parameters
--- * `roomid:`
---  Room ID to view the exit weights in.
--- 
--- See also:
--- see: setExitWeight()
function getExitWeights(roomid)
end

--- 
--- Use this to see, if a specific area has grid/wilderness view mode set. This way, you can also calculate from a script, how many grid areas a map has got in total.
--- 
--- Note:  
--- Available since Mudlet 3.11
--- 
--- ## Parameters
--- * `areaID:`
---  Area ID (number) to view the grid mode of.
--- 
--- See also:
--- see: setGridMode()
--- ## Example
--- ```lua
--- getGridMode(55)
--- -- will return: false
--- setGridMode(55, true) -- set area with ID 55 to be in grid mode
--- getGridMode(55)
--- -- will return: true
--- ```
function getGridMode(areaID)
end

--- 
---  Returns a list of map events currently registered. Each event is a dictionary with the keys `uniquename`, `parent`, `event name`, `display name`, and `arguments`, which correspond to the arguments of `addMapEvent()`.
--- See also:
--- see: addMapMenu()
--- see: removeMapEvent()
--- see: addMapEvent()
--- ## Example
--- ```lua
--- addMapEvent("room a", "onFavorite") -- will make a label "room a" on the map menu's right click that calls onFavorite
--- 
--- addMapEvent("room b", "onFavorite", "Favorites", "Special Room!", 12345, "arg1", "arg2", "argn")
--- 
--- local mapEvents = getMapEvents()
--- for _, event in ipairs(mapEvents) do
---   echo(string.format("MapEvent '%s' is bound to event '%s' with these args: '%s'", event["uniquename"], event["event name"], table.concat(event["arguments"], ",")))
--- end
--- ```
--- 
--- Note:  Available in Mudlet 3.3
function getMapEvents()
end

--- 
--- Returns a key-value table describing that particular label in an area. Keys it contains are the `X`, `Y`, `Z` coordinates, `Height` and `Width`, and the `Text` it contains. If the label is an image label, then `Text` will be set to the `no text` string.
--- 
--- See also:
--- see: createMapLabel()
--- see: getMapLabels()
--- ## Example
--- ```lua
--- lua getMapLabels(1658987)
--- table {
---   1: 'no text'
---   0: 'test'
--- }
--- 
--- lua getMapLabel(1658987, 0)
--- table {
---   'Y': -2
---   'X': -8
---   'Z': 11
---   'Height': 3.9669418334961
---   'Text': 'test'
---   'Width': 8.6776866912842
--- }
--- 
--- lua getMapLabel(1658987, 1)
--- table {
---   'Y': 8
---   'X': -15
---   'Z': 11
---   'Height': 7.2520666122437
---   'Text': 'no text'
---   'Width': 11.21900844574
--- }
--- 
--- 
--- ```
function getMapLabel(areaID, labelID)
end

--- 
--- Returns an indexed table (that starts indexing from 0) of all of the labels in the area, plus their label text. You can use the label id to [[#deleteMapLabel|deleteMapLabel()]] it.
--- If there are no labels in the area at all, will instead return the area number.
--- 
--- See also:
--- see: createMapLabel()
--- see: getMapLabel()
--- ## Example
--- ```lua
--- display(getMapLabels(43))
--- table {
---   0: `
---   1: 'Waterways'
--- }
--- 
--- deleteMapLabel(43, 0)
--- display(getMapLabels(43))
--- table {
---   1: 'Waterways'
--- }
--- ```
function getMapLabels(areaID)
end

--- 
--- Returns a table containing details of the current mouse selection in the 2D mapper.
--- 
--- Reports on one or more rooms being selected (i.e. they are highlighted in orange).
--- 
--- The contents of the table will vary depending on what is currently selected. If the selection is of map rooms then there will be keys of `center` and `rooms`: the former will indicates the center room (the one with the yellow cross-hairs) if there is more than one room selected or the only room if there is only one selected (there will not be cross-hairs in that case); the latter will contain a list of the one or more rooms.
--- 
--- ##  Example - several rooms selected
--- ```lua
--- display(getMapSelection())
--- {
---   center = 5013,
---   rooms = {
---     5011,
---     5012,
---     5013,
---     5014,
---     5018,
---     5019,
---     5020
---   }
--- }
--- ```
--- ##  Example - one room selected
--- ```lua
--- display(getMapSelection())
--- {
---   center = 5013,
---   rooms = {
---     5013
---   }
--- }
--- ```
--- ##  Example - no or something other than a room selected
--- ```lua
--- display(getMapSelection())
--- {
--- }
--- ```
--- 
--- {{Note}} Available in Mudlet 3.17+
function getMapSelection()
end

--- 
--- ## Parameters
--- * `key:`
---  string used as a key to select the data stored in the map as a whole.
--- 
--- Returns the user data item (string); will return a nil+error message if there is no data with such a key in the map data.
--- 
--- See also:
--- see: getAllMapUserData()
--- see: setMapUserData()
--- ## Example
--- ```lua
--- display(getMapUserData("last updated"))
--- --might result in:--
--- "December 5, 2020"
--- ```
--- 
--- Note:  Available in Mudlet 3.0
function getMapUserData(_key_)
end

--- 
--- Returns a boolean true/false if a path between two room IDs is possible. If it is, the global `speedWalkDir` table is set to all of the directions that have to be taken to get there, and the global `speedWalkPath` table is set to all of the roomIDs you'll encounter on the way, and as of 3.0, `speedWalkWeight` will return all of the room weights. Additionally returns the total cost (all weights added up) of the path after the boolean argument in 3.0.
--- 
--- 
--- See also:
--- 
--- ## Example
--- ```lua
--- -- check if we can go to room 155 from room 34 - if yes, go to it
--- if getPath(34,155) then
---   gotoRoom(155)
--- else
---   echo("\nCan't go there!")
--- end
--- ```
function getPath(roomID_from, roomID_to)
end

--- 
--- Returns the current player location as set by [[#centerview|centerview()]].
--- 
--- See also:
--- see: centerview()
--- ## Example
--- ```lua
--- display("We're currently in " .. getRoomName(getPlayerRoom()))
--- ```
--- 
--- Note:  Available in Mudlet 3.14
function getPlayerRoom()
end

--- 
--- Returns the area ID of a given room ID. To get the area name, you can check the area ID against the data given by [[#getAreaTable | getAreaTable()]] function, or use the [[#getRoomAreaName |getRoomAreaName()]] function.
--- 
--- Note:  If the room ID does not exist, this function will raise an error.
--- 
--- ## Example
--- ```lua
--- display("Area ID of room #100 is: "..getRoomArea(100))
--- 
--- display("Area name for room #100 is: "..getRoomAreaName(getRoomArea(100)))
--- ```
function getRoomArea(roomID)
end

--- 
--- Returns the area name for a given area id; or the area id for a given area name.
--- 
--- Note:  Despite the name, this function will not return the area name for a given `room` id (or room name) directly. However, renaming or revising it would break existing scripts.
--- 
--- ## Example
--- ```lua
--- echo(string.format("room id #455 is in %s.", getRoomAreaName(getRoomArea(455))))
--- ```
function getRoomAreaName(areaID_or_areaName)
end

--- 
--- Returns the single ASCII character that forms the `symbol` for the given room id.
--- 
---  **Since Mudlet version 3.8 :** this facility has been extended:
---  Returns the string (UTF-8) that forms the `symbol` for the given room id; this may have been set with either [[#setRoomChar|setRoomChar()]] or with the `symbol` (was `letter` in prior versions) context menu item for rooms in the 2D Map.
function getRoomChar(roomID)
end

--- 
--- Returns the room coordinates of the given room ID.
--- 
--- ## Example
--- ```lua
--- local x,y,z = getRoomCoordinates(roomID)
--- echo("Room Coordinates for "..roomID..":")
--- echo("\n     X:"..x)
--- echo("\n     Y:"..y)
--- echo("\n     Z:"..z)
--- ```
--- 
--- ```lua
--- -- A quick function that will find all rooms on the same z-position in an area; this is useful if, say, you want to know what all the same rooms on the same "level" of an area is.
--- function sortByZ(areaID, zval)
---   local area = getAreaRooms(areaID)
---   local t = {}
---   for _, id in ipairs(area) do
---     local _, _, z = getRoomCoordinates(id)
---     if z == zval then
---       table.insert(t, id)
---     end
---   end
---   return t
--- end
--- ```
function getRoomCoordinates(roomID)
end

--- 
--- Returns the environment ID of a room. The mapper does not store environment names, so you'd need to keep track of which ID is what name yourself.
--- 
--- ## Example
--- ```lua
--- funtion checkID(id)
---   echo(strinf.format("The env ID of room #%d is %d.\n", id, getRoomEnv(id)))
--- end
--- ```
function getRoomEnv(roomID)
end

--- Returns the currently known non-special exits for a room in an key-index form: `exit = exitroomid`.
--- 
--- See also:
--- see: getSpecialExits()
--- ## Example
--- ```lua
--- table {
---   'northwest': 80
---   'east': 78
--- }
--- ```
--- 
--- Here's a practical example that queries the rooms around you and searched for one of the water environments (the number would depend on how it was mapped):
--- 
--- ```lua
--- local exits = getRoomExits(mycurrentroomid)
--- for direction,num in pairs(exits) do
---   local env_num = getRoomEnv(num)
---   if env_num == 22 or env_num == 20 or env_num == 30 then
---     print("There's water to the "..direction.."!")
---   end
--- end```
function getRoomExits(roomID)
end

--- 
--- Returns a room hash that is associated with a given room ID in the mapper. This is primarily for MUDs that make use of hashes instead of room IDs. It may be used to share map data while not sharing map itself. `nil` is returned if no room is not found.
--- 
--- See also:
--- see: getRoomIDbyHash()
--- 
--- ## Example
--- ```lua
---     for id,name in pairs(getRooms()) do
---         local h = getRoomUserData(id, "herbs")
---         if h ~= "" then
---             echo(string.format([[["%s"] = "%s",]], getRoomHashByID(id), h))
---             echo("\n")
---         end
---     end
--- ```
function getRoomHashByID(roomID)
end

--- 
--- Returns a room ID that is associated with a given hash in the mapper. This is primarily for MUDs that make use of hashes instead of room IDs (like [http://avalon.mud.de/index.php?enter=1 Avalon.de] MUD). `-1` is returned if no room ID matches the hash.
--- 
--- See also:
--- see: getRoomHashByID()
--- ## Example
--- ```lua
--- -- example taken from http://forums.mudlet.org/viewtopic.php?f=13&t=2177
--- local id = getRoomIDbyHash("5dfe55b0c8d769e865fd85ba63127fbc")
--- if id == -1 then 
---   id = createRoomID()
---   setRoomIDbyHash(id, "5dfe55b0c8d769e865fd85ba63127fbc")
---   addRoom(id)
---   setRoomCoordinates(id, 0, 0, -1)
--- end
--- ```
function getRoomIDbyHash(hash)
end

--- 
--- Returns the room name for a given room id.
--- 
--- ## Example
--- ```lua
--- echo(string.format("The name of the room id #455 is %s.", getRoomName(455))
--- ```
function getRoomName(roomID)
end

--- 
--- Returns the list of **all** rooms in the map in the whole map in roomid - room name format.
--- 
--- ## Example
--- ```lua
--- -- simple, raw viewer for rooms in the world
--- display(getRooms())
--- 
--- -- iterate over all rooms in code
--- for id,name in pairs(getRooms()) do
---   print(id, name)
--- end
--- ```
function getRooms()
end

--- 
--- Returns an indexed table of all rooms at the given coordinates in the given area, or an empty one if there are none. This function can be useful for checking if a room exists at certain coordinates, or whenever you have rooms overlapping.
--- 
--- Note:  The returned table starts indexing from **0** and not the usual lua index of **1**, which means that using **#** to count the size of the returned table will produce erroneous results - use [[Manual:Table_Functions#table.size|table.size()]] instead.
--- 
--- ## Example
--- ```lua
--- -- sample alias to determine a room nearby, given a relative direction from the current room
--- 
--- local otherroom
--- if matches[2] == "" then
---   local w = matches[3]
---   local ox, oy, oz, x,y,z = getRoomCoordinates(mmp.currentroom)
---   local has = table.contains
---   if has({"west", "left", "w", "l"}, w) then
---     x = (x or ox) - 1; y = (y or oy); z = (z or oz)
---   elseif has({"east", "right", "e", "r"}, w) then
---     x = (x or ox) + 1; y = (y or oy); z = (z or oz)
---   elseif has({"north", "top", "n", "t"}, w) then
---     x = (x or ox); y = (y or oy) + 1; z = (z or oz)
---   elseif has({"south", "bottom", "s", "b"}, w) then
---     x = (x or ox); y = (y or oy) - 1; z = (z or oz)
---   elseif has({"northwest", "topleft", "nw", "tl"}, w) then
---     x = (x or ox) - 1; y = (y or oy) + 1; z = (z or oz)
---   elseif has({"northeast", "topright", "ne", "tr"}, w) then
---     x = (x or ox) + 1; y = (y or oy) + 1; z = (z or oz)
---   elseif has({"southeast", "bottomright", "se", "br"}, w) then
---     x = (x or ox) + 1; y = (y or oy) - 1; z = (z or oz)
---   elseif has({"southwest", "bottomleft", "sw", "bl"}, w) then
---     x = (x or ox) - 1; y = (y or oy) - 1; z = (z or oz)
---   elseif has({"up", "u"}, w) then
---     x = (x or ox); y = (y or oy); z = (z or oz) + 1
---   elseif has({"down", "d"}, w) then
---     x = (x or ox); y = (y or oy); z = (z or oz) - 1
---   end
--- 
---   local carea = getRoomArea(mmp.currentroom)
---   if not carea then mmp.echo("Don't know what area are we in.") return end
--- 
---   otherroom = select(2, next(getRoomsByPosition(carea,x,y,z)))
--- 
---   if not otherroom then
---     mmp.echo("There isn't a room to the "..w.." that I see - try with an exact room id.") return
---   else
---     mmp.echo("The room "..w.." of us has an ID of "..otherroom)
---   end
--- ```
function getRoomsByPosition(areaID, x,y,z)
end

--- 
--- Returns the user data value (string) stored at a given room with a given key (string), or "" if none is stored. Use [[#setRoomUserData|setRoomUserData()]] function for setting the user data.
--- 
--- ## Example
--- ```lua
--- display(getRoomUserData(341, "visitcount"))
--- ```
--- 
--- ;getRoomUserData(roomID, key, enableFullErrorReporting)
--- 
--- Returns the user data value (string) stored at a given room with a given key (string), or, if the boolean value `enableFullErrorReporting` is true, `nil` and an error message if the key is not present or the room does not exist; if `enableFullErrorReporting` is false an empty string is returned but then it is not possible to tell if that particular value is actually stored or not against the given key.
--- 
--- See also:
--- see: clearRoomUserData()
--- see: clearRoomUserDataItem()
--- see: getAllRoomUserData()
--- see: getRoomUserDataKeys()
--- see: searchRoomUserData()
--- see: setRoomUserData()
--- ## Example
--- <!-- I would like this block to be indented to match the Example header but the mark-up system seems to be broken and only includes the first line
--- if the start of the code line begins: ":<lua>..."-->
--- ```lua
--- ocal vNum = 341
--- result, errMsg = getRoomUserData(vNum, "visitcount", true)
--- if result ~= nil then
---     display(result)
--- else
---     echo("\nNo visitcount data for room: "..vNum.."; reason: "..errMsg.."\n")
--- end```
function getRoomUserData(roomID, key)
end

--- 
--- Returns all the keys for user data items stored in the given room ID; will return an empty table if there is no data stored or nil if there is no such room with that ID. `Can be useful if the user was not the one who put the data in the map in the first place!`
--- 
--- See also:
--- see: clearRoomUserData()
--- see: clearRoomUserDataItem()
--- see: getAllRoomUserData()
--- see: getRoomUserData()
--- see: searchRoomUserData()
--- see: setRoomUserData()
--- ## Example
--- ```lua
--- display(getRoomUserDataKeys(3441))
--- --might result in:--
--- {
---   "description",
---   "doorname_up",
--- }
--- ```
--- 
--- Note:  Available since Mudlet 3.0.
function getRoomUserDataKeys(roomID)
end

--- 
--- Returns the weight of a room. By default, all new rooms have a weight of 1.
--- See also:
--- see: setRoomWeight()
--- ## Example
--- ```lua
--- display("Original weight of room 541: "..getRoomWeight(541))
--- setRoomWeight(541, 3)
--- display("New weight of room 541: "..getRoomWeight(541))
--- ```
function getRoomWeight(roomID)
end

--- 
--- Returns a roomid - command table of all special exits in the room. If there are no special exits in the room, the table returned will be empty.
--- 
--- See also:
--- see: getRoomExits()
--- ## Example
--- ```lua
--- getSpecialExits(1337)
--- 
--- -- results in:
--- --[[
--- table {
---   12106: 'faiglom nexus'
--- }
--- ]]
--- ```
function getSpecialExits(roomID)
end

--- 
--- Very similar to [[#getSpecialExits|getSpecialExits()]] function, but returns the rooms in the command - roomid style.
function getSpecialExitsSwap(roomID)
end

--- Speedwalks you to the given room from your current room if it is able and knows the way. You must turn the map on for this to work, else it will return "(mapper): Don't know how to get there from here :(".
--- 
--- In case this isn't working, and you are coding your own mapping script, [[Mapping_script#Making_your_own_mapping_script|see here]] how to implement additional functionality necessary.
function gotoRoom(roomID)
end

--- 
--- Returns `true` or `false` depending on whenever a given exit leading out from a room is locked. Direction can be specified as a number, short direction name ("nw") or long direction name ("northwest").
--- 
--- ##  Example
--- ```lua
--- -- check if the east exit of room 1201 is locked
--- display(hasExitLock(1201, 4))
--- display(hasExitLock(1201, "e"))
--- display(hasExitLock(1201, "east"))
--- ```
--- 
--- See also:
--- see: lockExit()
function hasExitLock(roomID, direction)
end

--- 
--- Returns `true` or `false` depending on whenever a given exit leading out from a room is locked. `moveCommand` is the action to take to get through the gate.
--- 
--- ```lua
--- -- lock a special exit from 17463 to 7814 that uses the 'enter feather' command
--- lockSpecialExit(17463, 7814, 'enter feather', true)
--- 
--- -- see if it is locked: it will say 'true', it is
--- display(hasSpecialExitLock(17463, 7814, 'enter feather'))
--- ```
function hasSpecialExitLock(from_roomID, to_roomID, moveCommand)
end

--- 
--- Highlights a room with the given color, which will override its environment color. If you use two different colors, then there'll be a shading from the center going outwards that changes into the other color. 
--- 
--- ## Parameters
--- * `roomID`
---  ID of the room to be colored.
--- * `color1Red, color1Green, color1Blue`
---  RGB values of the first color.
--- * `color2Red, color2Green, color2Blue`
---  RGB values of the second color.
--- * `highlightRadius` 
---  The radius for the highlight circle - if you don't want rooms beside each other to overlap, use `1` as the radius. 
--- * `color1Alpha` and `color2Alpha` 
---  Transparency values from 0 (completely transparent) to 255 (not transparent at all).
--- 
--- See also:
--- see: unHighlightRoom()
--- Note:  Available since Mudlet 2.0.
--- 
--- ```lua
--- -- color room #351 red to blue
--- local r,g,b = unpack(color_table.red)
--- local br,bg,bb = unpack(color_table.blue)
--- highlightRoom(351, r,g,b,br,bg,bb, 1, 255, 255)
--- ```
function highlightRoom(_roomID, color1Red, color1Green, color1Blue, color2Red, color2Green, color2Blue, highlightRadius, color1Alpha, color2Alpha)
end

--- 
--- Loads the map file from a given location. The map file must be in Mudlet's format - saved with [[#saveMap|saveMap()]] or, as of the Mudlet 3.0 may be a MMP XML map conforming to the structure used by I.R.E. for their download-able maps for their MUDs. 
--- 
--- Returns a boolean for whenever the loading succeeded. Note that the mapper must be open, or this will fail.
--- 
--- ```lua
---   loadMap("/home/user/Desktop/Mudlet Map.dat")
--- ```
function loadMap(file_location)
end

--- 
--- Locks a given exit from a room (which means that unless all exits in the incoming room are locked, it'll still be accessible). Direction can be specified as a number, short direction name ("nw") or long direction name ("northwest").
--- 
--- See also:
--- see: hasExitLock()
--- ## Example
--- ```lua
--- -- lock the east exit of room 1201 so we never path through it
--- lockExit(1201, 4, true)
--- ```
function lockExit(roomID, direction, lockIfTrue)
end

--- 
--- Locks a given room id from future speed walks (thus the mapper will never path through that room).
--- See also:
--- see:  roomLocked()
--- ## Example
--- ```lua
--- lockRoom(1, true) -- locks a room if from being walked through when speedwalking.
--- lockRoom(1, false) -- unlocks the room, adding it back to possible rooms that can be walked through.
--- ```
function lockRoom(roomID, lockIfTrue)
end

--- 
--- Locks a given special exit, leading from one specific room to another that uses a certain command from future speed walks (thus the mapper will never path through that special exit).
--- See also:
--- see:  hasSpecialExitLock()
--- see:  lockExit()
--- see:  lockRoom()
--- ## Example
--- ```lua
--- lockSpecialExit(1,2,'enter gate', true) -- locks the special exit that does 'enter gate' to get from room 1 to room 2
--- lockSpecialExit(1,2,'enter gate', false) -- unlocks the said exit
--- ```
function lockSpecialExit(from_roomID, to_roomID, special_exit_command, lockIfTrue)
end

--- See also:
--- see: setupMapSymbolFont(...)()
--- ## returns
--- * either a table of information about the configuration of the font used for symbols in the (2D) map, the elements are:
--- * `fontName` - a string of the family name of the font specified
--- * `onlyUseThisFont` - a boolean indicating whether glyphs from just the `fontName` font are to be used or if there is not a `glyph` for the required `grapheme` (`character`) then a `glyph` from the most suitable different font will be substituted instead. Should this be `true` and the specified font does not have the required glyph then the replacement character (typically something like `�`) could be used instead. Note that this may not affect the use of Color Emoji glyphs that are automatically used in some OSes but that behavior does vary across the range of operating systems that Mudlet can be run on.
--- * `scalingFactor` - a floating point number between 0.50 and 2.00 which modifies the size of the symbols somewhat though the extremes are likely to be unsatisfactory because some of the particular symbols may be too small (and be less visible at smaller zoom levels) or too large (and be clipped by the edges of the room rectangle or circle).
--- * or `nil` and an error message on failure.
--- 
--- As the symbol font details are stored in the (binary) map file rather than the profile then this function will not work until a map is loaded (or initialized, by activating a map window).
--- 
--- Note:  pending, not yet available.
function mapSymbolFontInfo()
end

--- moves the map window to the given position.
--- See also:
--- see: openMapWidget()
--- see: closeMapWidget()
--- see: resizeMapWidget()
--- ## Parameters
--- * `Xpos:`
---  X position of the map window. Measured in pixels, with 0 being the very left. Passed as an integer number.
--- * `Ypos:`
---  Y position of the map window. Measured in pixels, with 0 being the very top. Passed as an integer number.
--- 
--- Note:  available in Mudlet 4.7+
function moveMapWidget(Xpos, Ypos)
end

--- ## openMapWidget(dockingArea)
--- ## openMapWidget(Xpos, Ypos, width, height)
--- opens a map window with given options.
--- 
--- See also:
--- see: closeMapWidget()
--- see: moveMapWidget()
--- see: resizeMapWidget()
--- ## Parameters
--- Note:  If no parameter is given the map window will be opened with the saved layout or at the right docking position (similar to clicking the icon)
--- * `dockingArea:`
---  If only one parameter is given this parameter will be a string that contains one of the possible docking areas the map window will be created in (f" floating "t" top "b" bottom "r" right and "l" left)
--- Note:  If 4 parameters are given the map window will be created in floating state 
--- * `Xpos:`
---  X position of the map window. Measured in pixels, with 0 being the very left. Passed as an integer number.
--- * `Ypos:`
---  Y position of the map window. Measured in pixels, with 0 being the very left. Passed as an integer number.
--- * `width:`
---  The width map window, in pixels. Passed as an integer number.
--- * `height:`
---  The height map window, in pixels. Passed as an integer number.
--- 
--- Note:  available in Mudlet 4.7+
function openMapWidget()
end

--- 
---  Unassigns the room from its given area. While not assigned, its area ID will be -1.  Note that since Mudlet 3.0 the "default area" which has the id of -1 may be selectable in the area selection widget on the mapper - although there is also an option to conceal this in the settings.
--- 
--- See also:
--- see:  setRoomArea()
--- see:  getRoomArea()
--- ## Example
--- ```lua
--- resetRoomArea(3143)
--- ```
function resetRoomArea(roomID)
end

--- resizes a map window with given width, height.
--- See also:
--- see: openMapWidget()
--- see: closeMapWidget()
--- see: moveMapWidget()
--- ## Parameters
--- * `width:`
---  The width of the map window, in pixels. Passed as an integer number.
--- * `height:`
---  The height of the map window, in pixels. Passed as an integer number.
--- 
--- Note:  available in Mudlet 4.7+
function resizeMapWidget(width, height)
end

--- 
--- Removes the custom exit line that's associated with a specific exit of a room.
--- See also:
--- see: addCustomLine()
--- see: getCustomLines()
--- ## Example
--- ```lua
--- -- remove custom exit line that starts in room 315 going north
--- removeCustomLine(315, "n")
--- ```
function removeCustomLine(roomID, direction)
end

--- 
--- Removes the given menu entry from a mappers right-click menu. You can add custom ones with [[#addMapEvent | addMapEvent()]].
--- See also:
--- see:  addMapEvent()
--- see:  getMapEvents()
--- see:  removeMapMenu()
--- ## Example
--- ```lua
--- addMapEvent("room a", "onFavorite") -- add one to the general menu
--- removeMapEvent("room a") -- removes the said menu
--- ```
function removeMapEvent(event_name)
end

--- 
--- Removes the given submenu from a mappers right-click menu. You can add custom ones with [[#addMapMenu | addMapMenu()]].
--- See also:
--- see:  addMapMenu()
--- see:  getMapMenus()
--- see:  removeMapEvent()
--- ## Example
--- ```lua
--- addMapMenu("Test") -- add submenu to the general menu
--- removeMapMenu("Test") -- removes that same menu again
--- ```
function removeMapMenu(menu_name)
end

--- 
--- Removes the special exit which is accessed by `command` from the room with the given `roomID`.
--- See also:
--- see: addSpecialExit()
--- see: clearSpecialExits()
--- ## Example
--- ```lua
--- addSpecialExit(1, 2, "pull rope") -- add a special exit from room 1 to room 2
--- removeSpecialExit(1, "pull rope") -- removes the exit again
--- ```
function removeSpecialExit(roomID, command)
end

--- 
--- Returns a boolean true/false depending if the room with that ID exists (is created) or not.
function roomExists(roomID)
end

--- 
--- Returns true or false whenever a given room is locked.
--- See also:
--- see: lockRoom()
--- ## Example
--- ```lua
--- echo(string.format("Is room #4545 locked? %s.", roomLocked(4545) and "Yep" or "Nope"))
--- ```
function roomLocked(roomID)
end

--- 
--- Saves the map to a given location, and returns true on success. The location folder needs to be already created for save to work. You can also save the map in the Mapper settings tab.
--- 
--- ## Parameters
--- * `location`
---  (optional) save the map to the given location if provided, or the default one otherwise.
--- * `version`
---  (optional) map version as a number to use when saving (Mudlet 3.17+)
--- 
--- See also:
--- see: loadMap()
--- ## Example
--- ```lua
--- local savedok = saveMap(getMudletHomeDir().."/my fancy map.dat")
--- if not savedok then
---   echo("Couldn't save :(\n")
--- else
---   echo("Saved fine!\n")
--- end
--- 
--- -- save with a particular map version
--- saveMap(20)
--- ```
function saveMap(location, version)
end

--- Searches Areas' User Data in a manner exactly the same as [[#searchRoomUserData|searchRoomUserData()]] does in all Rooms' User Data, refer to that command for the specific details except to replace references to rooms and room ID numbers there with areas and areas ID numbers.
function searchAreaUserData()
end

--- 
--- Searches for rooms that match (by case-insensitive, substring match) the given room name. It returns a key-value table in form of `roomid = roomname`.
--- If you pass it a number instead of a string, it'll act like [[#getRoomName|getRoomName()]] and return you the room name.
--- 
--- ## Example
--- ```lua
--- display(searchRoom("master"))
--- {
---   [17463] = 'in the branches of the Master Ravenwood'
---   [3652] = 'master bedroom'
---   [10361] = 'Hall of Cultural Masterpieces'
---   [6324] = 'Exhibit of the Techniques of the Master Artisans'
---   [5340] = 'office of the Guildmaster'
---   [2004] = 'office of the guildmaster'
---   [14457] = 'the Master Gear'
---   [1337] = 'before the Master Ravenwood Tree'
--- }
--- ```
--- 
--- If no rooms are found, then an empty table is returned.
--- 
--- Note:  Additional parameters are available since Mudlet 3.0:
--- 
--- ## searchRoom (room name, [case-sensitive [, exact-match]])
--- 
--- ## Additional Parameters
--- * `case-sensitive:`
---  If true forces a case-sensitive search to be done on with the supplied room name argument, if false case is not considered.
--- * `exact-match:`
---  If true forces an exact match rather than a sub-string match, with a case sensitivity as set by previous option.
--- 
--- ## Example
--- ```lua
--- -- shows all rooms containing these words in any case: --
--- display(searchRoom("North road",false,false))
--- {
---   [3114] = "Bend in North road",
---   [3115] = "North road",
---   [3116] = "North Road",
---   [3117] = "North road",
---   [3146] = "Bend in the North Road",
---   [3088] = "The North Road South of Taren Ferry",
---   [6229] = "Grassy Field By North Road"
--- }
--- 
--- -- shows all rooms containing these words in ONLY this case: --
--- display(searchRoom("North road",true,false))
--- {
---   [3114] = "Bend in North road",
---   [3115] = "North road",
---   [3117] = "North road",
--- }
--- 
--- -- shows all rooms containing ONLY these words in any case: --
--- lua searchRoom("North road",false,true)
--- {
---   [3115] = "North road",
---   [3116] = "North Road",
---   [3117] = "North road"
--- }
--- 
--- -- shows all rooms containing ONLY these words in ONLY this case: --
--- lua searchRoom("North road",true,true)
--- {
---   [3115] = "North road",
---   [3117] = "North road"
--- }
--- ```
--- 
--- Note:  Technically, with both options (case-sensitive and exact-match) set to true, one could just return a list of numbers as we know precisely what the string will be, but it was kept the same for maximum flexibility in user scripts.
function searchRoom(room_name_/_room_number)
end

--- A command with three variants that search though all the rooms in sequence (so **not as fast as a user built/maintained `index` system**) and find/reports on the room user data stored:
--- 
--- See also:
--- see: clearRoomUserData()
--- see: clearRoomUserDataItem()
--- see: getAllRoomUserData()
--- see: getRoomUserData()
--- see: getRoomUserDataKeys()
--- see: setRoomUserData()
--- 
--- Reports a (sorted) list of all room ids with user data with the given "value" for the given (case sensitive) "key".  Due to the lack of previous enforcement it is possible (though not recommended) to have a room user data item with an empty string "" as a key, this is handled correctly.
--- 
--- ## searchRoomUserData(key)
--- 
--- Reports a (sorted) list of the unique values from all rooms with user data with the given (case sensitive) "key".  Due to the lack of previous enforcement it is possible (though not recommended) to have a room user data item with an empty string "" as a key, this is handled correctly.
--- 
--- ## searchRoomUserData()
--- 
--- Reports a (sorted) list of the unique keys from all rooms with user data with any (case sensitive) "key", available since Mudlet 3.0.
--- 
--- ## Examples
--- ```lua
--- -- if I had stored the details of "named doors" as part of the room user data --
--- display(searchRoomUserData("doorname_up"))
--- 
--- --[[ could result in a list:
--- {
---   "Eastgate",
---   "Northgate",
---   "boulderdoor",
---   "chamberdoor",
---   "dirt",
---   "floorboards",
---   "floortrap",
---   "grate",
---   "irongrate",
---   "rockwall",
---   "tomb",
---   "trap",
---   "trapdoor"
--- }]]
--- 
--- -- then taking one of these keys --
--- display(searchRoomUserData("doorname_up","trapdoor"))
--- 
--- --[[ might result in a list:
--- {
---   3441,
---   6113,
---   6115,
---   8890
--- }
--- ]]```
--- 
--- Note:  Available since Mudlet 3.0.
function searchRoomUserData(key, value)
end

--- 
--- Names, or renames an existing area to the new name. The area must be created first with [[#addAreaName|addAreaName()]] and it must be unique.
--- 
--- Note:  areaName is available since Mudlet 3.0.
--- 
--- See also:
--- see: deleteArea()
--- see: addAreaName()
--- ## Example
--- ```lua
--- setAreaName(2, "My city")
--- 
--- -- available since Mudlet 3.0
--- setAreaName("My old city name", "My new city name")
--- ```
function setAreaName(areaID_or_areaName, newName)
end

--- 
--- Stores information about an area under a given key. Similar to Lua's key-value tables, except only strings may be used here. One advantage of using userdata is that it's stored within the map file itself - so sharing the map with someone else will pass on the user data. Returns a lua `true` value on success. You can have as many keys as you'd like, however a blank key will not be accepted and will produce a lua `nil` and an error message instead.
--- 
--- Returns true if successfully set.
--- See also:
--- see: clearAreaUserData()
--- see: clearAreaUserDataItem()
--- see: getAllAreaUserData()
--- see: getAreaUserData()
--- see: searchAreaUserData()
--- Note:  Release (not Development) version 3.0 software made this function available, but was unable to load the prerequisite map formats 17 and 18 that can store map-level data - that had been fixed in Release 3.0.1 .
--- 
--- ## Example
--- ```lua
--- -- can use it to store extra area details...
--- setAreaUserData(34, "country", "Andor.")
--- 
--- -- or a sound file to play in the background (with a script that checks a room's area when entered)...
--- setAreaUserData(34, "backgroundSound", "/home/user/mudlet-data/soundFiles/birdsong.mp4")
--- 
--- -- can even store tables in it, using the built-in yajl.to_string function
--- setAreaUserData(101, "some table", yajl.to_string({ruler = "Queen Morgase Trakand", clan = "Lion Warden"}))
--- display("The ruler's name is: "..yajl.to_value(getRoomUserData(34, "some table")).ruler)
--- ```
function setAreaUserData(areaID, key(as_a_string), value(as_a_string))
end

--- 
--- Creates, or overrides an already created custom color definition for a given environment ID. Note that this will not work on the default environment colors - those are adjustable by the user in the preferences. You can however create your own environment and use a custom color definition for it.
--- See also:
--- see: getCustomEnvColorTable()
--- see: setRoomEnv()
--- Note:  Numbers 1-16 and 257-272 are reserved by Mudlet. 257-272 are the default colors the user can adjust in mapper settings, so feel free to use them if you'd like - but don't overwrite them with this function.
--- 
--- ## Example
--- ```lua
--- setRoomEnv(571, 200) -- change the room's environment ID to something arbitrary, like 200
--- local r,g,b = unpack(color_table.blue)
--- setCustomEnvColor(200, r,g,b, 255) -- set the color of environmentID 200 to blue
--- ```
function setCustomEnvColor(environmentID, r,g,b,a)
end

--- 
--- Creates or deletes a door in a room. Doors are purely visual - they don't affect pathfinding. You can use the information to change to adjust your speedwalking path based on the door information in a room, though.
--- 
--- Doors CAN be set on stub exits `- so that map makers can note if there is an obvious door to somewhere even if they do not (yet) know where it goes, perhaps because they do not yet have the key to open it!`
--- 
--- Returns `true` if the change could be made, `false` if the input was valid but ineffective (door status was not changed), and `nil` with a message string on invalid input (value type errors).
--- 
--- See also:
--- see: getDoors()
--- ## Parameters
--- * `roomID:`
---  Room ID to to create the door in.
--- * `exitCommand:`
---  The cardinal direction for the door is in - it can be one of the following: **n**, **e**, **s**, **w**, **ne**, **se**, **sw**, **ne**. `{Plans are afoot to add support for doors on the other normal exits: **up**, **down**, **in** and **out**, and also on special exits - though more work will be needed for them to be shown in the mapper.}`  It is important to ONLY use these direction codes as others e.g. "UP" will be accepted - because a special exit could have ANY name/lua script - but it will not be associated with the particular normal exit - recent map auditing code about to go into the code base will REMOVE door and other room exit items for which the appropriate exit (or stub) itself is not present, so in this case, in the absence of a special exit called "UP" that example door will not persist and not show on the normal "up" exit when that is possible later on.
--- 
--- * `doorStatus:`
---  The door status as a number - **0** means no (or remove) door, **1** means open door (will draw a green square on exit), **2** means closed door (yellow square) and **3** means locked door (red square). 
--- 
--- 
--- ## Example
--- ```lua
--- -- make a door on the east exit of room 4234 that is currently open
--- setDoor(4234, 'e', 1)
--- 
--- -- remove a door from room 923 that points north
--- setDoor(923, 'n', 0)
--- ```
function setDoor(roomID, exitCommand, doorStatus)
end

--- 
--- Creates a one-way exit from one room to another using a standard direction - which can be either one of `n, ne, nw, e, w, s, se, sw, u, d, in, out`, the long version of a direction, or a number which represents a direction. If there was an exit stub in that direction already, then it will be automatically deleted for you.
--- 
--- Returns `false` if the exit creation didn't work.
--- 
--- ## Example
--- ```lua
--- -- alias pattern: ^exit (\d+) (\d+) (\w+)$
--- -- so exit 1 2 5 will make an exit from room 1 to room 2 via north
--- 
--- if setExit(tonumber(matches[2]), tonumber(matches[3]), matches[4]) then
---   echo("\nExit set to room:"..matches[3].." from "..matches[2]..", direction:"..string.upper(matches[3]))
--- else
---   echo("Failed to set the exit.\n")
--- end
--- ```
--- 
--- This function can also delete exits from a room if you use it like so:
--- 
--- ```lua
--- etExit(from roomID, -1, direction)```
--- 
--- - which will delete an outgoing exit in the specified direction from a room.
function setExit(from_roomID, to_roomID, direction)
end

--- 
--- Creates or removes an exit stub from a room in a given directions. You can use exit stubs later on to connect rooms that you're sure of are together. Exit stubs are also shown visually on the map, so the mapper can easily tell which rooms need finishing.
--- 
--- ## Parameters
--- * `roomID:`
---  The room to place an exit stub in, as a number.
--- * `direction:`
---  The direction the exit stub should lead in - as ashort direction name ("nw"), long direction name ("northwest") or a number.
--- * `set/unset:`
---  A boolean to create or delete the exit stub.
--- 
--- See also:
--- see: getExitStubs()
--- see: connectExitStub()
--- ## Example
--- Create an exit stub to the south from room 8:
--- ```lua
--- setExitStub(8, "s", true)
--- ```
--- 
--- How to delete all exit stubs in a room:
--- ```lua
--- for i,v in pairs(getExitStubs(roomID)) do
---   setExitStub(roomID, v,false)
--- end
--- ```
function setExitStub(roomID, direction, set/unset)
end

--- 
--- Gives an exit a weight, which makes it less likely to be chosen for pathfinding. All exits have a weight of 0 by default, which you can increase. Exit weights are set one-way on an exit - if you'd like the weight to be applied both ways, set it from the reverse room and direction as well.
--- 
--- ## Parameters
--- * `roomID:`
---  Room ID to to set the weight in.
--- * `exitCommand:`
---  The direction for the exit is in - it can be one of the following: **n**, **ne**, **e**, **se**, **s**, **sw**, **w**, **nw**, **up**, **down**, **in**, **out**, or, if it's a special exit, the special exit command - note that the strings for normal exits are case-sensitive and must currently be exactly as given here.
--- * `weight:`
---  Exit weight - by default, all exits have a weight of 0 meaning that the weight of the `destination room` is use when the route finding code is considering whether to use that exit; setting a value for an exit can increase or decrease the chance of that exit/destination room being used for a route by the route-finding code.  For example, if the destination room has very high weight compared to it's neighbors but the exit has a low value then that exit and thus the room is more likely to be used than if the exit was not weighted.
--- 
--- See also:
--- see: getExitWeights()
function setExitWeight(roomID, exitCommand, weight)
end

--- 
--- Enables grid/wilderness view mode for an area - this will cause the rooms to lose their visible exit connections, like you'd see on compressed ASCII maps, both in 2D and 3D view mode; for the 2D map the custom exit lines will also not be shown if this mode is enabled. 
--- Returns true if the area exists, otherwise false.
--- 
--- See also:
--- see: getGridMode()
--- ## Example
--- ```lua
--- setGridMode(55, true) -- set area with ID 55 to be in grid mode
--- ```
function setGridMode(areaID, true/false)
end

--- 
--- Stores information about the map under a given key. Similar to Lua's key-value tables, except only strings may be used here. One advantage of using userdata is that it's stored within the map file itself - so sharing the map with someone else will pass on the user data. You can have as many keys as you'd like. 
--- 
--- Returns true if successfully set.
--- See also:
--- see: clearMapUserData()
--- see: clearMapUserDataItem()
--- see: getAllMapUserData()
--- see: getMapUserData()
--- ## Example
--- ```lua
--- -- store general meta information about the map...
--- setMapUserData("game_name", "Achaea Mudlet map")
--- 
--- -- or who the author was
--- setMapUserData("author", "Bob")
--- 
--- -- can even store tables in it, using the built-in yajl.to_string function
--- setMapUserData("some table", yajl.to_string({game = "mud.com", port = 23}))
--- display("Available game info in the map: ")
--- display(yajl.to_value(getMapUserData("some table")))
--- ```
function setMapUserData(key(as_a_string), value(as_a_string))
end

--- 
--- Zooms the map in to a given zoom level. **1** is the closest you can get, and anything higher than that zooms the map out. Call [[#centerview|centerview()]] after you set the zoom to refresh the map.
--- 
--- ## Example
--- ```lua
--- setMapZoom(10) -- zoom to a somewhat acceptable level, a bit big but easily visible connections
--- ```
function setMapZoom(zoom)
end

--- 
--- Assigns the given room to a new or different area. If the area is displayed in the mapper this will have the room be visually moved into the area as well.
--- 
--- See also:
--- see: resetRoomArea()
function setRoomArea(roomID, newAreaID_or_newAreaName)
end

--- 
--- Originally designed for an area in grid mode, takes a single ASCII character and draws it on the rectangular background of the room in the 2D map. In versions prior to Mudlet 3.8, the symbol can be cleared by using "_" as the character. In Mudlet version 3.8 and higher, the symbol may be cleared with either a space <code>" "</code> or an empty string <code>""</code>.
--- 
--- ## MUD-related symbols for your map
--- * [https://github.com/toddfast/game-icons-net-font toddfast's font] - 3000+ scalable vector RPG icons from [https://game-icons.net game-icons.net], as well as a script to download the latest icons and generate a new font.
--- * Pixel Kitchen's [https://www.fontspace.com/donjonikons-font-f30607 Donjonikon Font] - 10x10 fantasy and RPG-related icons.
--- 
--- ## Example
--- ```lua
--- setRoomChar(431, "#")
--- 
--- setRoomChar(123, "$")
--- 
--- -- emoji's work fine too, and if you'd like it colour, set the font to Nojo Emoji in settings
--- setRoomChar(666, "👿")
--- ```
--- 
--- **Since Mudlet version 3.8 :** this facility has been extended:
--- * This function will now take a short string of any printable characters as a room `symbol`, and they will be shrunk to fit them all in horizontally but if they become too small that `symbol` may not be shown if the zoom is such that the room symbol is too small to be legible.
--- * As "_" is now a valid character an existing symbol may be erased with either a space " " or an empty string "" although neither may be effective in some previous versions of Mudlet.
--- * Should the rooms be set to be drawn as circles this is now accommodated and the symbol will be resized to fit the reduce drawing area this will cause.
--- * The range of characters that are available are now dependent on the **fonts** present in the system and a setting on the "Mapper" tab in the preferences that control whether a specific font is to be used for all symbols (which is best if a font is included as part of a MUD server package, but has the issue that it may not be displayable if the user does not have that font or chooses a different one) or any font in the user's system may be used (which is the default, but may not display the `glyph` {the particular representation of a `grapheme` in a particular font} that the original map creator expected).  Should it not be possible to display the wanted symbol in the map because one or more of the required glyphs are not available in either the specified or any font depending on the setting then the `replacement character` (Unicode `code-point` U+FFFD '�') will be shown instead.  To allow such missing symbols to be handled the "Mapper" tab on the preferences dialogue has an option to display:
--- * an indicator to show whether the symbol can be made just from the selected font (green tick), from the fonts available in the system (yellow warning triangle) or not at all (red cross)
--- * all the symbols used on the map and how they will be displayed both only using the selected font and all fonts
--- * the sequence of code-points used to create the symbol which will be useful when used in conjunction with character selection utilities such as `charmap.exe` on Windows and `gucharmap` on unix-like system
--- * a count of the rooms using the particular symbol
--- * a list, limited in entries of the first rooms using that symbol
--- * The font that is chosen to be used as the primary (or only) one for the room symbols is stored in the Mudlet map data so that setting will be included if a binary map is shared to other Mudlet users or profiles on the same system.
--- 
--- See also:
--- see: getRoomChar()
function setRoomChar(roomID, character)
end

--- 
--- Sets the given room ID to be at the following coordinates visually on the map, where `z` is the up/down level. 
--- 
--- Note:  0,0,0 is the center of the map.
--- 
--- ## Examples
--- ```lua
--- -- alias pattern: ^set rc (-?\d+) (-?\d+) (-?\d+)$
--- -- this sets the current room to the supplied coordinates
--- setRoomCoordinates(roomID,x,y,z)
--- centerview(roomID)
--- ```
--- 
--- You can make them relative as well:
--- 
--- ```lua
--- -- alias pattern: ^src (\w+)$
--- 
--- local x,y,z = getRoomCoordinates(previousRoomID)
--- local dir = matches[2]
--- 
--- if dir == "n" then
---   y = y+1
--- elseif dir == "ne" then
---   y = y+1
---   x = x+1
--- elseif dir == "e" then
---   x = x+1
--- elseif dir == "se" then
---   y = y-1
---   x = x+1
--- elseif dir == "s" then
---   y = y-1
--- elseif dir == "sw" then
---   y = y-1
---   x = x-1
--- elseif dir == "w" then
---   x = x-1
--- elseif dir == "nw" then
---   y = y+1
---   x = x-1
--- elseif dir == "u" or dir == "up" then
---   z = z+1
--- elseif dir == "down" then
---   z = z-1
--- end
--- setRoomCoordinates(roomID,x,y,z)
--- centerview(roomID)
--- ```
function setRoomCoordinates(roomID, x, y, z)
end

--- 
--- Sets the given room to a new environment ID. You don't have to use any functions to create it - can just set it right away.
--- See also:
--- see: setCustomEnvColor()
--- ## Example
--- ```lua
--- setRoomEnv(551, 34) -- set room with the ID of 551 to the environment ID 34
--- ```
function setRoomEnv(roomID, newEnvID)
end

--- 
--- Sets the hash to be associated with the given roomID. See also [[#getRoomIDbyHash|getRoomIDbyHash()]].
function setRoomIDbyHash(roomID, hash)
end

--- 
--- Renames an existing room to a new name.
--- 
--- ## Example
--- ```lua
--- setRoomName(534, "That evil room I shouldn't visit again.")
--- lockRoom(534, true) -- and lock it just to be safe
--- ```
function setRoomName(roomID, newName)
end

--- 
--- Stores information about a room under a given key. Similar to Lua's key-value tables, except only strings may be used here. One advantage of using userdata is that it's stored within the map file itself - so sharing the map with someone else will pass on the user data. You can have as many keys as you'd like. 
--- 
--- Returns true if successfully set.
--- See also:
--- see: clearRoomUserData()
--- see: clearRoomUserDataItem()
--- see: getAllRoomUserData()
--- see: getRoomUserData()
--- see: searchRoomUserData()
--- 
--- ## Example
--- ```lua
--- -- can use it to store room descriptions...
--- setRoomUserData(341, "description", "This is a plain-looking room.")
--- 
--- -- or whenever it's outdoors or not...
--- setRoomUserData(341, "ourdoors", "true")
--- 
--- -- how how many times we visited that room
--- local visited = getRoomUserData(341, "visitcount")
--- visited = (tonumber(visited) or 0) + 1
--- setRoomUserData(341, "visitcount", tostring(visited))
--- 
--- -- can even store tables in it, using the built-in yajl.to_string function
--- setRoomUserData(341, "some table", yajl.to_string({name = "bub", age = 23}))
--- display("The denizens name is: "..yajl.to_value(getRoomUserData(341, "some table")).name)
--- ```
function setRoomUserData(roomID, key(as_a_string), value(as_a_string))
end

--- 
--- Sets a weight to the given roomID. By default, all rooms have a weight of 1 - the higher the weight is, the more likely the room is to be avoided for pathfinding. For example, if travelling across water rooms takes more time than land ones - then you'd want to assign a weight to all water rooms, so they'd be avoided if there are possible land pathways.
--- 
--- Note:  The minimum allowed room weight is 1. 
--- 
--- To completely avoid a room, make use of [[#lockRoom|lockRoom()]].
--- 
--- See also:
--- see: getRoomWeight()
--- 
--- ## Example
--- ```lua
--- setRoomWeight(1532, 3) -- avoid using this room if possible, but don't completely ignore it
--- ```
function setRoomWeight(roomID, weight)
end

--- configures the font used for symbols in the (2D) map.
--- See also:
--- see: mapSymbolFontInfo()
--- ## Parameters
--- * `fontName` one of:
--- * - a string that is the family name of the font to use;
--- * - the empty string `""` to reset to the default {which is **"Bitstream Vera Sans Mono"**};
--- * - a Lua `nil` as a placeholder to not change this parameter but still allow a following one to be modified.
--- * `onlyUseThisFont` (optional) one of:
--- * - a Lua boolean `true` to require Mudlet to use graphemes (`character`) **only** from the selected font. Should a requested grapheme not be included in the selected font then the font replacement character (�) might be used instead; note that under some circumstances it is possible that the OS (or Mudlet) provided color Emoji Font may still be used but that cannot be guaranteed across all OS platforms that Mudlet might be run on;
--- * - a Lua boolean `false` to allow Mudlet to get a different `glyph` for a particular `grapheme` from the most suitable other font found in the system should there not be a `glyph` for it in the requested font. This is the default unless previously changed by this function or by the corresponding checkbox in the Profile Preferences dialogue for the profile concerned;
--- * - a Lua `nil` as a placeholder to not change this parameter but still allow the following one to be modified.
--- * `scalingFactor` (optional): a floating point value in the range `0.5` to `2.0` (default `1.0`) that can be used to tweak the rectangular space that each different room symbol is scaled to fit inside; this might be useful should the range of characters used to make the room symbols be consistently under- or over-sized.
--- 
--- ## Returns
--- * `true` on success
--- * `nil` and an error message on failure. As the symbol font details are stored in the (binary) map file rather than the profile then this function will not work until a map is loaded (or initialised, by activating a map window).
--- 
--- Note:  pending, not yet available.
function setupMapSymbolFont(fontName, _onlyUseThisFont, _scalingFactor)
end

--- 
--- A speedwalking function will work on cardinal+ordinal directions (n, ne, e, etc.) as well as u (for up), d (for down), in and out. It can be called to execute all directions directly after each other, without delay, or with a custom delay, depending on how fast your mud allows you to walk. It can also be called with a switch to make the function reverse the whole path and lead you backwards.
--- 
--- Call the function by doing: <code>speedwalk("YourDirectionsString", true/false, delaytime, true/false)</code>
--- 
--- The delaytime parameter will set a delay between each move (set it to 0.5 if you want the script to move every half second, for instance). It is optional: If you don't indicate it, the script will send all direction commands right after each other. (If you want to indicate a delay, you -have- to explicitly indicate true or false for the reverse flag.)
--- 
--- The show parameter will determine if the commands sent by this function are shown or hidden. It is optional: If you don't give a value, the script will show all commands sent. (If you want to use this option, you -have- to explicitly indicate true or false for the reverse flag, as well as either some number for the delay or nil if you do not want a delay.)
--- 
--- The "YourDirectionsString" contains your list of directions and steps (e.g.: "2n, 3w, u, 5ne"). Numbers indicate the number of steps you want it to walk in the direction specified after it. The directions must be separated by anything other than a letter that can appear in a direction itself. (I.e. you can separate with a comma, spaces, the letter x, etc. and any such combinations, but you cannot separate by the letter "e", or write two directions right next to each other with nothing in-between, such as "wn". If you write a number before every direction, you don't need any further separator. E.g. it's perfectly acceptable to write "3w1ne2e".) The function is not case-sensitive.
--- 
--- If your Mud only has cardinal directions (n,e,s,w and possibly u,d) and you wish to be able to write directions right next to each other like "enu2s3wdu", you'll have to change the pattern slightly. Likewise, if your Mud has any other directions than n, ne, e, se, s, sw, w, nw, u, d, in, out, the function must be adapted to that.
--- 
--- ## Example
--- ```lua
--- speedwalk("16d1se1u")
--- -- Will walk 16 times down, once southeast, once up. All in immediate succession.
--- 
--- speedwalk("2ne,3e,2n,e")
--- -- Will walk twice northeast, thrice east, twice north, once east. All in immediate succession.
--- 
--- speedwalk("IN N 3W 2U W", false, 0.5)
--- -- Will walk in, north, thrice west, twice up, west, with half a second delay between every move.
--- 
--- speedwalk("5sw - 3s - 2n - w", true)
--- -- Will walk backwards: east, twice south, thrice, north, five times northeast. All in immediate succession.
--- 
--- speedwalk("3w, 2ne, w, u", true, 1.25)
--- -- Will walk backwards: down, east, twice southwest, thrice east, with 1.25 seconds delay between every move.
--- ```
--- 
--- Note:  The probably most logical usage of this would be to put it in an alias. For example, have the pattern `^/(.+)$` execute: <code>speedwalk(matches[2], false, 0.7)</code>
--- And have `^//(.+)$` execute: <code>speedwalk(matches[2], true, 0.7)</code>
--- Or make aliases like: `^banktohome$` to execute <syntaxhighlight lang="lua" inline>speedwalk("2ne,e,ne,e,3u,in", true, 0.5)```
--- 
--- Note:  The show parameter for this function will be available in Mudlet versions after 3.12.
function speedwalk(dirString, backwards, delay, show)
end

--- 
--- Unhighlights a room if it was previously highlighted and restores the rooms original environment color.
--- See also:
--- see: highlightRoom()
--- Note:  Available since Mudlet 2.0 final release
--- 
--- ## Example
--- ```lua
--- unHighlightRoom(4534)
--- ```
function unHighlightRoom(roomID)
end

--- 
--- Updates the mapper display (redraws it). Use this function if you've edited the map via script and would like the changes to show.
--- 
--- See also:
--- see: centerview()
--- ## Example
--- ```lua
--- -- delete a some room
--- deleteRoom(500)
--- -- now make the map show that it's gone
--- updateMap()
--- ```
function updateMap()
end

