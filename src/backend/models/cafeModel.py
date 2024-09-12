from pydantic import BaseModel, conint
from typing import List, Optional

class CafeModel(BaseModel):
    placeId: str # google api提供
    commentIds: Optional[List[str]] # User評論的id
    envRate: Optional[float] # User對工作讀書環境的評分
    tags: Optional[List[str]] # 讀書｜不限時 等hashtag
    cafeId: Optional[List[str]]
    plugNum: Optional[conint(ge=1, le=5)] #插座數量 1~5
    seatSize: Optional[conint(ge=1, le=5)] # 座位數量 1~5
    # music: str
    light: Optional[conint(ge=1, le=5)] # 光線明亮程度 1~5
    images: List[str] # from Google place detail API
    opening_time: str # openingHours
    end_time: str # openingHours
    address: str
    addressLink: str
    photo: str
    ig: str
    fv: str
    crowdRate: Optional[int]