from fastapi import APIRouter
from app.models.schemas import AssistantQuery, AssistantResponse
from app.services.grounded_assistant import assistant_instance

router = APIRouter(prefix="/assistant", tags=["Assistant"])

@router.post("/query", response_model=AssistantResponse)
def query_assistant(payload: AssistantQuery):
    return assistant_instance.answer(
        query=payload.query,
        lat=payload.latitude,
        lng=payload.longitude,
        context_event_id=payload.context_event_id
    )
