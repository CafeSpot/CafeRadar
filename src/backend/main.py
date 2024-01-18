from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()


class User(BaseModel):
    firstName: str
    lastName: str
    email: str
    username: str
    password: str
    phone: str


@app.get("/")
def root():
    return {"message": "Hello World"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: str | None = None):
    return {"item_id": item_id, "q": q}


@app.put("/user/signup")
def signup(firstName: str, lastName: str, email: str, username: str, password: str, phone: str):
    password = Hasher.get_password_hash(password)
    return {"firstName": firstName, "lastName": lastName, "email": email, "username": username, "password": password, "phone": phone}
