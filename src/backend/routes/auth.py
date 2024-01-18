from fastapi import APIRouter

from backend.controllers.auth import

router = APIRouter(prefix='auth')


@router.get("/")