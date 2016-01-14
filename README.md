USDA nutrition scraper
---------

These scripts are to take all information from the [USDA National Nutrient Database](http://ndb.nal.usda.gov/ndb/search) put them into a single file and then ultimately into a smaller SQLite representation. [Here's the accompanying blog post](http://skorulis.github.io/skorulis-blog/ios/nutrition/2016/01/10/food-nutrition.html)

Usage
----

You will first have to register to get an API key. These keys are limited to 1000 requests per hour so be sure not to go over that.

`ruby getFoods.rb [APIKey]`

Then repeatedly call with enough time between calls to fill the JSON file. It should come out to ~ 100MB

`ruby getFoods.rb [APIKey] [callCount]`

Once this is done run the fillDB script which will create and fill the SQLite database. This may take a while

`ruby fillDB.rb`


Notice
-----
I am not a ruby developer, I just use it to write small throwaway scripts so don't expect this to be high quality code.


