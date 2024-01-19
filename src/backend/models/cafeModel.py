from pydantic import BaseModel, conint

class CafeModel(BaseModel):
    tags: set()
    rating: conint(ge=1, le=100)