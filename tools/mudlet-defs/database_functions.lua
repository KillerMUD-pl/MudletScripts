---  Adds one or more new rows to the specified sheet. If any of these rows would violate a UNIQUE index, a lua error will be thrown and execution will cancel. As such it is advisable that if you use a UNIQUE index, you test those values before you attempt to insert a new row.
---  Returns **nil** plus the error message if the operation failed (so it won't raise an a runtime error in Mudlet).
--- ## Example
--- ```lua
--- --Each table is a series of key-value pairs to set the values of the sheet, 
--- --but if any keys do not exist then they will be set to nil or the default value.
--- db:add(mydb.enemies, {name="Bob Smith", city="San Francisco"})
--- db:add(mydb.enemies,
---      {name="John Smith", city="San Francisco"},
---      {name="Jane Smith", city="San Francisco"},
---      {name="Richard Clark"})
--- ```
--- As you can see, all fields are optional.
function db:add(sheet_reference, table1, …, tableN)
end

--- Returns the result of calling the specified aggregate function on the field and its sheet. The query is optional.
--- The supported aggregate functions are:
--- * COUNT - Returns the total number of records that are in the sheet or match the query.
--- * AVG - Returns the average of all the numbers in the specified field.
--- * MAX - Returns the highest number in the specified field.
--- * MIN - Returns the lowest number in the specified field.
--- * TOTAL - Returns the value of adding all the contents of the specified field.
--- 
--- Note:  You can supply a boolean **true** for the distinct argument since Mudlet 3.0 to filter by distinct values.
--- 
--- ## Example
--- ```lua
--- local mydb = db:get_database("my database")
--- echo(db:aggregate(mydb.enemies.name, "count"))
--- ```
--- 
--- It can also be used in conjunction with db:like to return a number of results.
--- 
--- ## Example
--- ```lua
--- local query = matches[2]
--- local mydb = db:get_database("itemsdab")
--- local results = db:aggregate(mydb.itemstats.objname, "count", db:like(mydb.itemstats.objname, "%" .. query .. "%"))
--- cecho("Found <red>"..results.."<reset> items that match the description.")
--- ```
function db:aggregate(field_reference, aggregate_function, query, distinct)
end

--- Returns a compound database expression that combines all of the simple expressions passed into it; these expressions should be generated with other db: functions such as [[Manual:Lua_Functions#db:eq|db:eq]], [[Manual:Lua_Functions#db:like|db:like]], [[Manual:Lua_Functions#db:lt|db:lt]] and the like.
--- This compound expression will only find items in the sheet if all sub-expressions match.
function db:AND(sub-expression1, …, sub-expressionN)
end

--- Returns a database expression to test if the field in the sheet is a value between lower_bound and upper_bound. This only really makes sense for numbers and Timestamps.
function db:between(field_reference, lower_bound, upper_bound)
end

--- Closes a database connection so it can't be used anymore.
function db:close(database_name)
end

--- Creates and/or modifies an existing database. This function is safe to define at a top-level of a Mudlet script: in fact it is recommended you run this function at a top-level without any kind of guards. If the named database does not exist it will create it. If the database does exist then it will add any columns or indexes which didn’t exist before to that database (note that this does not currently work in Mudlet 2.1 due to a bug in Lua SQL. See below on how to deal with it). If the database already has all the specified columns and indexes, it will do nothing.
--- The database will be called Database_<sanitized database name>.db and will be stored in the Mudlet configuration directory within your profile folder.
--- Database tables are called sheets consistently throughout this documentation, to avoid confusion with Lua tables.
--- The schema table must be a Lua table array containing table dictionaries that define the structure and layout of each sheet
--- 
--- ## Example
--- ```lua
--- local mydb = db:create("combat_log",
---   {
---     kills = {
---               name = "",
---               area = "",
---               killed = db:Timestamp("CURRENT_TIMESTAMP"),
---               _index = { {"name", "area"} }
---           },
---             enemies = {
---               name = "",
---                   city = "",
---                   reason = "",
---                   enemied = db:Timestamp("CURRENT_TIMESTAMP"),
---                   _index = { "city" },
---                   _unique = { "name" },
---                   _violations = "IGNORE"
---     }
---   })
--- ```
--- The above will create a database with two sheets; the first is kills and is used to track every successful kill, with both where and when the kill happened. It has one index, a compound index tracking the combination of name and area. The second sheet has two indexes, but one is unique: it isn’t possible to add two items to the enemies sheet with the same name.
--- 
--- For sheets with unique indexes, you may specify a _violations key to indicate how the db layer handle cases where the unique index is violated. The options you may use are:
--- 
--- * **FAIL** - the default. A hard error is thrown, cancelling the script.
--- * **IGNORE** - The command that would add a record that violates uniqueness just fails silently.
--- * **REPLACE** - The old record which matched the unique index is dropped, and the new one is added to replace it.
--- 
--- Returns a reference of an already existing database. This instance can be used to get references to the sheets (and from there, fields) that are defined within the database. You use these references to construct queries.
--- If a database has a sheet named enemies, you can obtain a reference to that sheet by simply doing:
--- ```lua
--- local mydb = db:get_database("my database")
--- local enemies_ref = mydb.enemieslocal
--- local name_ref = mydb.enemies.name
--- ```
--- 
--- Note:  db:create() supports adding new columns and indexes to existing databases, but this functionality is currently broken in Mudlet 2.1 due to the underlying Lua SQL binding used being out of date. When you want to add a new column, you have several options:
--- * if you are just testing and getting setup, close Mudlet, and delete the `Database_<sanitized database name>.db` file in your Mudlet folder.
--- * if you've already gotten a script and have a fair bit of data with it, or users are already using your script and telling them to delete files on an upgrade is unreasonable, you can use direct SQL to add in a new column. **WARNING**, this is an expert option, and requires knowledge of SQL to accomplish. You must backup your database file before you start coding this in.
--- 
--- ```lua
---   -- at first, update your db:create schema to have the new field.
---   -- then, we'll tell the database to create it if it doesn't exist
--- 
---   -- fetch the data we've got in our sample database
---   local test = db:fetch(ndb.db.people)
---   -- this requires at least one entry in the database to work
---   if next(test) then
---     local _,someperson = next(test)
---     
---     -- in this example, we want to add an order key. If there is no key, means it doesn't exist yet, so it should be added.
---     if someperson.order == nil then
---       -- do not do the things you see here elsewhere else. This is a big hack/workaround.
---       local conn = db.__conn.namedb
---       -- order should be a text field, so note that we specify it's type with TEXT and the default value at the end with ""
---       local sql_add = [[ALTER TABLE people ADD COLUMN "order" TEXT NULL DEFAULT ""]]
---       conn:execute(sql_add)
---       conn:commit()
---     end
--- 
---     -- here is an another example, in one where we need to add a field that is a number
---     if someperson.dragon == nil then
---       local conn = db.__conn.namedb
---       -- observe that we use the REAL type by default instead and a default of 0
---       local sql_add = [[ALTER TABLE people ADD COLUMN "dragon" REAL NULL DEFAULT 0]]
---       conn:execute(sql_add)
---       conn:commit()
---     end
---   end
--- ```
function db:create(database_name, schema_table)
end

--- Deletes rows from the specified sheet. The argument for query tries to be intelligent:
--- * If it is a simple number, it deletes a specific row by _row_id
--- * If it is a table that contains a _row_id (e.g., a table returned by db:get) it deletes just that record.
--- * Otherwise, it deletes every record which matches the query pattern which is specified as with [[Manual:Lua_Functions#db:get|b:get]].
--- * If the query is simply true, then it will truncate the entire contents of the sheet.
--- 
--- ## Example
--- ```lua
--- enemies = db:fetch(mydb.enemies)
--- db:delete(mydb.enemies, enemies[1])
--- 
--- db:delete(mydb.enemies, enemies[1]._row_id)
--- db:delete(mydb.enemies, 5)
--- db:delete(mydb.enemies, db:eq(mydb.enemies.city, "San Francisco"))
--- db:delete(mydb.enemies, true)
--- ```
--- Those deletion commands will do in order:
--- 
--- #one When passed an actual result table that was obtained from db:fetch, it will delete the record for that table.
--- #two When passed a number, will delete the record for that _row_id. This example shows getting the row id from a table.
--- #three As above, but this example just passes in the row id directly.
--- #four Here, we will delete anything which matches the same kind of query as db:fetch uses-- namely, anyone who is in the city of San Francisco.
--- #five And finally, we will delete the entire contents of the enemies table.
function db:delete(sheet_reference, query)
end

--- Returns a database expression to test if the field in the sheet is equal to the value.
function db:eq(field_reference, value)
end

--- Returns the string as-is to the database.
--- Use this function with caution, but it is very useful in some circumstances. One of the most common of such is incrementing an existing field in a db:set() operation, as so:
--- ```lua
--- db:set(mydb.enemies, db:exp("kills + 1"), db:eq(mydb.enemies.name, "Ixokai"))
--- ```
--- This will increment the value of the kills field for the row identified by the name Ixokai.
--- But there are other uses, as the underlining database layer provides many functions you can call to do certain things. If you want to get a list of all your enemies who have a name longer then 10 characters, you may do:
--- ```lua
--- db:fetch(mydb.enemies, db:exp("length(name) > 10"))
--- ```
--- Again, take special care with this, as you are doing SQL syntax directly and the library can’t help you get things right.
function db:exp(string)
end

--- Returns a table array containing a table for each matching row in the specified sheet. All arguments but sheet are optional. If query is nil, the entire contents of the sheet will be returned.
--- Query is a string which should be built by calling the various db: expression functions, such as db:eq, db:AND, and such. You may pass a SQL WHERE clause here if you wish, but doing so is very dangerous. If you don’t know SQL well, its best to build the expression.
--- Query may also be a table array of such expressions, if so they will be AND’d together implicitly.
--- The results that are returned are not in any guaranteed order, though they are usually the same order as the records were inserted. If you want to rely on the order in any way, you must pass a value to the order_by field. This must be a table array listing the fields you want to sort by. It can be { mydb.kills.area }, or { mydb.kills.area, mydb.kills.name }
--- The results are returned in ascending (smallest to largest) order; to reverse this pass true into the final field.
--- 
--- ## Example
--- ```lua
--- db:fetch(mydb.enemies, nil, {mydb.enemies.city, mydb.enemies.name})
--- db:fetch(mydb.enemies, db:eq(mydb.enemies.city, "San Francisco"))
--- db:fetch(mydb.kills,
---      {db:eq(mydb.kills.area, "Undervault"),
---      db:like(mydb.kills.name, "%Drow%")}
--- )
--- ```
--- The first will fetch all of your enemies, sorted first by the city they reside in and then by their name.
--- The second will fetch only the enemies which are in San Francisco.
--- The third will fetch all the things you’ve killed in Undervault which have Drow in their name.
function db:fetch(sheet_reference, query, order_by, descending)
end

--- Allows to run db:fetch with hand crafted sql statements.
--- 
--- When you have a large number of objects in your database, you may want an alternative method of accessing them. In this case, you can first obtain a list of the _row_id for the objects that match your query with the following alias:
--- 
--- ## Example
--- ```lua
--- local mydb = db:get_database("itemsdab")
--- local query = matches[2]
--- local t = {}
--- res = db:fetch(mydb.itemstats, db:query_by_example(mydb.itemstats, {objname = "%" .. query .. "%"}))
--- for k, v in pairs(res) do
---   print(v._row_id)
---   table.insert(t,v._row_id)
--- end
--- handoff = table.concat(t, "|")
--- display(handoff)
--- ```
--- Then you can use the following code in a separate alias to query your database using the previously retrieved _row_id.
--- ## Example
--- ```lua
--- local mydb = db:get_database("itemsdab")
--- local query = matches[2]
--- display(db:fetch_sql(mydb.itemstats, "select * from itemstats where _row_id ="..query))
--- --This alias is used to query a database by _row_id
--- ```
function db:fetch_sql(sheet_reference, sql_string)
end

--- Returns a database expression to test if the field in the sheet is greater than to the value.
function db:gt(field_reference, value)
end

--- Returns your database name.
--- 
--- ## Example
--- ```lua
--- local mydb = db:get_database("my database")
--- ```
function db:get_database(database_name)
end

--- Returns a database expression to test if the field in the sheet is greater than or equal to the value.
function db:gte(field_reference, value)
end

--- Returns a database expression to test if the field in the sheet is one of the values in the table array.
--- First, note the trailing underscore carefully! It is required.
--- The following example illustrates the use of in_:
--- ```lua
--- local mydb = db:get_database("my database")
--- local areas = {"Undervault", "Hell", "Purgatory"}
--- 
--- db:fetch(mydb.kills, db:in_(mydb.kills.area, areas))
--- ```
--- This will obtain all of your kills which happened in the Undervault, Hell or Purgatory. Every db:in_ expression can be written as a db:OR, but that quite often gets very complex.
function db:in_(field_reference, table_array)
end

--- Returns a database expression to test if the field in the sheet is nil.
function db:is_nil(field_reference)
end

--- Returns a database expression to test if the field in the sheet is not nil.
function db:is_not_nil(field_reference)
end

--- returns a database expression to test if the field in the sheet matches the specified pattern.
--- LIKE patterns are not case-sensitive, and allow two wild cards. The first is an underscore which matches any single one character. The second is a percent symbol which matches zero or more of any character.
--- LIKE with "_" is therefore the same as the "." regular expression.
--- LIKE with "%" is therefore the same as ".*" regular expression.
function db:like(field_reference, pattern)
end

--- Returns a database expression to test if the field in the sheet is less than the value.
function db:lt(field_reference, value)
end

--- Returns a database expression to test if the field in the sheet is less than or equal to the value.
function db:lte(field_reference, value)
end

--- Merges the specified table array into the sheet, modifying any existing rows and adding any that don’t exist.
--- This function is a convenience utility that allows you to quickly modify a sheet, changing existing rows and add new ones as appropriate. It ONLY works on sheets which have a unique index, and only when that unique index is only on a single field. For more complex situations you’ll have to do the logic yourself.
--- The table array may contain tables that were either returned previously by db:fetch, or new tables that you’ve constructed with the correct fields, or any mix of both. Each table must have a value for the unique key that has been set on this sheet.
--- ## For example, consider this database:
--- ```lua
--- local mydb = db:create("peopledb",
---      {
---           friends = {
---                name = "",
---                race = "",
---                level = 0,
---                city = "",
---                _index = { "city" },
---                _unique = { "name" }
---           }
--- );
--- ```
--- Here you have a database with one sheet, which contains your friends, their race, level, and what city they live in. Let’s say you want to fetch everyone who lives in San Francisco, you could do:
--- ```lua
--- local results = db:fetch(mydb.friends, db:eq(mydb.friends.city, "San Francisco"))
--- ```
--- The tables in results are static, any changes to them are not saved back to the database. But after a major radioactive cataclysm rendered everyone in San Francisco a mutant, you could make changes to the tables as so:
--- ```lua
--- for _, friend in ipairs(results) do
---      friend.race = "Mutant"
--- end
--- ```
--- If you are also now aware of a new arrival in San Francisco, you could add them to that existing table array:
--- ```lua
--- results[#results+1] = {name="Bobette", race="Mutant", city="San Francisco"}
--- ```
--- And commit all of these changes back to the database at once with:
--- ```lua
--- db:merge_unique(mydb.friends, results)
--- ```
--- The db:merge_unique function will change the city values for all the people who we previously fetched, but then add a new record as well.
function db:merge_unique(sheet_reference, table_array)
end

--- Returns a database expression to test if the field in the sheet is not a value between lower_bound and upper_bound. This only really makes sense for numbers and Timestamps.
function db:not_between(field_reference, lower_bound, upper_bound)
end

--- Returns a database expression to test if the field in the sheet is NOT equal to the value.
function db:not_eq(field_reference, value)
end

--- Returns a database expression to test if the field in the sheet is not one of the values in the table array.
--- 
--- See also:
--- see: db:in_()
function db:not_in(field_reference, table_array)
end

--- Returns a database expression to test if the field in the sheet does not match the specified pattern.
--- LIKE patterns are not case-sensitive, and allow two wild cards. The first is an underscore which matches any single one character. The second is a percent symbol which matches zero or more of any character.
--- LIKE with "_" is therefore the same as the "." regular expression.
--- LIKE with "%" is therefore the same as ".*" regular expression.
function db:not_like(field_reference, pattern)
end

--- Returns a compound database expression that combines both of the simple expressions passed into it; these expressions should be generated with other db: functions such as [[Manual:Lua_Functions#db:eq|db:eq]], [[Manual:Lua_Functions#db:like|db:like]], [[Manual:Lua_Functions#db:lt|db:lt]] and the like.
--- 
--- This compound expression will find any item that matches either the first or the second sub-expression.
function db:OR(sub-expression1, sub-expression2)
end

--- Returns a query for database content matching the given example, which can be used for db:delete, db:fetch and db:set. Different fields of the example are AND connected.
--- 
--- Field values should be strings and can contain the following values:
--- *literal strings to search for
--- *comparison terms prepended with &lt;, &gt;, &gt;=, &lt;=, !=, &lt;&gt; for number and date comparisons
--- *ranges with :: between lower and upper bound
--- *different single values combined by || as OR
--- *strings containing % for a single and _ for multiple wildcard characters
--- 
--- Note:  Available from Mudlet 3.0 release.
--- 
--- ## Example
--- ```lua
--- mydb = db:create("mydb",
--- {
---   sheet = {
---   name = "", id = 0, city = "",
---   _index = { "name" },
---   _unique = { "id" },
---   _violations = "FAIL"
---   }
--- })
--- test_data = {
---   {name="Ixokai", city="Magnagora", id=1},
---   {name="Vadi", city="New Celest", id=2},
---   {name="Heiko", city="Hallifax", id=3},
---   {name="Keneanung", city="Hashan", id=4},
---   {name="Carmain", city="Mhaldor", id=5},
---   {name="Ixokai", city="Hallifax", id=6},
--- }
--- db:add(mydb.sheet, unpack(test_data))
--- res = db:fetch(mydb.sheet, db:query_by_example(mydb.sheet, { name = "Ixokai"}))
--- display(res)
--- --[[
--- Prints
--- {
---   {
---     id = 1,
---     name = "Ixokai",
---     city = "Magnagora"
---   },
---   {
---     id = 6,
---     name = "Ixokai",
---     city = "Hallifax"
---   }
--- }
--- --]]
--- ```
--- 
--- ```lua
--- mydb = db:create("mydb",
---   {
---     sheet = {
---     name = "", id = 0, city = "",
---     _index = { "name" },
---     _unique = { "id" },
---     _violations = "FAIL"
---     }
---   })
--- test_data = {
---   {name="Ixokai", city="Magnagora", id=1},
---   {name="Vadi", city="New Celest", id=2},
---   {name="Heiko", city="Hallifax", id=3},
---   {name="Keneanung", city="Hashan", id=4},
---   {name="Carmain", city="Mhaldor", id=5},
---   {name="Ixokai", city="Hallifax", id=6},
--- }
--- db:add(mydb.sheet, unpack(test_data))
--- res = db:fetch(mydb.sheet, db:query_by_example(mydb.sheet, { name = "Ixokai", id = "1"}))
--- display(res)
--- --[[
---   Prints
---   {
---     id = 1,
---     name = "Ixokai",
---     city = "Magnagora"
---   }
--- --]]
--- ```
function db:query_by_example(sheet_reference, example_table)
end

--- Strips all non-alphanumeric characters from the input string.Mainly used to sanitize database names.
function db:safe_name(string)
end

--- The db:set function allows you to set a certain field to a certain value across an entire sheet. Meaning, you can change all of the last_read fields in the sheet to a certain value, or possibly only the last_read fields which are in a certain city. The query argument can be any value which is appropriate for db:fetch, even nil which will change the value for the specified column for EVERY row in the sheet.
--- For example, consider a situation in which you are tracking how many times you find a certain type of egg during Easter. You start by setting up your database and adding an Eggs sheet, and then adding a record for each type of egg.
--- 
--- ## Example
--- ```lua
--- local mydb = db:create("egg database", {eggs = {color = "", last_found = db.Timestamp(false), found = 0}})
---         db:add(mydb.eggs,
---                 {color = "Red"},
---                 {color = "Blue"},
---                 {color = "Green"},
---                 {color = "Yellow"},
---                 {color = "Black"}
---         )
--- ```
--- Now, you have three columns. One is a string, one a timestamp (that ends up as nil in the database), and one is a number.
--- You can then set up a trigger to capture from the mud the string, "You pick up a (.*) egg!", and you end up arranging to store the value of that expression in a variable called "myegg".
--- To increment how many we found, we will do this:
--- ```lua
--- myegg = "Red" -- We will pretend a trigger set this.
---         db:set(mydb.eggs.found, db:exp("found + 1"), db:eq(mydb.eggs.color, myegg))
---         db:set(mydb.eggs.last_found, db.Timestamp("CURRENT_TIMESTAMP"), db:eq(mydb.eggs.color, myegg))
--- ```
--- This will go out and set two fields in the Red egg sheet; the first is the found field, which will increment the value of that field (using the special db:exp function). The second will update the last_found field with the current time.
--- Once this contest is over, you may wish to reset this data but keep the database around. To do that, you may use a more broad use of db:set as such:
--- ```lua
--- db:set(mydb.eggs.found, 0)
--- db:set(mydb.eggs.last_found, nil)
--- ```
function db:set(field_reference, value, query)
end

--- This function updates a row in the specified sheet, but only accepts a row which has been previously obtained by db:fetch. Its primary purpose is that if you do a db:fetch, then change the value of a field or tow, you can save back that table.
--- 
--- ## Example
--- ```lua
--- local mydb = db:get_database("my database")
--- local bob = db:fetch(mydb.friends, db:eq(mydb.friends.name, "Bob"))[1]
--- bob.notes = "He's a really awesome guy."
--- db:update(mydb.friends, bob)
--- ```
--- This obtains a database reference, and queries the friends sheet for someone named Bob. As this returns a table array containing only one item, it assigns that one item to the local variable named bob. We then change the notes on Bob, and pass it into db:update() to save the changes back.
function db:update(sheet_reference, table)
end

--- Converts a data value in Lua to its SQL equivalent; notably it will also escape single-quotes to prevent inadvertant SQL injection.
function db:_sql_convert(value)
end

--- This quotes values to be passed into an INSERT or UPDATE operation in a SQL list. Meaning, it turns {x="this", y="that", z=1} into ('this', 'that', 1). It is intelligent with data-types; strings are automatically quoted (with internal single quotes escaped), nil turned into NULL, timestamps converted to integers, and such.
--- 
--- = Transaction Functions =
--- These functions facilitate use of transactions with a database. This can safely be ignored in most cases, but can provide useful functionality in specific circumstances. Transactions allow batching sets of changes to be accepted or rejected at a later point. Bear in mind that transactions affect an entire database.
function db:_sql_values(values)
end

--- This function halts all automatic disk writes for the database. This can be especially helpful when running large or frequent (multiple times a second) database edits through multiple function calls to prevent Mudlet freezing or jittering. Calling this on a database already in a transaction will have no effect, but will not produce an error.
function db:_begin()
end

--- This function forces the database to save all changes to disk, beginning a new transaction in the process.
function db:_commit()
end

--- This function re-enables automatic disk writes for the database. It will not commit changes to disk on its own, nor will it end the current transaction. Using db:_commit() or any database function that writes changes after this will save the transaction to disk. Using db:_begin again before this happens will continue the previous transaction without writing anything to disk.
function db:_end()
end

--- This function will discard all changes that have occurred during the current transaction and begin a new one. Use of this function will not toggle the auto-write state of the database.
function db:_rollback()
end

