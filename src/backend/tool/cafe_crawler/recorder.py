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

if __name__ == '__main__':
    #parser = argparse.ArgumentParser()
    #parser.add_argument('-id', "--id", action='store_true', help="call the google map api to get more place_ids(please ensure add new keyword before run)")
    #args = parser.parse_args()

    place_ids = []
    place_details = {}
    cafe_types = {}

    ### [get place_id] import the "cafe_place_ids.json" file ([place_id])
    if os.path.exists('resource/cafe_place_ids.json'):
        with open('resource/cafe_place_ids.json', 'r') as file:
            place_ids = json.load(file)

    ### [get place_detail] import the "cafe_place_details.json" file ({place_id: {...}}
    if os.path.exists('resource/cafe_place_details.json'):
        with open('resource/cafe_place_details.json', 'r') as file:
            place_details = json.load(file)


    for cafe_id in place_details:
        for cafe_type in place_details[cafe_id]["types"]:
            if cafe_type not in cafe_types:
                cafe_types[cafe_type] = 0
            cafe_types[cafe_type]+=1

    for index, cafe_type in enumerate(cafe_types):
        print(f"{index}. {cafe_type}: {cafe_types[cafe_type]}")

        for cafe_id in place_details:
            if cafe_type in place_details[cafe_id]["types"]:
                print(f"    {place_details[cafe_id]["displayName"]["text"]},  {place_details[cafe_id]["id"]}")

    
    

    





