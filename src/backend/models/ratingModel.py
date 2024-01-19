from pydantic import BaseModel, conint
from datetime import datetime

class RatingModel(BaseModel):
    rating: conint(ge=1, le=100)
    review: str
    timeStamp: datetime
    username: str
    cafeId: str