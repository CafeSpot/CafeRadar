from passlib.context import CryptContext

from src.backend.database import *
from src.backend.models.userModel import *

# 用sha256來加密密碼
pwd_context = CryptContext(schemes=["sha256_crypt"], deprecated="auto")


class Hasher():
    @staticmethod
    def verify_password(plain_password, hashed_password):
        return pwd_context.verify(plain_password, hashed_password)

    @staticmethod
    def get_password_hash(password):
        return pwd_context.hash(password)
