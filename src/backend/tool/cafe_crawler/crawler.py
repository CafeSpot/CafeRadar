import requests
from dotenv import load_dotenv
import os
from pymongo import MongoClient, errors
import time
import json
import argparse
from bson import ObjectId 
import gridfs
import random

### load the env variables
load_dotenv()

### Google Map APi
api_key = os.getenv("GOOGLE_API_KEY")
print(api_key)

### MongoDB
mongodb_url = os.getenv("MONGODB_URL")
client = MongoClient(mongodb_url)
print(f"mongodb_url: {mongodb_url}")
db = client["info"]
cafe_collection = db["cafe"]
fs = gridfs.GridFS(db)

'''
    new version of "map/place api" for "text search". It uses the http post instead of get to request the place informations
    ref: https://developers.google.com/maps/documentation/places/web-service/text-search?hl=zh-tw

    [purpose]: This function only retrives the "place.id" addtional infomation would arise the api cost

    [consideration]: there are a lot of cafes. However, the Google Map API always returns part of the data, which 
    requires us to request multiple times, resulting in a large duplication of cafe info. To get each cafe's 
    information as much as possible but keep the API costs low, we first search the cafe's place_id by the text 
    search, which is free of cost, then we delete the duplicated one, and lastly, using this non-duplicated place 
    id to retrieve the store information by place detail API.

    [parameter]:
        1. querys: keyword the list
        2. api_key
        3. place_ids: data type "set", used to record the palce id without the duplication
    [return]:
        place_ids: data type "set", used to record the palce id without the duplication
'''
def google_map_testSearch_post(querys, api_key, place_ids):
    place_ids = set(place_ids)

    print(f"[google_map_testSearch_post] begin! there are {len(place_ids)} unique place IDs NOW.")
    len_old = len(place_ids)

    url = "https://places.googleapis.com/v1/places:searchText"
    headers = {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": api_key,
        "X-Goog-FieldMask": "places.id,nextPageToken"
    }

    for index, query in enumerate(querys):
        nextPageToken = ""
        while(1):
            if nextPageToken == "":
                payload = {
                    "textQuery": query
                }
            else:
                payload = {
                    "textQuery": query,
                    "pageToken": nextPageToken
                }

            # Send the POST request
            response = requests.post(url, json=payload, headers=headers)

            # Check the status code and print the response
            if response.status_code == 200:
                places_data = response.json()

                if "places" in places_data:
                    for place in places_data["places"]:
                        place_ids.add(place['id'])
                else:
                    print(f"    {query} increase {len(place_ids)} items ~ SUCCESSFUL")
                    break

                if "nextPageToken" in places_data:
                    nextPageToken = places_data["nextPageToken"]
                else:
                    print(f"    {query} increase {len(place_ids)} items ~ SUCCESSFUL")
                    break
            else:
                print(f"{query} ~ ERROR")
                print("Response content:", response.content)

    place_ids = list(place_ids)

    ### [get place_id] write the place_ids to the file named "cafe_place_ids.json" 
    with open('resource/cafe_place_ids.json', 'w') as file:
        json.dump(place_ids, file, indent=4)
    
    print(f"[google_map_testSearch_post] finish! there are {len(place_ids)} unique place IDs. Increase {len(place_ids)-len_old}.")
    print("")
    return place_ids

