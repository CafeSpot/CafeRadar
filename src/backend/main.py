from fastapi import FastAPI
from pydantic import BaseModel
import firebase_admin

from src.backend.routes.auth import router as auth_router
from src.backend.routes.cafe import router as cafe_router
from src.backend.middlewares.auth import LoggingMiddleware
from firebase_admin import auth, credentials

app = FastAPI()


# 添加 auth 路由
app.include_router(auth_router)
app.include_router(cafe_router)
app.add_middleware(LoggingMiddleware)

# Initialize the Firebase Admin SDK
cred = credentials.Certificate("src/backend/secret/firebaseAdminPrivateKey.json")
firebase_admin.initialize_app(cred)

@app.get("/")
def root():
    return {"message": "Hello World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: str | None = None):
    return {"item_id": item_id, "q": q}
