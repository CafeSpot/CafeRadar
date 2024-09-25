from fastapi import APIRouter, HTTPException, Depends, Body, Query, Request
router = APIRouter(prefix='/user')
from src.backend.repository.query import *

@router.get("/")
async def get_user(
    request: Request
):
    isExist, user = await db_find_user(request.state.user["uid"])
    return {"data": user}


# Define the POST method for managing favorite cafes
@router.post("/{userId}/fav")
async def manage_favorite_cafe(
    request: Request,
    userId: str, 
    action: str,
    cafeId: str
):
    try:
        if "add" in action:
            # Assume db_add_favCafe is your database function
            updated_favCafeIds = await db_add_favCafe(userId, cafeId)
            return {"data": updated_favCafeIds}
        elif "delete" in  action:
            # Assume db_add_favCafe is your database function
            updated_favCafeIds = await db_delete_favCafe(userId, cafeId)
            return {"data": updated_favCafeIds}
        else:
            raise HTTPException(status_code=400, detail="Invalid action. Use 'add' or 'delete'.")
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An error occurred: {e}")


# Define the POST method for managing favorite cafes
@router.post("/{userId}/update")
async def manage_favorite_cafe(
    request: Request,
    name: str, 
    email: str,
    phone: str
):
    try:
        useId = request.state.user["uid"]
        updated_user = await db_update_userInfo(useId, name, email, phone)
        return {"data": updated_user}
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An error occurred: {e}")
