from pydantic import BaseModel, conint
from typing import List


class CafeModel(BaseModel):
    cafeId: str
    tags: List[str]
    rating: int
    plugs: int
    seatSize: int
    music: str
    mapURL: str
    image: str
    light: str
