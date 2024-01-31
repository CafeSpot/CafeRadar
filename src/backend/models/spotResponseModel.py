from pydantic import BaseModel, conint
from datetime import datetime

class spotResponseModel(BaseModel):
    overall: conint(ge=1, le=5)
    spot_id: str
    barTable: bool
    smallTable: bool
    bigTable: bool
    timestamp: datetime
    place_id: str
    username: str