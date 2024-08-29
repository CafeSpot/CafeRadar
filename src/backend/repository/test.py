import asyncio
from src.backend.repository.query import *

async def test_get_cafe_search():
    cafes = await get_cafe_search()

    print("get element: ",len(cafes))
    print(cafes[0]["location"])
    lon = cafes[0]["location"]["longitude"]
    lat = cafes[0]["location"]["latitude"]
    print("")

    cafes = await get_cafe_search(search_text="cafe")
    print(len(cafes))
    for cafe in cafes:
        print(cafe["displayName"]["text"])
    


asyncio.run(test_get_cafe_search())