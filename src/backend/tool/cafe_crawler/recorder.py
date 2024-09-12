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
            data = json.load(file)
            place_ids_delete = data["delete"]
            place_ids = data["all"]

    ### [get place_detail] import the "cafe_place_details.json" file ({place_id: {...}}
    if os.path.exists('resource/cafe_place_details.json'):
        with open('resource/cafe_place_details.json', 'r') as file:
            place_details = json.load(file)


    for cafe_id in place_details:
        for cafe_type in place_details[cafe_id]["types"]:
            if cafe_type not in cafe_types:
                cafe_types[cafe_type] = 0
            cafe_types[cafe_type]+=1

    nonrelation = ["event_venue","sushi_restaurant","japanese_restaurant","pizza_restaurant","political","brazilian_restaurant","hamburger_restaurant","convenience_store","atm","finance","thai_restaurant","meal_delivery","gift_shop","korean_restaurant","seafood_restaurant","chinese_restaurant","vietnamese_restaurant","grocery_store","ramen_restaurant","bar","farm","supermarket","bed_and_breakfast","lodging","hotel","fast_food_restaurant","gym","spanish_restaurant","wedding_venue","banquet_hall","ice_cream_shop","night_club","playground","amusement_center","market","liquor_store","campground","jewelry_store","mexican_restaurant","steak_house","fitness_center","sports_complex","private_guest_room","clothing_store","indian_restaurant","amusement_park","pharmacy","parking","hair_salon","hair_care","beauty_salon","shopping_mall","department_store","movie_theater"]
    #for index, cafe_type in enumerate(cafe_types):
    
    #for index, cafe_type in enumerate(nonrelation):
        #print(f"{index}. {cafe_type}: {cafe_types[cafe_type]}")
        #print(f"\"{cafe_type}\", ", end="")
        #print(f"\"{cafe_type}\",",end="")

        #for cafe_id in place_details:
        #    if cafe_type in place_details[cafe_id]["types"]:
        #        print(f"    {place_details[cafe_id]["displayName"]["text"]},  {place_details[cafe_id]["id"]}")
    '''
        尋路Cafe, ChIJWeK9sSIwaDQRfPLCG5BRG4o
    '''
        
    
    

    





