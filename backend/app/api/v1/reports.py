import uuid
from datetime import datetime
from typing import List
from fastapi import APIRouter
from app.models.schemas import ReportCreate, ReportResponse
from app.services.intelligence_pipeline import pipeline_instance

router = APIRouter(prefix="/reports", tags=["Reports"])

SUBMITTED_REPORTS: List[ReportResponse] = []

@router.post("", response_model=ReportResponse)
def submit_report(payload: ReportCreate):
    rep_id = f"rep-{uuid.uuid4().hex[:8]}"
    
    # Ingest into the intelligence pipeline
    pipeline_instance.ingest_report(
        category=payload.category,
        title=payload.title or f"{payload.category.value.title()} Report",
        description=payload.description or "",
        lat=payload.latitude,
        lng=payload.longitude,
        location_name=payload.location_name or "Current Location",
        media_url=payload.media_url
    )
    
    response = ReportResponse(
        report_id=rep_id,
        category=payload.category,
        title=payload.title or f"{payload.category.value.title()} Incident",
        description=payload.description or "",
        location_name=payload.location_name or "Current Location",
        latitude=payload.latitude,
        longitude=payload.longitude,
        status="Submitted",
        moderation_state="Corroborated & Ingested",
        created_at=datetime.now().strftime("%Y-%m-%dT%H:%M:%S"),
        media_url=payload.media_url
    )
    SUBMITTED_REPORTS.insert(0, response)
    return response

@router.get("", response_model=List[ReportResponse])
def get_user_reports():
    return SUBMITTED_REPORTS
