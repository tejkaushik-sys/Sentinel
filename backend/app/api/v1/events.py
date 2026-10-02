from typing import List, Optional
from fastapi import APIRouter, Query, HTTPException
from app.models.schemas import Event
from app.services.intelligence_pipeline import pipeline_instance

router = APIRouter(prefix="/events", tags=["Events"])

@router.get("", response_model=List[Event])
def list_events(
    lat: Optional[float] = Query(None, description="User latitude"),
    lng: Optional[float] = Query(None, description="User longitude"),
    radius_km: float = Query(15.0, description="Search radius in kilometers"),
    category: Optional[str] = Query(None, description="Filter category (all, safety, traffic, news, weather)"),
    status: Optional[str] = Query(None, description="Filter status")
):
    return pipeline_instance.get_events(
        lat=lat,
        lng=lng,
        radius_km=radius_km,
        category=category,
        status=status
    )

@router.get("/nearby", response_model=List[Event])
def get_nearby_events(
    lat: float = Query(20.3547, description="User latitude"),
    lng: float = Query(85.8155, description="User longitude"),
    radius_km: float = Query(5.0, description="Search radius in kilometers")
):
    return pipeline_instance.get_events(lat=lat, lng=lng, radius_km=radius_km)

@router.get("/{event_id}", response_model=Event)
def get_event_detail(event_id: str):
    evt = pipeline_instance.get_event_by_id(event_id)
    if not evt:
        raise HTTPException(status_code=404, detail="Event not found")
    return evt
