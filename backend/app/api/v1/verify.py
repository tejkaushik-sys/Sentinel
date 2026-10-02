from typing import List
from fastapi import APIRouter, Query
from app.models.schemas import VerifyResponse, SearchHistoryItem
from app.services.verify_engine import verify_engine_instance
from app.data.seed_data import SEARCH_HISTORY

router = APIRouter(prefix="/verify", tags=["Verify"])

current_search_history: List[SearchHistoryItem] = list(SEARCH_HISTORY)

@router.get("", response_model=VerifyResponse)
def verify_records(
    query: str = Query("", description="Name, case number, or keyword"),
    type: str = Query("Person", description="Entity type: Person, Case, Claim, Organization")
):
    return verify_engine_instance.search(query=query, query_type=type)

@router.get("/searches", response_model=List[SearchHistoryItem])
def get_search_history():
    return current_search_history

@router.delete("/searches")
def clear_search_history():
    current_search_history.clear()
    return {"status": "success", "message": "Search history cleared"}