'''
    new version of "map/place api" for "place datail". It uses the http get method with placae id to get the store information
    ref: https://developers.google.com/maps/documentation/places/web-service/place-details?hl=zh-tw

    [purpose]: using the list of "place id" got from "google_map_testSearch_post()" to retrive the detail info of the cafe.

    [parameter]:
        1. A list of the place ID (["place_id"])
    [return]:
    
    NOTE: 
'''
def google_map_placeDetail_get(place_ids, place_ids_delete, place_details, limit_times):
    print(f"[google_map_placeDetail_get] begin! there are {len(place_details)} place details NOW.")
    len_old = len(place_details)

    request_times = 0
    for index, place_id in enumerate(place_ids):
        if place_id not in place_details and place_id not in place_ids_delete:
            url = f"https://places.googleapis.com/v1/places/{place_id}"

            headers = {
                "Content-Type": "application/json",
                "X-Goog-Api-Key": api_key,
                "X-Goog-FieldMask": "id,name,photos,addressComponents,adrFormatAddress,formattedAddress,location,plusCode,shortFormattedAddress,types,viewport,accessibilityOptions,businessStatus,displayName,googleMapsUri,iconBackgroundColor,iconMaskBaseUri,primaryType,primaryTypeDisplayName,subDestinations,utcOffsetMinutes,currentOpeningHours,currentSecondaryOpeningHours,internationalPhoneNumber,nationalPhoneNumber,priceLevel,rating,regularOpeningHours,regularSecondaryOpeningHours,userRatingCount,websiteUri,allowsDogs,curbsidePickup,delivery,dineIn,editorialSummary,evChargeOptions,fuelOptions,goodForChildren,goodForGroups,goodForWatchingSports,liveMusic,menuForChildren,parkingOptions,paymentOptions,outdoorSeating,reservable,restroom,reviews,servesBeer,servesBreakfast,servesBrunch,servesCocktails,servesCoffee,servesDessert,servesDinner,servesLunch,servesVegetarianFood,servesWine,takeout",
                "languageCode": "zh-TW"
            }

            response = requests.get(url, headers=headers)

            if response.status_code == 200:
                places_data = response.json()
                place_details[place_id] = places_data
            else:
                print("ERROR Response content:", response.content)

            ### prevent the request times exceeds limit_times
            if request_times == limit_times:
                break
            request_times += 1

        if index%100 == 0:
            print(f"    increase {request_times} details")
            with open('resource/cafe_place_details.json', 'w') as file:
                json.dump(place_details, file, indent=4)
    
    ###
    for id in place_ids_delete:
        if id in place_details:
            del place_details[id]

    ### [google_map_placeDetail_get] write the place_ids to the file named "cafe_place_details.json" 
    with open('resource/cafe_place_details.json', 'w') as file:
        json.dump(place_details, file, indent=4)

    print(f"[google_map_placeDetail_get] finish! there are {len(place_details)} palce details. Increase {len(place_details)-len_old}.")
    print("")
    return place_details

'''
    new version of "map/place api" for "Place Photo". It uses the http get method with the photo name to get the photo
    ref: https://developers.google.com/maps/documentation/places/web-service/place-photos?hl=zh-tw
    [purpose]: retrieve the place photos of the place
    [parameter]: place detail dictionary(obtain from "google_map_placeDetail_get()")
    [return]: return the list of the images
'''
def google_map_images_get(cafes, limit_times):
    request_times = 0
    for id, cafe in cafes.items():
        if "photos" in cafe:
            print(f"download cafe'{cafe["displayName"]["text"]} photos ~ ", end="")
            for index, photo in enumerate(cafe["photos"]):
                if index==4:
                    break
                if not os.path.isfile(f"resource/img/{cafe["id"]}/{index}.jpg"):
                    request_times += 1
                    url = f"https://places.googleapis.com/v1/{photo["name"]}/media?maxHeightPx={photo["heightPx"]}&maxWidthPx={photo["widthPx"]}&key={api_key}"
                            #https://places.googleapis.com/v1/NAME/media?key=API_KEY&PARAMETERS
                    response = requests.get(url)

                    if response.status_code == 200:
                        os.makedirs(f"resource/img/{cafe["id"]}", exist_ok=True)
                        with open(f"resource/img/{cafe["id"]}/{index}.jpg", "wb") as file:
                            file.write(response.content)
                    else:
                        print(f"Error: {response}")
            print("done!")
            if request_times>=limit_times:
                break

def google_map_querys_generator():
    ### [google_map_querys] import the "cafe_keyword.json" file
    if os.path.exists('resource/cafe_keyword.json'):
        with open('resource/cafe_keyword.json', 'r', encoding='utf-8') as file:
            keywords = json.load(file)
            keyword_locations = keywords["location"]
            keyword_classes = keywords["class"]

    querys = []
    for city in keyword_locations:
        for district in keyword_locations[city]:
            for village in keyword_locations[city][district]:
                for keyword_class in keyword_classes:
                    querys.append(f"{city}{district}{village}的{keyword_class}")
    return querys

