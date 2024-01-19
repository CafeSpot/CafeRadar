from fastapi import APIRouter, HTTPException, Depends, Body

from src.backend.database import cafe_collection
from src.backend.models.cafeModel import *

router = APIRouter(prefix='/cafe')

@router.get("/",response_model=CafeModel)
async def cafe():
    cafe = await cafe_collection.find_one({"cafeId" : "1"})
    return CafeModel(cafe)