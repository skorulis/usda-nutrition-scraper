require 'net/http'
require 'httpclient'
require 'json'

if ARGV.count < 2
	puts "usage: ruby getNutrition.rb [APIKey] [maxCalls]"
	abort
end

@APIKey = ARGV[0]
@maxCalls = ARGV[1].to_i
@baseURL = "http://api.nal.usda.gov/ndb/reports"
@baseURL = @baseURL + "?type=f&format=json&api_key=" + @APIKey

@allItems = JSON.parse(File.read("items.js"))

def downloadData(url)
	clnt = HTTPClient.new;
	data = clnt.get_content(url)
	result = JSON.parse(data)
	return result["report"]
end

@count = 0
@total = 0

for item in @allItems
	@total = @total + 1
	if item["nutrients"] == nil
		url = @baseURL + "&ndbno=" + item["id"]
		puts url
		report = downloadData(url)
		item["cat"] = report["food"]["fg"]
		item["nutrients"] = Array.new
		for nutrient in report["food"]["nutrients"]
			nutHash = Hash.new
			nutHash["nutId"] = nutrient["nutrient_id"]
			nutHash["name"] = nutrient["name"]
			nutHash["group"] = nutrient["group"]
			nutHash["unit"] = nutrient["unit"]
			nutHash["value"] = nutrient["value"]
			item["nutrients"].push(nutHash)
		end
	
		@count = @count + 1
		if @count >= @maxCalls
			break
		end
	end
	
end

puts "total items with data " + @total.to_s

file = File.new("items.js", "wb");
file.write(JSON.pretty_generate(@allItems))