def push_image_db(cafeId):
    image_ids = []
    directory = f"resource/img/{cafeId}"
    
    if os.path.isdir(directory):
        for index, filename in enumerate(os.listdir(directory)):
            file_path = os.path.join(directory, filename)
            with open(file_path, "rb") as file:
                imagename = f"img_{cafeId}_{index}.jpg"
                image = fs.find_one({"filename": imagename})
                if image:
                    image_id = image._id
                else:
                    image_id = fs.put(file, filename=imagename)
                image_ids.append(str(image_id))
    return image_ids


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-google_id', "--google_id", action='store_true', help="call the google map api to get more place_ids(please ensure add new keyword before run)")
    parser.add_argument('-google_image', "--google_image", action='store_true', help="call the google map api to get photo")
    parser.add_argument('-google_detail', "--google_detail", action='store_true', help="costly command!!! call the google map api to get more place_detail(please ensure add new id before run)")
    parser.add_argument('-detail_limit', "--detail_limit", type=int, default=5, help="limit the google api palceDetail request times per program run")
    parser.add_argument('-image_limit', "--image_limit", type=int, default=5, help="limit the google api palcePhoto request times per program run")
    parser.add_argument('-push_db', "--push_db", action='store_true', help="push the cafe detail infos to DB")
    parser.add_argument('-update_db', "--update_db", action='store_true', help="modify the DB")
    parser.add_argument('-test', "--test", action='store_true', help="test the function")
    parser.add_argument('-delete', "--delete", action='store_true', help="test cafe data in DB")
    args = parser.parse_args()

    ### [get place_id] import the "cafe_place_ids.json" file ([place_id])
    if os.path.exists('resource/cafe_place_ids.json'):
        with open('resource/cafe_place_ids.json', 'r') as file:
            data = json.load(file)
            place_ids = data["all"]
            place_ids_delete = data["delete"]
    else:
        place_ids = []

    ### [get place_detail] import the "cafe_place_details.json" file ({place_id: {...}})
    if os.path.exists('resource/cafe_place_details.json'):
        with open('resource/cafe_place_details.json', 'r') as file:
            place_details = json.load(file)
    else:
        place_details = {}


    if args.google_id:
        ### [get place_id] generate querys
        querys = google_map_querys_generator()

        ### [get place_id] request the place_ids with the keywords(querys)
        place_ids = google_map_testSearch_post(querys, api_key, place_ids)

    if args.google_detail:
        ### [get place_detail] request the place detail info with the place_ids
        limit_times = args.detail_limit
        place_details = google_map_placeDetail_get(place_ids, place_ids_delete, place_details, limit_times)
    

    if args.push_db:
        def covert(cafe):
            def location_to_GeoJSON(location):
                '''
                    Convert the location field from Google's format to GeoJSON. GeoJSON is especially useful 
                    for MongoDB's geospatial indexing and search capabilities.
                    ref: https://blog.csdn.net/weixin_55633225/article/details/129948116
                    
                    * Format:
                        1. Google: {"longitude": xxx, "latitude": yyy}
                        2. GeoJSON: {"type": "Point", "coordinates": [xxx, yyy] }
                '''
                lon = location.get('longitude', 0.0)
                lat = location.get('latitude', 0.0)
                return { "type": "Point", "coordinates": [lon, lat]}

            def convert_openHours(openHours):
                openHours_new = {
                    "Sun": {"open":"", "close":""},
                    "Mon": {"open":"", "close":""},
                    "Tue": {"open":"", "close":""},
                    "Wed": {"open":"", "close":""},
                    "Thu": {"open":"", "close":""},
                    "Fri": {"open":"", "close":""},
                    "Sat": {"open":"", "close":""},
                }
                if openHours:
                    for day in openHours["periods"]:
                        if "open" in day:
                            open = f"{day["open"]["hour"]:02}:{day["open"]["minute"]:02}"
                        else:
                            open = ""
                        if "close" in day:
                            close = f"{day["close"]["hour"]:02}:{day["close"]["minute"]:02}"
                        else:
                            close = ""
                        
                        if day["open"]["day"]==0:
                            openHours_new["Sun"] = {"open":open, "close":close}
                        elif day["open"]["day"]==1:
                            openHours_new["Mon"] = {"open":open, "close":close}
                        elif day["open"]["day"]==2:
                            openHours_new["Tue"] = {"open":open, "close":close}
                        elif day["open"]["day"]==3:
                            openHours_new["Wed"] = {"open":open, "close":close}
                        elif day["open"]["day"]==4:
                            openHours_new["Thu"] = {"open":open, "close":close}
                        elif day["open"]["day"]==5:
                            openHours_new["Fri"] = {"open":open, "close":close}
                        else:
                            openHours_new["Sat"] = {"open":open, "close":close}
                return openHours_new
            
            cafe_new = {}

            cafe_new["cafeId"] = cafe["id"]
            cafe_new["placeId"] = cafe["id"]
            cafe_new["name"] = cafe.get("displayName",{}).get("text","")
            cafe_new["times"] = convert_openHours(cafe.get("regularOpeningHours", None))
            cafe_new["imageLinks"] = []
            cafe_new["tags"] = cafe["types"]
            cafe_new["lat"]= cafe.get("location", {}).get("latitude", 0.0)
            cafe_new["lon"]= cafe.get("location", {}).get("longitude", 0.0)
            cafe_new["commentIds"] = []
            cafe_new["envRate"] = cafe.get("rating", None)
            cafe_new["spaceScore"] = None
            cafe_new["lightScore"] = None
            cafe_new["crowdRate"] = random.randint(1, 5)
            cafe_new["plugNum"] = None
            cafe_new["seatNum"] = None
            cafe_new["address"] = cafe.get("shortFormattedAddress", cafe.get("formattedAddress", None))
            cafe_new["addressLink"] = cafe.get("addressLink", None)
            cafe_new["googleMapLink"] = cafe.get("googleMapsUri", None)
            cafe_new["phone"] = cafe.get("internationalPhoneNumber", None)
            cafe_new["link"] = cafe.get("websiteUri", None)
            cafe_new["ig"] = None
            cafe_new["igLink"] = None
            cafe_new["fb"] = None
            cafe_new["fbLink"] = None
            
            cafe_new["location_geojson"]= location_to_GeoJSON(cafe.get("location", {}))
            return cafe_new
        
        ### creat the index
        cafe_collection.create_index([("cafeId", 1)], unique=True)
        cafe_collection.create_index([("location_geojson", "2dsphere")])

        # show the number of documents in db
        count_old = cafe_collection.count_documents({})
        print(f"[push_db] there are {count_old} documents in DB")

        for place_detail_google in place_details:
            place_detail = covert(place_details[place_detail_google])

            # push the image to fs
            place_detail["imageLinks"] = push_image_db(place_detail["cafeId"])

            # push the cafe info to db
            try:
                result = cafe_collection.insert_one(place_detail)
                _id = result.inserted_id
            except errors.DuplicateKeyError as e:
                _id = e.details

            print(f"add the {place_detail["name"]} to the DB. *{len(place_detail["imageLinks"])} images")

        with open('resource/cafe_place_details.json', 'w') as file:
            json.dump(place_details, file, indent=4)
        
        count = cafe_collection.count_documents({})
        print(f"[push_db] there are {count} documents in DB, Increase {count-count_old} documents")

    if args.update_db:
        print("no update")
    
    if args.delete:
        count = cafe_collection.count_documents({})
        print(f"[push_db] there are {count} documents in DB")
        cafe_collection.drop()
        count = cafe_collection.count_documents({})
        print(f"[push_db] there are {count} documents in DB")

        fs = gridfs.GridFS(db)
        files = fs.find()
        for file in files:
            fs.delete(file._id)

    if args.test:
        '''
            add the image
        '''
        print(f"----- test 0-1 -----")
        documents = cafe_collection.find({"id": "ChIJ_3959Sk1aDQRP80xAccU58I"})
        index=0
        print(f"----- test 0-2-----")
        for doc in documents:
            if index==1:
                break
            #add_image(doc, db, cafe_collection)

            print(doc["images"])
            fs = gridfs.GridFS(db)
            image = fs.find_one(ObjectId(doc["images"][0]))
            index += 1

        

    





