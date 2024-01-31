from pydantic import BaseModel, conint
from typing import List


class CafeModel(BaseModel):
    cafeId: str
    comment_id: List[str] # User評論
    env_rating: int # 工作讀書環境評分
    tags: List[str]
    crowded: int
    plugs: int
    seatSize: int
    music: str
    light: str
    images: List[str]
    opening_time: str
    end_time: str
