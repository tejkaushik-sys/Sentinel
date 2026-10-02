from datetime import datetime
from typing import List, Optional, Dict, Any
from enum import Enum
from pydantic import BaseModel, Field

class EventCategory(str, Enum):
    SAFETY = "safety"
    TRAFFIC = "traffic"
    NEWS = "news"
    WEATHER = "weather"
    FIRE = "fire"
    ACCIDENT = "accident"
    ROAD = "road"
    HAZARD = "hazard"

class EventStatus(str, Enum):
    REPORTED = "REPORTED"
    UNVERIFIED = "UNVERIFIED"
    CORROBORATED = "CORROBORATED"
    CONFIRMED = "CONFIRMED"
    ONGOING = "ONGOING"
    DISPUTED = "DISPUTED"
    RESOLVED = "RESOLVED"
    EXPIRED = "EXPIRED"

class SeverityLevel(str, Enum):
    INFO = "INFO"
    AWARENESS = "AWARENESS"
    ACTION = "ACTION"
    CRITICAL = "CRITICAL"

class EventSource(BaseModel):
    id: str
    name: str
    publisher_type: str  # "official", "news", "sensor", "community", "authority"
    url: Optional[str] = None
    published_at: str
    credibility_score: float = 0.85
    headline: str
    snippet: str

class TimelineItem(BaseModel):
    timestamp: str
    title: str
    description: str
    source_name: str

class Event(BaseModel):
    event_id: str
    category: EventCategory
    title: str
    description: str
    location_name: str
    latitude: float
    longitude: float
    geofence_radius_m: float = 500.0
    distance_km: Optional[float] = None
    occurred_at: str
    first_reported_at: str
    last_updated_at: str
    status: EventStatus
    severity: SeverityLevel
    severity_score: float = 0.5  # 0.0 - 1.0
    confidence_score: float = 0.85  # 0.0 - 1.0
    sources: List[EventSource] = []
    corroboration_count: int = 1
    timeline: List[TimelineItem] = []
    alternate_route_available: bool = False
    alternate_route_desc: Optional[str] = None
    delay_minutes: int = 0
    is_red_alert: bool = False
    why_it_matters: Optional[str] = None

class DestinationBriefing(BaseModel):
    destination_name: str
    query: str
    timestamp: str
    status_label: str  # e.g., "Generally calm"
    status_description: str  # "Low activity expected. No major incidents currently."
    time_slot: str  # "Now", "6 PM", "9 PM", "12 AM"
    signals_summary: List[Dict[str, Any]]
    active_advisories: List[str]
    transport_disruptions: List[str]
    recent_incidents: List[str]
    useful_resources: List[Dict[str, str]]
    confidence_summary: str
    disclaimer: str = "This is an information-based assessment, not a guarantee of personal safety."

class Waypoint(BaseModel):
    name: str
    latitude: float
    longitude: float
    is_hazard: bool = False
    hazard_title: Optional[str] = None

class JourneyPlan(BaseModel):
    journey_id: str
    origin: str
    destination: str
    origin_lat: float
    origin_lng: float
    dest_lat: float
    dest_lng: float
    distance_km: float
    duration_minutes: int
    polyline_points: List[List[float]]  # [[lat, lng], ...]
    hazards_on_route: List[Event] = []
    safety_tips: List[str] = []
    alternate_route_polyline: Optional[List[List[float]]] = None
    alternate_delay_minutes: int = 0
    is_monitored: bool = True

class ReportCreate(BaseModel):
    category: EventCategory
    title: str
    description: Optional[str] = ""
    latitude: float
    longitude: float
    location_name: Optional[str] = "Current Location"
    media_url: Optional[str] = None

class ReportResponse(BaseModel):
    report_id: str
    category: EventCategory
    title: str
    description: str
    location_name: str
    latitude: float
    longitude: float
    status: str
    moderation_state: str  # "Under Moderation", "Corroborated", "Integrated"
    created_at: str
    media_url: Optional[str] = None

class VerifyRecord(BaseModel):
    record_id: str
    record_type: str  # "Person", "Case", "Claim", "Organization"
    source_system: str  # "eCourts Services", "MCA Registry", "FactCheck Registry", "Police Gazette"
    case_number: Optional[str] = None
    title: str
    subtitle: Optional[str] = None
    court_or_authority: Optional[str] = None
    status: str  # "Pending", "Disposed", "Active", "Verified"
    party_role: Optional[str] = None
    filing_date: Optional[str] = None
    disposal_date: Optional[str] = None
    record_url: Optional[str] = None
    confidence_note: str = "Verified official source record."
    is_disputed: bool = False

class VerifyResponse(BaseModel):
    query: str
    query_type: str
    total_found: int
    records: List[VerifyRecord]
    disclaimer: str = "A name match is not proof of identity. Verify the original record and identity."

class SearchHistoryItem(BaseModel):
    id: str
    query: str
    category: str  # "Person", "Case", "Area Search", "Local News", "Organization"
    time_ago: str
    icon_type: str

class AssistantQuery(BaseModel):
    query: str
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    context_event_id: Optional[str] = None

class AssistantResponse(BaseModel):
    answer: str
    grounded_events: List[Event] = []
    grounded_records: List[VerifyRecord] = []
    suggested_questions: List[str] = []
    safety_summary: str = "Calm"

class SentinelMoment(BaseModel):
    id: str
    title: str
    body: str
    timestamp_display: str
    category: str
    icon_type: str
    action_url: Optional[str] = None
    is_read: bool = False

class UserProfile(BaseModel):
    id: str
    name: str
    email: str
    avatar_url: str
    phone: str
    is_pro: bool = False
    home_address: str = "Patia, Bhubaneswar"
    work_address: str = "KIIT University Campus 6"

class SavedPlace(BaseModel):
    id: str
    name: str
    label: str  # "Home", "Work", "College", "Gym"
    address: str
    latitude: float
    longitude: float

class TrustedContact(BaseModel):
    id: str
    name: str
    phone: str
    relationship: str
    is_active: bool = True
