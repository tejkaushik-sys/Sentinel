from typing import List
from fastapi import APIRouter
from app.models.schemas import SentinelMoment, Event
from app.data.seed_data import SENTINEL_MOMENTS
from app.services.intelligence_pipeline import pipeline_instance

router = APIRouter(prefix="/notifications", tags=["Notifications"])

@router.get("/moments", response_model=List[SentinelMoment])
def get_sentinel_moments():
    return SENTINEL_MOMENTS

@router.get("/red-alert", response_model=Event)
def get_active_red_alert():
    all_events = pipeline_instance.get_events()
    red_alerts = [e for e in all_events if e.is_red_alert]
    if red_alerts:
        return red_alerts[0]
    # Fallback to highest severity event
    return all_events[0]
