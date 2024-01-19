from fastapi import APIRouter

from src.backend.database import *
from src.backend.models.userModel import *
from src.backend.functions.hasher import Hasher

router = APIRouter(prefix='/users')


@router.post("/signup",)
async def signup(user: UserModel = Body(...)):
    # Check if email is already in use
    existing_email = await user_collection.find_one({
        "email": user.email
    })
    if existing_email:
        raise HTTPException(status_code=400, detail="Email already registered")

    # Check if username is already in use
    existing_username = await user_collection.find_one({
        "username": user.username
    })
    if existing_username:
        raise HTTPException(status_code=400, detail="Username already taken")
    
    hashed_password = Hasher.get_password_hash(user.password)
    user.password = hashed_password

    new_user = await user_collection.insert_one(
        user.model_dump(by_alias=True, exclude=["id"])
    )
    created_user = await user_collection.find_one({
        "_id": new_user.inserted_id
    })
    created_user["_id"] = str(created_user["_id"])
    return created_user


@router.post("/update",)
async def update(updated_user: UpdateUserModel = Body(...)):
    # get existing_user data
    existing_user = await user_collection.find_one({
        "username": updated_user.username 
    })

    # if update includes email, check if email is already in use
    if existing_user["email"] != updated_user.email:
        existing_email = await user_collection.find_one({
            "email": updated_user.email,
            "username": {"$ne": existing_user["username"]}
        })
        if existing_email:
            raise HTTPException(status_code=400, detail="Email already registered")

    # update
    await user_collection.update_one(
        {"username": existing_user["username"]},
        {"$set": updated_user.model_dump(exclude_unset=True)}
    )
    updated_user = await user_collection.find_one({
        "username": updated_user.username
    })
    updated_user["_id"] = str(updated_user["_id"])
    return updated_user