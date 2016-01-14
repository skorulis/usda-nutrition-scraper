create table "food_category" ("id" SERIAL NOT NULL PRIMARY KEY,"name" VARCHAR(254) NOT NULL);
create table "nutrient" ("id" SERIAL NOT NULL PRIMARY KEY,"name" VARCHAR(254) NOT NULL,"nutrientGroup" VARCHAR(254) NOT NULL,"baseUnit" VARCHAR(254) NOT NULL);
create table "food" ("id" SERIAL NOT NULL PRIMARY KEY,"name" VARCHAR(511) NOT NULL,"category_id" INTEGER NOT NULL);
create table "food_nutrient" ("food_id" INTEGER NOT NULL,"nutrient_id" INTEGER NOT NULL,"quantity" DOUBLE PRECISION NOT NULL);
CREATE INDEX index_food_category_id ON food (category_id);
CREATE INDEX index_food_nutrient_food_id ON food_nutrient (food_id);
CREATE INDEX index_food_nutrient_nutrient_id ON food_nutrient (nutrient_id);