from fastapi import FastAPI, Request, HTTPException
from starlette.middleware.base import BaseHTTPMiddleware
from firebase_admin import auth
from src.backend.repository.query import *

class CheckMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        await self.check_and_add_user(request)     
        response = await call_next(request)
        
        return response

    async def check_and_add_user(self, request: Request):
        id = request.state.user["uid"]
        if not await db_find_user(id):
            await db_create_user(id)

        


