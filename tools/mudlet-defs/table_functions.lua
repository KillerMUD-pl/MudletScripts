--- ##  Returns an iterator similar to pairs(tbl) but sorts the keys before iterating through them. 
--- 
--- ##  Parameters
--- * `tbl:`
---  The table to iterate over
--- * `sortFunction:`
---  The function to use for determining what order to iterate the items in the table. Defaults to alphanumeric sorting by key. Similar to [[Manual:Lua_Functions#table.sort|table.sort]]. See example for more info.
--- 
--- {{Note}} Available in Mudlet 4.10+
--- ##  Example:
--- <syntaxhighlight lang=lua>
--- local tbl = { Tom = 40, Mary = 50, Joe = 23 }
--- 
--- -- This iterates, sorting based on the key (which is the name in this case)
--- for name, thingies in spairs(tbl) do
---   echo(string.format("%s has %d thingies\n", name, thingies))
--- end
--- --[[
--- Joe has 23 thingies
--- Mary has 50 thingies
--- Tom has 40 thingies
--- --]]
--- 
--- -- The function used below sorts based on the value. 
--- for name, thingies in spairs(tbl, function(t,a,b) return t[a] < t[b] end) do --iterate from lowest value to highest
---   echo(string.format("%s has %d thingies\n", name, thingies))
--- end
--- --[[
--- Joe has 23 thingies
--- Tom has 40 thingies
--- Mary has 50 thingies
--- --]]
--- 
--- -- This function can be used to sort a group of Geyser gauges based on their value (what percentage of the gauge is filled)
--- local gaugeSort = function(t,a,b)
---     local avalue = t[a].value or 100 -- treat non-gauges as though they are full gauges. If you know for -sure- the table only has gauges the 'or 100' is not needed.
---     local bvalue = t[b].value or 100
---     return avalue < bvalue
--- end
--- for _,gauge in spairs(tblOfGauges, gaugeSort) do
---   -- do what you want with the gauges. First one will be the least full, then the next least full, until the last which will be the most full. 
---   -- If you replace the < with a > it will go from most full to least full instead.
--- end
--- ```
function spairs(tbl, sortFunction)
end

---  Returns a table that is every key-value pair from tbl for which func(key,value) returns true
--- 
--- ##  Parameters
--- * `tbl:`
---  The table to collect items from
--- * `func:`
---  the function to use for testing if an item should be collected or not
--- 
--- {{Note}} Available in Mudlet 4.8+
--- ##  Example:
--- <syntaxhighlight lang=lua>
--- local vitals = { hp = 3482, maxhp = 5000, mana = 3785, maxmana = 5000 }
--- local pullHpKeys = function(key, value)
---   if string.match(key, "hp") then return true end
--- end
--- local hp_values = table.collect(tbl, pullHpKeys)
--- display(hp_values)
--- ```
--- This prints the following:
---  {
---    hp = 3482,
---    maxhp = 5000
---  }
--- ##  Returns
---  A table containing all the key/value pairs from tbl that cause func(key,value) to return true
function table.collect(tbl, func)
end

---  Returns a table that is the relative complement of the first table with respect to the second table. Returns a complement of key/value pairs.
--- 
--- ##  Parameters
--- * `table1:`
--- * `table2:`
--- 
--- ##  Example:
--- <syntaxhighlight lang=lua>local t1 = {key = 1,1,2,3}
--- local t2 = {key = 2,1,1,1}
--- local comp = table.complement(t1,t2)
--- display(comp)```
--- This prints the following:
---    key = 1,
---    [2] = 2,
---    [3] = 3
--- 
--- ##  Returns
---  A table containing all the key/value pairs from table1 that do not match the key/value pairs from table2.
function table.complement(set1, set2)
end

---  Joins a table into a string. Each item must be something which can be transformed into a string. 
---  Returns the joined string.
--- See also:
--- see: string.split()
--- ##  Parameters
--- * **table:**
---  The table to concatenate into a string. Passed as a table.
--- * **delimiter:**
---  Optional string to use to separate each element in the joined string. Passed as a string.
--- * **startingindex:**
---  Optional parameter to specify which index to begin the joining at. Passed as an integer.
--- * **endingindex:**
---  Optional parameter to specify the last index to join. Passed as an integer.
--- 
--- ## Examples
--- ```lua
--- --This shows a basic concat with none of the optional arguments
--- testTable = {1,2,"hi","blah",}
--- testString = table.concat(testTable)
--- --testString would be equal to "12hiblah"
--- 
--- --This example shows the concat using the optional delimiter
--- testString = table.concat(testTable, ", ")
--- --testString would be equal to "1, 2, hi, blah"
--- 
--- --This example shows the concat using the delimiter and the optional starting index
--- testString = table.concat(testTable, ", ", 2)
--- --testString would be equal to "2, hi, blah"
--- 
--- --And finally, one which uses all of the arguments
--- testString = table.concat(testTable, ", ", 2, 3)
--- --testString would be equal to "2, hi"
--- ```
function table.concat(table, delimiter, startingindex, endingindex)
end

---  Determines if a table contains a value as a key or as a value (recursive as of Mudlet 4.8+).
---  Returns true or false
--- 
--- ##  Parameters
--- * **t:** 
---  The table in which you are checking for the presence of the value.
--- * **value:** 
---  The value you are checking for within the table.
--- 
--- ##  Example:
--- ```lua
--- ocal test_table = {"value1", "value2", "value3", "value4", "value5", "value6", "value7"}
--- if table.contains(test_table, "value1") then 
---    print("Got value 1!")
--- else
---    print("Don't have it. Sorry!")
--- end
--- 
--- -- if the table has just a few values, you can skip making a local, named table:
--- if table.contains({"Anna", "Alanna", "Hanna"}, "Anna") then 
---    print("Have 'Anna' in the list!")
--- else
---    print("Don't have the name. Sorry!")
--- end
--- ```
function table.contains(t, value)
end

---  Returns a complete copy of the table.
--- 
--- ##  Parameters
--- * **table:** 
---  The table which you'd like to get a copy of.
--- 
--- ##  Example:
--- ```lua
--- ocal test_table = { "value1", "value2", "value3", "value4" }
--- 
--- -- by just doing:
--- local newtable = test_table
--- -- you're linking newtable to test_table. Any change in test_table will be reflected in newtable.
--- 
--- -- however, by doing:
--- local newtable = table.deepcopy(test_table)
--- -- the two tables are completely separate now.
--- ```
function table.deepcopy(table)
end

---  Returns a table that is the relative intersection of the first table with respect to the second table. Returns a intersection of key/value pairs.
--- 
--- ##  Parameters
--- * `table1:`
--- * `table2:`
--- 
--- ##  Example:
--- <syntaxhighlight lang=lua>local t1 = {key = 1,1,2,3}
--- local t2 = {key = 1,1,1,1}
--- local intersect = table.intersection(t1,t2)
--- display(intersect)```
--- This prints the following:
---    key = 1,
---    1
--- 
--- ##  Returns
---  A table containing all the key/value pairs from table1 that match the key/value pairs from table2.
function table.intersection(set1, set2)
end

---  Inserts element **value** at position **pos** in **table**, shifting up other elements to open space, if necessary. The default **value** for **pos** is n+1, where n is the length of the table, so that a call table.insert(t,x) inserts x at the end of table t.
--- See also:
--- see: table.remove()
--- ##  Parameters
--- * **table:**
---  The table in which you are inserting the value
--- * **pos:**
---  Optional argument, determining where the value will be inserted. 
--- * **value:**
---  The variable that you are inserting into the table. Can be a regular variable, or even a table or function*.
--- 
--- ## Examples
--- ```lua
--- --it will inserts what inside the variable of matches[2] into at the end of table of 'test_db_name'. 
--- table.insert(test_db_name, matches[2])
--- --it will inserts other thing at the first position of this table.
--- table.insert(test_db_name, 1, "jgcampbell300")
--- 
--- --[=[
--- 
--- This results:
--- 
--- test_db_name = {
---     "jgcampbell300",
---     "SlySven"
--- }
--- ]=]
--- 
--- ```
function table.insert(table, pos, value)
end

--- Returns the index (location) of an item in an indexed table, or **nil** if it's not found.
--- 
--- ##  Parameters
--- * **table:**
---  The table in which you are inserting the value
--- * **value:**
---  The variable that you are searching for in the table.
--- 
--- ## Examples
--- ```lua
--- -- will return 1, because 'hi' is the first item in the list
--- table.index_of({"hi", "bye", "greetings"}, "hi")
--- 
--- -- will return 3, because 'greetings' is third in the list
--- table.index_of({"hi", "bye", "greetings"}, "greetings")
--- 
--- -- you can also use this in combination with table.remove(), which requires the location of the item to delete
--- local words = {"hi", "bye", "greetings"}
--- table.remove(words, table.index_of(words, "greetings"))
--- 
--- -- however that won't work if the word isn't present, table.remove(mytable, nil (from table.index_of)) will give an error
--- -- so if you're unsure, confirm with table.contains first
--- local words = {"hi", "bye", "greetings"}
--- if table.contains(words, "greetings") then
---   table.remove(words, table.index_of(words, "greetings"))
--- end
--- ```
function table.index_of(table, value)
end

---  Check if a table is devoid of any values.
--- 
--- ##  Parameters
--- * **table:**
---  The table you are checking for values.
function table.is_empty(table)
end

---  return a table that is the collection of the keys in use by the table passed in
--- 
--- ##  Parameters
--- * **table:**
---  The table you are collecting keys from.
--- 
--- Note:  Available since Mudlet 4.1.
--- 
--- ## Example
--- ```lua
---    local testTable = {
---      name = "thing",
---      type = "test",
---      malfunction = "major"
---    }
---    local keys = table.keys(testTable)
---    -- key is now a table { "name", "type", "malfunction" } but the order cannot be guaranteed
---    -- as pairs() does not iterate in a guaranteed order. If you want the keys in alphabetical
---    -- run table.sort(keys) and keys == { "malfunction", "name", "type" }
--- ```
function table.keys(table)
end

---  Load a table from an external file into mudlet.
--- See also:
--- see: table.save()
--- Tip: you can load a table from anywhere on your computer, but it's preferable to have them consolidated somewhere connected to Mudlet, such as the [[Manual:Lua_Functions#getMudletHomeDir|current profile]].
--- 
--- ##  Parameters:
--- * **location:**
---  Where you are loading the table from. Can be anywhere on your computer.
--- * **table:**
---  The table that you are loading into - it must exist already.
--- 
---  Example:
--- ```lua
--- -- This will load the table mytable from the lua file mytable present in your Mudlet Home Directory.
--- mytable = mytable or {}
--- if io.exists(getMudletHomeDir().."/mytable.lua") then
---   table.load(getMudletHomeDir().."/mytable.lua", mytable) -- using / is OK on Windows too.
--- end
--- ```
function table.load(location, table)
end

--- Returns a table of key-value pairs from tbl which match one of the supplied patterns when checked via string.match
--- 
--- ##  Parameters
--- * `tbl:`
---  the table you want to check over using string.match
--- * `pattern:`
---  the pattern you want to use to check each key-value pair. You may specify multiple patterns, separated by commas
--- * `check_keys:`
---  boolean argument, set to true if you want to include a key-value pair if the key or value string.matches. If you do not set this, only the value will be checked
--- 
--- {{Note}} Available in Mudlet 4.8+
--- ##  Example
--- ```lua
--- local items = { this = "that", hp = 400, [4] = "toast", something = "else", more = "keypairs" }
--- local matches = tables.matches(items, "%d")
--- -- here matches will be { hp = 400 }
--- local matches = tables.matches(items, "%d", "that", true)
--- -- here matches will be { hp = 400, this = "that", [4] = "toast" }
--- ```
function table.matches(tbl, pattern, pattern2, pattern_n, check_keys)
end

--- Returns the largest positive numerical index of the given table, or zero if the table has no positive numerical indices. (To do its job this function does a linear traversal of the whole table.)
function table.maxn(table)
end

---  returns a table which contains every unique value from tbl for which func(value) returns true. Ignores keys. Table returned is ipairs iterable.
--- 
--- ##  Parameters
--- * `tbl:`
---  the table you want to collect values from
--- * `func(value):`
---  the function to check each value against
--- 
--- {{Note}} available in Mudlet 4.8+
--- 
--- ##  Example
--- ```lua
--- local items = { 
---   this = "that",
---   other = "thing",
---   otter = "potato",
---   honey = "bee"
--- }
--- local beginsWithTH = function(value)
---   if string.match(value, "^th") then return true end
--- end
--- local nmatches = table.n_collect(items, beginsWithTH)
--- -- nmatches will be { "that", "thing" }
--- -- the order will not necessarily be preserved
--- ```
function table.n_collect(tbl, func(value))
end

---  Returns a new table with all elements that pass the test implemented by the provided function. If no elements pass the test, an empty table will be returned.
--- 
--- ##  Parameters
--- * `table:` the table you wish to filter values out of.
--- * `function:` the function to test each element of the array. Return true to keep the element, false otherwise. It accepts three arguments:
--- ** `element:` The current element being processed in the table.
--- ** `index:` (optional) The index of the current element being processed in the table.
--- ** `table:` (optional) The table **n_filter** was called upon.
--- 
--- ##  Examples:
--- Filter out small values:
--- ```lua
--- local function isBigEnough(value) return value >= 10 end
--- local filtered = table.n_filter({12, 5, 8, 130, 44}, isBigEnough)
--- -- filtered: {12, 130, 44}
--- ```
--- Filter out invalid entries:
--- ```lua
--- local invalidEntries = 0
--- local entries = {
---   { id = 15 }, { id = -1 }, { id = 0 }, { id = 3 },
---   { id = 12.2 }, { }, { id = nil }, { id = false },
---   { id = 'not a number' }
--- }
--- 
--- local function isNumber(t) return t and type(t) == 'number' end
--- local function filterByID(item)
---   if isNumber(item.id) and item.id ~= 0 then
---     return true
---   end
---   invalidEntries = invalidEntries + 1
---   return false
--- end
--- 
--- local entriesByID = table.n_filter(entries, filterByID)
--- -- invalidEntries: 5
--- -- entriesByID: { { id = 15 }, { id = -1 }, { id = 3 }, { id = 12.2 } }
--- ```
--- Filter out content based on search criteria:
--- ```lua
--- local fruits = {'apple', 'banana', 'grapes', 'mango', 'orange'}
--- local function filterItems(t, query)
---   return table.n_filter(t, function(item)
---     return item:lower():find(query:lower())
---   end)
--- end
--- filterItems(fruits, 'ap') -- {'apple', 'grapes'}
--- filterItems(fruits, 'an') -- {'banana', 'mango', 'orange'}
--- ```
function table.n_filter(table, function(element, _index, _table))
end

---  Returns a new table with the sub-table elements concatenated into it.
--- 
--- ##  Parameters
--- * `table:` A table of nested sub-tables you wish to flatten.
--- 
--- ##  Example:
--- ```lua
--- local t1 = {1, 2, {3, 4}};
--- local t2 = {1, 2, {3, 4, {5, 6}}};
--- local t3 = {1, 2, {3, 4, {5, 6, {7, 8, {9, 10}}}}};
--- table.n_flatten(t1) -- {1, 2, 3, 4}
--- table.n_flatten(t2) -- {1, 2, 3, 4, 5, 6}
--- table.n_flatten(t3) -- {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
--- ```
function table.n_flatten(table)
end

---  Returns a table of unique values within tbl which one of the supplied patterns matches using string.match
--- 
--- ##  Parameters
--- * `tbl:`
---  The table you want to search for values
--- * `pattern:`
---  The pattern you want to check each value with, using string.match. You can supply multiple patterns, separated by commas
--- {{Note}} Available in Mudlet 4.8+
--- 
--- ##  Example
--- ```lua
--- local items = { this = "that", [4] = "other", hp = 500, mana = 40 }
--- local matches = table.n_matches(items, "%a")
--- -- matches will be { "that", "other" }
--- -- order is not preserved/guaranteed
--- ```
function table.n_matches(tbl, pattern, pattern2, patternN)
end

---  Returns a numerically indexed table that is the union of the provided tables (that is - merges two indexed lists together). This is a union of unique values. The order and keys of the input tables are not preserved.
--- 
--- ##  Parameters
--- * `table1:` the first table as an indexed list.
--- * `table2:` the second table as an indexed list.
--- 
--- ##  Example:
--- ```lua
--- display(table.n_union({"bob", "mary"}, {"august", "justinian"}))
--- 
--- {
---   "bob",
---   "mary",
---   "august",
---   "justinian"
--- }
--- ```
function table.n_union(table1, table2)
end

---  Returns a table that is the relative complement of the first numerically indexed table with respect to the second numerically indexed table. Returns a numerically indexed complement of values.
--- 
--- ##  Parameters
--- * `table1:`
--- * `table2:`
--- 
--- ##  Example:
--- <syntaxhighlight lang=lua>local t1 = {1,2,3,4,5,6}
--- local t2 = {2,4,6}
--- local comp = table.n_complement(t1,t2)
--- display(comp)```
--- This prints the following:
---    1,
---    3,
---    5
--- 
--- ##  Returns
---  A table containing all the values from table1 that do not match the values from table2.
function table.n_complement(set1, set2)
end

---  Returns a numerically indexed table that is the intersection of the provided tables. This is an intersection of unique values. The order and keys of the input tables are not preserved
--- 
--- ##  Example:
--- <syntaxhighlight lang=lua>local t1 = {1,2,3,4,5,6}
--- local t2 = {2,4,6}
--- local intersect = table.n_intersection(t1,t2)
--- display(intersect)```
--- This prints the following:
---    2,
---    4,
---    6
--- 
--- ##  Returns
---  A table containing the values that are found in every one of the tables.
function table.n_intersection(...)
end

---  Internal function used by table.save() for serializing data.
function table.pickle(_t, file, tables, lookup_)
end

---  Remove a value from an indexed table, by the values position in the table.
--- See also:
--- see: table.insert()
--- ##  Parameters:
--- * **table**
---  The indexed table you are removing the value from.
--- * **value_position**
---  The indexed number for the value you are removing.
--- 
--- ##  Example:
--- ```lua
--- testTable = { "hi", "bye", "cry", "why" }
--- table.remove(testTable, 1) -- will remove hi from the table
--- -- new testTable after the remove
--- testTable = { "bye", "cry", "why" }
--- -- original position of hi was 1, after the remove, position 1 has become bye
--- -- any values under the removed value are moved up, 5 becomes 4, 4 becomes 3, etc
--- ``` 
--- Note:  To remove a value from a key-value table, it's best to simply change the value to nil.
--- ```lua
--- testTable = { test = "testing", go = "boom", frown = "glow" }
--- table.remove(testTable, test) -- this will error
--- testTable.test = nil -- won't error
--- testTable["test"] = nil -- won't error
--- ```
function table.remove(table, value_position)
end

---  Save a table into an external file in **location**.
--- See also:
--- see: table.load()
--- ##  Parameters:
--- * **location:**
---  Where you want the table file to be saved. Can be anywhere on your computer.
--- * **table:**
---  The table that you are saving to the file.
--- 
---  Example:
--- ```lua
--- -- Saves the table mytable to the lua file mytable in your Mudlet Home Directory
--- table.save(getMudletHomeDir().."/mytable.lua", mytable)
--- ```
function table.save(location, table)
end

--- Sorts table elements in a given order, in-place, from <code>Table[1]</code> to <code>Table[n]</code>, where <code>n</code> is the length of the table. 
--- 
--- If <code>comp</code> is given, then it must be a function that receives two table elements, and returns true when the first is less than the second (so that not <code>comp(a[i+1],a[i])</code> will be true after the sort). If <code>comp</code> is not given, then the standard Lua operator <code><</code> is used instead.
--- 
--- The sort algorithm is not stable; that is, elements considered equal by the given order may have their relative positions changed by the sort.
function table.sort(Table_, _comp)
end

---  Returns the size of a key-value table (this function has to iterate through all of the table to count all elements).
---  Returns a number.
--- 
--- ##  Parameters
--- * `t:` 
---  The table you are checking the size of.
--- Note: 
--- For index based tables you can get the size with the # operator:
--- This is the standard Lua way of getting the size of index tables i.e. ipairs() type of tables with numerical indices. 
--- To get the size of tables that use user defined keys instead of automatic indices (pairs() type) you need to use the function table.size() referenced above.
--- ```lua
--- local test_table = { "value1", "value2", "value3", "value4" }
--- myTableSize = #test_table
--- -- This would return 4.
--- local myTable = { 1 = "hello", "key2" = "bye", "key3" = "time to go" }
--- table.size(myTable)
--- -- This would return 3.
--- ```
function table.size(t)
end

---  Internal function used by table.load() for deserialization.
function table.unpickle(_t, tables, tcopy, pickled_)
end

---  Returns a table in which key/value pairs from table2 are added to table1, and any keys present in both tables are assigned the value from table2, so that the resulting table is table1 updated with information from table2.
--- 
--- ## Example
--- <syntaxhighlight lang=lua>display(table.update({a = 1, b = 2, c = 3}, {b = 4, d = 5}))
--- {
---    a = 1,
---    b = 4,
---    c = 3,
---    d = 5
--- }
--- 
--- -- to just set a table to new values, assign it directly:
--- mytable = {key1 = "newvalue"}
--- ```
function table.update(table1, table2)
end

---  Returns a table that is the union of the provided tables. This is a union of key/value pairs. If two or more tables contain different values associated with the same key, that key in the returned table will contain a subtable containing all relevant values. See table.n_union() for a union of values. Note that the resulting table may not be reliably traversable with ipairs() due to the fact that it preserves keys. If there is a gap in numerical indices, ipairs() will cease traversal.
--- 
--- ## Examples
--- ```lua
--- tableA = {
---    [1] = 123,
---    [2] = 456,
---    ["test"] = "test",
--- }
--- ---
--- tableB = {
---    [1] = 23,
---    [3] = 7,
---    ["test2"] = function() return true end,
--- }
--- ---
--- tableC = {
---    [5] = "c",
--- }
--- ---
--- table.union(tableA, tableB, tableC)
--- -- will return the following:
--- {
---    [1] = {
---       123,
---       23,
---    },
---    [2] = 456,
---    [3] = 7,
---    [5] = "c",
---    ["test"] = "test",
---    ["test2"] = function() return true end,
--- }
--- ```
function table.union(...)
end

