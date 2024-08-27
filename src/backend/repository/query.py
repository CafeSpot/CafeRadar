import os
import time
import json
from bson import ObjectId 
from src.backend.repository.connection import user_collection, cafe_collection
#import motor.motor_asyncio
'''
    [Query.get_cafe_detail(id)] get the detail infos of id from DB
        * Parameter: cafe's ID (string)
        * Return: cafe's infos in json
    NOTE: OPTIMIZE!!! Using "list(documents)" can be time-consuming, especially when the server needs to 
    process a large volume of data. To reduce latency, consider using the nextToken (pagination token) 
    method. This approach allows you to fetch a limited number of documents at a time, using the token 
    to retrieve the next batch, thereby improving efficiency and reducing the overall time cost.
'''
async def get_cafe_detail(ids):
    query = {"id": {"$in": ids}}
    cursor = cafe_collection.find(query)
    documents = await cursor.to_list(length=100)

    return list(documents)


'''
    [geospatial indexing and queries]:
    * [GeoJSON] https://blog.csdn.net/weixin_55633225/article/details/129948116
    * [2dsphere index] https://deepinout.com/mongodb/mongodb-questions/34_mongodb_does_anyone_know_a_working_example_of_2dsphere_index_in_pymongo.html

    [Regex Query]:
    * "$regex": keyword searches for documents where the name field contains the specified keyword.
    * "$options": "i" makes the search case-insensitive, so it will match "Coffee", "coffee", "COFFEE", etc.
    NOTE: Regular expression searches can be slow, especially if the collection is large. 
'''
async def get_cafe_search(lat=0, lon=0, search_dis=5000, search_text="", search_types=[], nextToken=0):
    query = {}
    limit = 100

    print("search_text: ",search_text)
    if lat!=0 and lon!=0:
        query["location_geojson"] = {
                "$near": {
                    "$geometry": {
                            "type": "Point",
                            "coordinates": [lon, lat]
                        },
                    "$maxDistance": search_dis
                }
            }
    if search_text != "":
        query["displayName.text"] = {
                "$regex": search_text, 
                "$options": "i"
            }
    if not search_types:
        query["displayName.text"] = {
                "$regex": search_text, 
                "$options": "i"
            }
    cursor = cafe_collection.find(query).sort("_id").skip(nextToken).limit(limit)
    documents = await cursor.to_list(length=100)

    if len(documents)==limit:
        return documents, nextToken+1
    else:
        return documents, None


'''
    [Query.cafes_convertor(cafe_db)] convert and filter the fields of cafe_db from DB format to required format
        * Parameter: cafe's infos in json from DB
        * Return: 
'''
def cafes_convertor(cafes_db):
    def convertor(cafe_db):
        cafe = {}
        cafe["place_id"] = cafe_db.get("id", "")
        cafe["name"] = cafe_db.get("displayName", {}).get("text", "no name")
        cafe["tags"] = cafe_db.get("types", [])
        cafe["address"] = cafe_db.get("formattedAddress", "")
        cafe["location"] = cafe_db.get("location", None)
        cafe["time"] = cafe_db.get("regularOpeningHours", None)
        cafe["phone"] = cafe_db.get("internationalPhoneNumber", "")
        cafe["google_rating"] = cafe_db.get("rating", None)
        cafe["googleMapsUri"] = cafe_db.get("googleMapsUri", "")
        cafe["websiteUri"] = cafe_db.get("websiteUri", "")
        

        # goole map api return "photo" which requires addtional images request
        # hear, "image" the actual image 
        cafe["images"] = cafe_db.get("images", [])

        if cafe_db.get("servesBreakfast",False):
            cafe["tags"].append("breakfast")
        if cafe_db.get("servesLunch",False):
            cafe["tags"].append("lunch")
        if cafe_db.get("servesDinner",False):
            cafe["tags"].append("dinner")
        if cafe_db.get("servesBrunch",False):
            cafe["tags"].append("brunch")
        if cafe_db.get("servesVegetarianFood",False):
            cafe["tags"].append("vegetarianFood")
        if cafe_db.get("servesDessert",False):
            cafe["tags"].append("dessert")
        if cafe_db.get("servesCoffee",False):
            cafe["tags"].append("coffee")
        #cafe["reviews"] = cafe_db["reviews"]
        return cafe

    cafes = [convertor(cafe_db) for cafe_db in cafes_db]

    return cafes