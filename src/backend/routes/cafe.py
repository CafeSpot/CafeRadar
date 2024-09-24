from fastapi import APIRouter, HTTPException, Depends, Body, Query
from fastapi.responses import StreamingResponse
from src.backend.repository.connection import cafe_collection
from src.backend.models.cafeModel import *
from src.backend.repository.query import *

router = APIRouter(prefix='/cafe')


@router.get("/", response_model=CafeModel)
async def getCafeInfo(place_id):
    cafe = await cafe_collection.find_one({"place_id": place_id})

    if cafe is None:
        raise HTTPException(status_code=404, detail="Cafe not found")

    return CafeModel(**cafe)


@router.post("/", response_model=CafeModel)
async def postCafeInfo(response: dict):
    result = response.get("result", {})
    cafe_info = CafeModel(
        place_id=result.get("place_id", ""),
        images=[photo.get("photo_reference", "") for photo in result.get("photos", [])],
        opening_time=result.get("opening_hours", {}).get("weekday_text", [""])[0],
        end_time=result.get("opening_hours", {}).get("weekday_text", [""])[-1]
    )
    return CafeModel(**cafe_info)

@router.get("/search/")
async def search_items(
    lon: Optional[float] = Query(None, description="longitude of the require"),
    lat: Optional[float] = Query(None, description="latitude of the require"),
    dis: Optional[float] = Query(1000, description="max search distances"),
    text: Optional[str] = Query(None, description="search text"),
    types: Optional[List[str]] = Query([], description="List of types to filter by"),
    nextToken: Optional[int] = Query(None, description="search text"),
):
    print(f"lon:{lon}, lat:{lat}, dis:{dis}, text:{text}, types:{types}, nextToken:{nextToken}")
    query = {
        "lon": lon,
        "lat": lat,
        "dis": dis,
        "text": text,
        "types": types,
        "nextToken": nextToken
    }
    cafes_dbs, nextToken = await db_get_cafe_search(lon=lon, lat=lat, search_dis=int(dis), search_text=text, search_types=types, nextToken=nextToken)
    cafes = [cafes_convertor(query, cafes_db) for cafes_db in cafes_dbs]

    response = {
        "nextToken": nextToken,
        "data": cafes
    }
    print(f"send {len(cafes)} cafes")

    return response

@router.get("/img/{imageLink}")
async def get_image(imageLink: str):
    image = await db_get_cafe_image(imageLink)
    if image:
        return StreamingResponse(image, media_type="image/jpeg")
    else:
        raise HTTPException(status_code=404, detail="Image not found")