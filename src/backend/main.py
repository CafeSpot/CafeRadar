from fastapi import FastAPI
from pydantic import BaseModel

from src.backend.routes.auth import router as auth_router
from src.backend.routes.cafe import router as cafe_router

app = FastAPI()


# 添加 auth 路由
app.include_router(auth_router)
app.include_router(cafe_router)

@app.get("/")
def root():
    return {"message": "Hello World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: str | None = None):
    return {"item_id": item_id, "q": q}
