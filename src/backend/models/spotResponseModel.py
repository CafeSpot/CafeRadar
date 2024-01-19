from pydantic import BaseModel, conint
from datetime import datetime

class spotResponseModel(BaseModel):
    overall: conint(ge=1, le=5)
    bar: bool
    smallTable: bool
    bigTable: bool
    timestamp: datetime
    cafeId = str
    username: str

