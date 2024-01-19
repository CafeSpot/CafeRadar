from pydantic import BaseModel, conint
from typing import Set

class CafeModel(BaseModel):
    cafeId: str
    tags: Set[str]
    rating: conint(ge=1, le=100)
    plugs: int
    seatSize: conint(ge=1, le=3)
    music: Set[str]