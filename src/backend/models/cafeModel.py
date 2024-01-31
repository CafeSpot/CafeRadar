from pydantic import BaseModel, conint
from typing import List, Optional


class CafeModel(BaseModel):
    place_id: str # google api提供
    comment_id: Optional[List[str]] # User評論的id
    env_rating: Optional[int] # User對工作讀書環境的評分
    tags: Optional[List[str]] # 讀書｜不限時 等hashtag
    spot_id: Optional[List[str]]
    plugs: Optional[conint(ge=1, le=5)] #插座數量 1~5
    seat_size: Optional[conint(ge=1, le=5)] # 座位數量 1~5
    # music: str
    light: Optional[conint(ge=1, le=5)] # 光線明亮程度 1~5
    images: List[str] # from Google place detail API
    opening_time: str
    end_time: str