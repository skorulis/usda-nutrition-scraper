require 'json'
require "sqlite3"

database = SQLite3::Database.open "nutrition.db"

@dailyValues = JSON.parse(File.read("dv.json"))

@factCount = 0

database.execute "DELETE FROM nutrient_fact"

for item in @dailyValues

	stm = database.prepare "UPDATE nutrient SET dailyValue=?,priority=?,displayName=?,displayCategory=? WHERE name=?"
	stm.bind_param 1, item["dv"]
	stm.bind_param 2, item["priority"]
	stm.bind_param 3, item["displayName"]
	stm.bind_param 4, item["displayCategory"]
	stm.bind_param 5, item["name"]
	
	stm.execute
	stm.close
	
	stm = database.prepare "SELECT * FROM nutrient WHERE name=?"
	stm.bind_param 1, item["name"]
	rs = stm.execute
	existing = rs.next
	stm.close
	
	if item["facts"] != nil
		for fact in item["facts"]
			@factCount = @factCount + 1
			database.execute 'INSERT INTO "nutrient_fact" (id,fact,url,nutrient_id) VALUES (?,?,?,?)',[@factCount,fact["fact"],fact["url"],existing[0]]
		end
	end
	
	
end

stm = database.prepare "SELECT * FROM nutrient order by priority DESC"
rs = stm.execute

while (row = rs.next) do
  puts row.join "\s"
end

stm.close
database.close