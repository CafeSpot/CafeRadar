from fastapi import APIRouter

from src.backend.database import *
from src.backend.models.userModel import *

router = APIRouter(prefix='/users/auth')


@router.post("/",)
async def signup(user: UserModel = Body(...)):
    new_user = await user_collection.insert_one(
        user.model_dump(by_alias=True, exclude=["id"])
    )
    created_user = await user_collection.find_one({
        "_id": new_user.inserted_id
    })
    created_user["_id"] = str(created_user["_id"])
    return created_user
