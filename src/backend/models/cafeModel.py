from pydantic import BaseModel, conint
from typing import List, Optional

class CafeModel(BaseModel):
    placeId: str # google api提供
    name: str
    openTime: Optional[str]
    closeTime: Optional[str]
    imageLinks: List[str]
    tags: List[str]
    lat: float
    lon: float
    commentIds: List[str]
    envRate: Optional[float]
    spaceScore: Optional[float]
    lightScore: Optional[float]
    crowdRate: Optional[float]
    plugNum: Optional[int]
    seatNum: Optional[int]
    address: Optional[str]
    addressLink: Optional[str]
    googleMapLink: Optional[str]
    phone: Optional[str]
    link: Optional[str]
    ig: Optional[str]
    igLink: Optional[str]
    fb: Optional[str]
    fbLink: Optional[str]
