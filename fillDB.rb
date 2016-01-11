require 'json'
require "sqlite3"

db = SQLite3::Database.open "nutrition.db"

@allItems = JSON.parse(File.read("items.js"))

puts "item count " + @allItems.count.to_s

@nutrientCount = 0
@nutrients = Hash.new
@categories = Hash.new
for item in @allItems
	if item["nutrients"] == nil
		item["nutrients"] = Array.new #For the case where not all the data exists
	end
	if item["cat"] == nil
		item["cat"] = "unknown"
	end
	item["nutrients"] = item["nutrients"].select { |nut| nut["name"] != "Energy" || nut["unit"] != "kcal"}
	@nutrientCount += item["nutrients"].count
	
	cat = item["cat"]
	
	if @categories[cat] == nil
		@categories[cat] = Hash.new
		@categories[cat]["name"] = cat
		@categories[cat]["id"] = @categories.count
	end
	
	for nut in item["nutrients"]
		name = nut["name"]
		unit = nut["unit"]
		if @nutrients[name] == nil
			@nutrients[name] = Hash.new
			@nutrients[name]["group"] = nut["group"]
			@nutrients[name]["unit"] = unit
			@nutrients[name]["name"] = name
			@nutrients[name]["id"] = @nutrients.count
		else
			if @nutrients[name]["unit"] != unit
				puts "missmatch " + unit + " != " + @nutrients[name]["unit"]
			end
		end
	end
end

puts "nutrient count " + @nutrientCount.to_s
puts "unique " + @nutrients.count.to_s

@nutrients.each do |key,nut|
	db.execute 'INSERT INTO "nutrient" (id,name,nutrientGroup,baseUnit) VALUES (?,?,?,?)',[nut["id"],nut["name"],nut["group"],nut["unit"]]
end

@categories.each do |key,cat|
	db.execute 'INSERT INTO "food_category" (id,name) VALUES (?,?)',[cat["id"],cat["name"]]
end

@allItems.each_with_index { |food,index|
	cat = @categories[food["cat"]]
	db.execute 'INSERT INTO "food" (id,name,category_id) VALUES (?,?,?)',[index+1,food["name"],cat["id"]]
	for nut in food["nutrients"]
		nutDB = @nutrients[nut["name"]]
		db.execute 'INSERT INTO "food_nutrient" (food_id,nutrient_id,quantity) VALUES (?,?,?)',[index+1,nutDB["id"],nut["value"]]
	end
}

db.close