import os
import time
import json
import math
from bson import ObjectId 
from datetime import datetime
from src.backend.repository.connection import user_collection, cafe_collection, fs

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
    if lat and lon:
        query["location_geojson"] = {
                "$near": {
                    "$geometry": {
                            "type": "Point",
                            "coordinates": [lon, lat]
                        },
                    "$maxDistance": search_dis
                }
            }
    if search_text and search_text!="":
        query["name.text"] = {
                "$regex": search_text, 
                "$options": "i"
            }
    '''
    if not search_types:
        query["name.text"] = {
                "$regex": search_text, 
                "$options": "i"
            }
    '''
    if nextToken:
        cursor = cafe_collection.find(query).sort("_id").skip(nextToken).limit(limit)
        documents = await cursor.to_list(length=limit)

        if len(documents)==limit:
            return documents, nextToken+1
        else:
            return documents, None
    else:
        cursor = cafe_collection.find(query).sort("_id")
        documents = await cursor.to_list(length=None)

        return documents, None 


'''
    retrive the image
'''
async def get_cafe_image(imageLink):
    try:
        # Retrieve the image from GridFS by its _id
        grid_out = await fs.open_download_stream(ObjectId(imageLink))
        return grid_out
    except Exception as e:
        print(f"Error retrieving {imageLink} image: {e}")
        return None



'''
    [Query.cafes_convertor(cafe_db)] convert and filter the fields of cafe_db from DB format to required format
        * Parameter: cafe's infos in json from DB
        * Return: 
'''
def cafes_convertor(query, cafe_db):
    def covert_tags(tags_db):
        table = ["coffee","restaurant", "food", "store", "cafe", "coffee_shop", "vegan", "vegan_restaurant", "health", "brunch", "sandwich", "breakfast", "brunch_restaurant", "breakfast_restaurant", "sandwich_shop", "bakery", "book_store", "book"]
        tags = []
        for t in tags_db:
            if t in table:
                tags.append(t)
        return tags

    def convert_times(times):
        if times:
            '''
            times = {
                "Sun": {"open":"", "close":""},
                "Mon": {"open":"", "close":""},
                "Tue": {"open":"", "close":""},
                "Wed": {"open":"", "close":""},
                "Thu": {"open":"", "close":""},
                "Fri": {"open":"", "close":""},
                "Sat": {"open":"", "close":""},
            }
            '''
            weekday_mapping = {
                0: "Mon",
                1: "Tue",
                2: "Wed",
                3: "Thu",
                4: "Fri",
                5: "Sat",
                6: "Sun"
            }
            now = datetime.now()
            week = now.weekday()
            return times[weekday_mapping[week]]["open"], times[weekday_mapping[week]]["close"]
        else:
            return None, None

    def convert_distance(lon1, lat1, lon2, lat2):
        R = 6371.0
        lat1 = math.radians(lat1)
        lon1 = math.radians(lon1)
        lat2 = math.radians(lat2)
        lon2 = math.radians(lon2)
        dlon = lon2 - lon1
        dlat = lat2 - lat1
        a = math.sin(dlat / 2)**2 + math.cos(lat1) * math.cos(lat2) * math.sin(dlon / 2)**2
        c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
        distance = R * c
        return distance

    cafe = {}

    openTime, closeTime = convert_times(cafe_db.get("times",None))
    tags = covert_tags(cafe_db.get("tags",[]))
    imageLinks = [ "http://127.0.0.1:8000/cafe/img/"+imageLink for imageLink in cafe_db["imageLinks"]]

    cafe["cafeId"] = cafe_db.get("placeId","")
    cafe["name"] = cafe_db.get("name","")
    cafe["openTime"] = openTime
    cafe["closeTime"] = closeTime
    cafe["imageLinks"] = imageLinks
    cafe["tags"] = tags
    cafe["lat"]= cafe_db.get("lat",0.0)
    cafe["lon"]= cafe_db.get("lat",0.0)
    cafe["distance"] = convert_distance(cafe["lon"], cafe["lat"], query["lon"], query["lat"])
    cafe["commentIds"] = cafe_db.get("commentIds",[])
    cafe["envRate"] = cafe_db.get("envRate",None)
    cafe["spaceScore"] = cafe_db.get("spaceScore",None)
    cafe["lightScore"] = cafe_db.get("lightScore",None)
    cafe["crowdRate"] = cafe_db.get("crowdRate",None)
    cafe["plugNum"] = cafe_db.get("plugNum",None)
    cafe["seatNum"] = cafe_db.get("seatNum",None)
    cafe["address"] = cafe_db.get("address",None)
    cafe["addressLink"] = cafe_db.get("addressLink",None)
    cafe["googleMapLink"] = cafe_db.get("googleMapLink",None)
    cafe["phone"] = cafe_db.get("phone",None)
    cafe["link"] = cafe_db.get("link",None)
    cafe["ig"] = cafe_db.get("ig",None)
    cafe["igLink"] = cafe_db.get("igLink",None)
    cafe["fb"] = cafe_db.get("fb",None)
    cafe["fbLink"] = cafe_db.get("fbLink",None)

    return cafe