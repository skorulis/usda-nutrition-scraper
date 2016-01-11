USDA nutrition scraper
---------

These scripts are to take all information from the [USDA National Nutrient Database](http://ndb.nal.usda.gov/ndb/search) put them into a single file and then ultimately into a smaller SQLite representation

Usage
----

You will first have to register to get an API key. These keys are limited to 1000 requests per hour so be sure not to go over that.

`ruby getFoods.rb [APIKey]`

Then repeatedly call with enough time between calls to fill the JSON file. It should come out to ~ 100MB

`ruby getFoods.rb [APIKey] [callCount]`

Once this is done create a new SQLite database called nutrition.db and run the provided SQL to setup the schema

`ruby fillDB.rb`