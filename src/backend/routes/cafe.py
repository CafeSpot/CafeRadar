from fastapi import APIRouter, HTTPException, Depends, Body

from src.backend.database import cafe_collection
from src.backend.models.cafeModel import *

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