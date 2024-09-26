from src.backend.repository.connection import cafe_collection
from src.backend.repository.query import *
from fastapi import APIRouter, HTTPException, Depends, Body, Query, Request

async def cafes_randomly(lat: float, lon: float, n: int = 6, max_distance: int = 1000000000):
    geo_query = {
        "location_geojson": {
            "$geoWithin": {
                "$centerSphere": [
                    [lon, lat],
                    max_distance / 6378137  # Convert meters to radians (Earth radius ~6378.137 km)
                ]
            }
        }
    }
    cafes = await cafe_collection.aggregate([
        {"$match": geo_query},
        {"$project": {"_id": 0}},
        {"$sample": {"size": n}}
    ]).to_list(length=n)
    return cafes

async def recommands_randomly(lat: float, lon: float, num: int = 10):
    titles = ["老闆會打人","咖啡很苦","只能坐地上","沒有賣咖啡","買牛奶送咖啡","坐太久會被打","甜點很苦","發酵咖啡","沒有很好喝","週休八日"]
    recommands = []
    for i in range(num):
        recommand = {}
        recommand["cafes"] = await cafes_randomly(lat, lon)
        recommand["title"] = titles[i]
        recommand["explain"] = "???"
        recommands.append(recommand)
    return recommands


async def recommand_base(request: Request, lat: float, lon: float):
    user = await db_find_user(request.state.user["uid"])
    #sys_recommand = await db_get_sysRecommand()
    #config = load(config_file_recommand_strategy)

    # genegrate the recommand randomly
    cafes = await recommands_randomly(lat, lon)
    return cafes