from typing import List
from fastapi import APIRouter
from app.models.schemas import UserProfile, SavedPlace, TrustedContact
from app.data.seed_data import CURRENT_USER, SAVED_PLACES, TRUSTED_CONTACTS

router = APIRouter(prefix="/users", tags=["Users"])

@router.get("/me", response_model=UserProfile)
def get_current_user():
    return CURRENT_USER

@router.get("/places", response_model=List[SavedPlace])
def get_saved_places():
    return SAVED_PLACES

@router.get("/trusted-circle", response_model=List[TrustedContact])
def get_trusted_contacts():
    return TRUSTED_CONTACTS
