from fastapi import APIRouter
from app.models.schemas import JourneyPlan
from app.services.intelligence_pipeline import pipeline_instance

router = APIRouter(prefix="/journeys", tags=["Journeys"])

@router.get("/active", response_model=JourneyPlan)
def get_active_journey():
    # Route: KIIT University (Campus 6) to Home (Sector 7, Patia / Chandrasekharpur link)
    polyline = [
        [20.3547, 85.8155], # KIIT University
        [20.3562, 85.8170],
        [20.3580, 85.8185],
        [20.3595, 85.8190], # Patia Mart Road (Hazard point)
        [20.3620, 85.8210],
        [20.3650, 85.8240],
        [20.3680, 85.8270]  # Destination (Home)
    ]
    
    alt_polyline = [
        [20.3547, 85.8155],
        [20.3510, 85.8120], # Infocity Avenue Bypass
        [20.3550, 85.8080],
        [20.3630, 85.8150],
        [20.3680, 85.8270]
    ]
    
    # Get hazards intersecting this route
    all_events = pipeline_instance.get_events()
    hazards = [e for e in all_events if e.category.value in ("road", "traffic", "fire")][:2]
    
    return JourneyPlan(
        journey_id="jrn-kiit-home-01",
        origin="KIIT University",
        destination="Home",
        origin_lat=20.3547,
        origin_lng=85.8155,
        dest_lat=20.3680,
        dest_lng=85.8270,
        distance_km=12.4,
        duration_minutes=32,
        polyline_points=polyline,
        hazards_on_route=hazards,
        safety_tips=[
            "It's getting dark. Share your journey with a trusted contact.",
            "Live route telemetry active with Sentinel corridor monitoring."
        ],
        alternate_route_polyline=alt_polyline,
        alternate_delay_minutes=6,
        is_monitored=True
    )
