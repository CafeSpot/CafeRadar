from fastapi import APIRouter, HTTPException, Depends, Body

from src.backend.database import *
from src.backend.models.userModel import *
from src.backend.models.tokenModel import *
from src.backend.functions.hasher import Hasher
from src.backend.functions.token import *

router = APIRouter(prefix='/users')


@router.post("/signup",)
async def signup(user: UserModel = Body(...)):
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


@router.post("/login", response_model=TokenModel)
async def logIn(user: LogInUserModel = Body(...)):
    # Check if the user exists in the database
    db_user = await user_collection.find_one({"username": user.username})

    if db_user is None:
        raise HTTPException(
            status_code=401,
            detail="Invalid credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )

    # Verify the password
    if not Hasher.verify_password(user.password, db_user["password"]):
        raise HTTPException(
            status_code=401,
            detail="Invalid credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )

    # Password is correct, generate an access token
    access_token = Token.generate_token(data={"username": user.username})

    return TokenModel(access_token=access_token, token_type="bearer")
