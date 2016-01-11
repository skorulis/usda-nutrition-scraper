require 'net/http'
require 'httpclient'
require 'json'

if ARGV.count < 1
	puts "usage: ruby getFoods.rb [APIKey]"
	abort
end

@APIKey = ARGV[0]
@baseURL = "http://api.nal.usda.gov/ndb/list"
@url = @baseURL + "?format=json&lt=f&sort=n&max=500&api_key=" + @APIKey


@allItems = Array.new

def downloadChunk(url)
	clnt = HTTPClient.new;
	data = clnt.get_content(url)
	result = JSON.parse(data)
	for item in result["list"]["item"]
		item.delete("offset")
		@allItems.push(item)
	end
	
	return result["list"]["total"]
end

offset = 0

begin
	url = @url + "&offset=" + offset.to_s
	count = downloadChunk(url)
	offset += count
	puts "got offset " + offset.to_s
end while count == 500

puts @allItems.length

file = File.new("items.js", "wb");
file.write(JSON.pretty_generate(@allItems))
