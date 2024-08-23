import requests
from dotenv import load_dotenv
import os
from pymongo import MongoClient, errors
import time
import json
import argparse
from bson import ObjectId 

### load the env variables
load_dotenv()

### request the cafe info from google map api
api_key = os.getenv("GOOGLE_API_KEY")

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

    [purpose]: using the a list of "place id" got from "google_map_testSearch_post()" to retrive the detail info of the cafe.

    [parameter]:
        1. A list of the place ID (["place_id"])
    [return]:
    
    NOTE: 
'''
def google_map_placeDetail_get(place_ids, place_details, limit_times):

    print(f"[google_map_placeDetail_get] begin! there are {len(place_details)} place details NOW.")
    len_old = len(place_details)

    request_times = 0
    for index, place_id in enumerate(place_ids):
        if place_id not in place_details:
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

    ### [google_map_placeDetail_get] write the place_ids to the file named "cafe_place_details.json" 
    with open('resource/cafe_place_details.json', 'w') as file:
        json.dump(place_details, file, indent=4)

    print(f"[google_map_placeDetail_get] finish! there are {len(place_details)} palce details. Increase {len(place_details)-len_old}.")
    print("")
    return place_details


def google_map_querys():
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


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-id', "--id", action='store_true', help="call the google map api to get more place_ids(please ensure add new keyword before run)")
    parser.add_argument('-detail', "--detail", action='store_true', help="costly command!!! call the google map api to get more place_detail(please ensure add new id before run)")
    parser.add_argument('-detail_limit', "--detail_limit", type=int, default=5, help="limit the google api palceDetail requesr times per program yuns")
    parser.add_argument('-push_db', "--push_db", action='store_true', help="push the cafe detail infos to DB")
    args = parser.parse_args()

    ### [get place_id] import the "cafe_place_ids.json" file ([place_id])
    if os.path.exists('resource/cafe_place_ids.json'):
        with open('resource/cafe_place_ids.json', 'r') as file:
            data = json.load(file)
            place_ids = set(data)
    else:
        place_ids = set()

    ### [get place_detail] import the "cafe_place_details.json" file ({place_id: {...}})
    if os.path.exists('resource/cafe_place_details.json'):
        with open('resource/cafe_place_details.json', 'r') as file:
            place_details = json.load(file)
    else:
        place_details = {}


    if args.id:
        ### [get place_id] generate querys
        querys = google_map_querys()

        ### [get place_id] request the place_ids with the keywords(querys)
        place_ids = google_map_testSearch_post(querys, api_key, place_ids)

    if args.detail:
        ### [get place_detail] request the place detail info with the place_ids
        limit_times = args.detail_limit
        place_details = google_map_placeDetail_get(place_ids, place_details, limit_times)
    
    if args.push_db:
        ### connect to our monogoDB server
        mongodb_url = os.getenv("MONGODB_URL")
        client = MongoClient(mongodb_url)

        db = client["info"]
        cafe_collection = db["cafe"]

        count_old = cafe_collection.count_documents({})
        print(f"[push_db] there are {count_old} documents in DB")

        #cafe_collection.create_index([("id", 1)], unique=True)  #************

        place_details_list = [place_details[palce_id] for palce_id in place_details]

        try:
            # Insert documents, skipping duplicates
            cafe_collection.insert_many(place_details_list, ordered=False)
            print("Documents inserted successfully, skipping duplicates.")
        except errors.BulkWriteError as bwe:
            print(f"{len(bwe.details['writeErrors'])} documents were skipped due to duplication.")
            # for error in bwe.details['writeErrors']:
            #     print(f"Duplicate document: {error['op']['id']}")

        count = cafe_collection.count_documents({})
        print(f"[push_db] there are {count} documents in DB, Increase {count-count_old} documents")





