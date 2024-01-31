from pydantic import BaseModel, conint
from datetime import datetime

class CommentModel(BaseModel):
    rating: conint(ge=1, le=5)
    review: str
    timeStamp: datetime
    username: str
    cafeId: str