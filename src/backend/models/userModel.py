import os
from typing import Optional, List

from fastapi import FastAPI, Body, HTTPException, status
from fastapi.responses import Response
from pydantic import ConfigDict, BaseModel, Field, EmailStr
from pydantic.functional_validators import BeforeValidator

from typing_extensions import Annotated

from bson import ObjectId
from pymongo import ReturnDocument


# Represents an ObjectId field in the database.
# It will be represented as a `str` on the model so that it can be serialized to JSON.
PyObjectId = Annotated[str, BeforeValidator(str)]


class UserModel(BaseModel):
    """
    Container for a single student record.
    """

    # The primary key for the StudentModel, stored as a `str` on the instance.
    # This will be aliased to `_id` when sent to MongoDB,
    # but provided as `id` in the API requests and responses.
    id: Optional[PyObjectId] = Field(alias="_id", default=None)
    firstName: str = Field(...)
    lastName: str = Field(...)
    email: EmailStr = Field(...)
    phone: str = Field(...)
    username: str = Field(...)
    password: str = Field(...)
    credibility: int = Field(...)

    model_config = ConfigDict(
        populate_by_name=True,
        arbitrary_types_allowed=True,
        json_schema_extra={
            "example": {
                "firstName": "Jane",
                "lastName": "Doe",
                "email": "jdoe@example.com",
                "phone": "0901250815",
                "username": "JaneDoe123",
                "password": "HashedPassword",
            }
        },
    )


class UpdateUserModel(BaseModel):

    firstName: Optional[str] = None
    lastName: Optional[str] = None
    email: Optional[EmailStr] = None
    phone: Optional[str] = None
    username: str = Field(...)
    password: Optional[str] = None

    model_config = ConfigDict(
        populate_by_name=True,
        arbitrary_types_allowed=True,
        json_schema_extra={
            "example": {
                "firstName": "Jane",
                "lastName": "Doe",
                "email": "jdoe@example.com",
                "phone": "0901250815",
                "username": "JaneDoe123",
                "password": "HashedPassword",
            }
        },
    )


class LogInUserModel(BaseModel):
    """
    Container for a single user sign in.
    """

    username: str = Field(...)
    password: str = Field(...)

    model_config = ConfigDict(
        populate_by_name=True,
        arbitrary_types_allowed=True,
        json_schema_extra={
            "example": {
                "username": "JaneDoe123",
                "password": "HashedPassword",
            }
        },
    )


class UserCollection(BaseModel):
    """
    A container holding a list of `StudentModel` instances.

    This exists because providing a top-level array in a JSON response can be a [vulnerability](https://haacked.com/archive/2009/06/25/json-hijacking.aspx/)
    """

    users: List[UserModel]
