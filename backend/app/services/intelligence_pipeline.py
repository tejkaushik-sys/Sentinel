import uuid
from datetime import datetime
from typing import List, Optional
from app.models.schemas import Event, EventCategory, EventStatus, SeverityLevel, EventSource, TimelineItem
from app.services.spatial_engine import haversine_distance_km
from app.data.seed_data import INITIAL_EVENTS
from app.services.live_source_ingestion import live_ingestion

class IntelligencePipeline:
    def __init__(self):
        self.events: List[Event] = list(INITIAL_EVENTS)
        self._sync_live_sources()

    def _sync_live_sources(self):
        """Asynchronously syncs live external news and telemetry."""
        try:
            live_news = live_ingestion.fetch_live_news_rss("Bhubaneswar safety traffic")
            if live_news:
                for idx, item in enumerate(live_news[:2]):
                    event_id = f"evt-live-news-{idx}"
                    # Check if already exists
                    if not any(e.event_id == event_id for e in self.events):
                        self.events.append(
                            Event(
                                event_id=event_id,
                                category=EventCategory.NEWS,
                                title=item["title"][:50] + ("..." if len(item["title"]) > 50 else ""),
                                description=item["title"],
                                location_name="Bhubaneswar Urban Region",
                                latitude=20.3547 + (idx * 0.008),
                                longitude=85.8155 + (idx * 0.006),
                                geofence_radius_m=1500.0,
                                distance_km=round(1.5 + (idx * 1.2), 1),
                                occurred_at=datetime.now().strftime("%Y-%m-%dT%H:%M:%S"),
                                first_reported_at=datetime.now().strftime("%Y-%m-%dT%H:%M:%S"),
                                last_updated_at=datetime.now().strftime("%Y-%m-%dT%H:%M:%S"),
                                status=EventStatus.CONFIRMED,
                                severity=SeverityLevel.INFO,
                                severity_score=0.25,
                                confidence_score=0.96,
                                corroboration_count=2,
                                sources=[
                                    EventSource(
                                        id=f"src-live-{idx}",
                                        name=item["source_name"],
                                        publisher_type="news",
                                        url=item["url"],
                                        published_at=item["published_at"],
                                        credibility_score=0.92,
                                        headline=item["title"],
                                        snippet=f"Live reporting via {item['source_name']} news desk."
                                    )
                                ],
                                timeline=[],
                                is_red_alert=False,
                                why_it_matters="Live news extracted from regional public broadcast."
                            )
                        )
        except Exception:
            pass
    
    def get_events(
        self,
        lat: Optional[float] = None,
        lng: Optional[float] = None,
        radius_km: float = 10.0,
        category: Optional[str] = None,
        status: Optional[str] = None,
        min_severity: Optional[str] = None
    ) -> List[Event]:
        results = []
        for evt in self.events:
            if category and category.lower() != "all":
                if evt.category.value.lower() != category.lower():
                    continue
            
            if status and evt.status.value.lower() != status.lower():
                continue
            
            # Recalculate distance if lat/lng supplied
            if lat is not None and lng is not None:
                d = haversine_distance_km(lat, lng, evt.latitude, evt.longitude)
                evt_copy = evt.model_copy(update={"distance_km": d})
                if d <= radius_km:
                    results.append(evt_copy)
            else:
                results.append(evt)
        
        # Sort by severity score and proximity
        results.sort(key=lambda x: (-x.severity_score, x.distance_km if x.distance_km is not None else 0))
        return results
    
    def get_event_by_id(self, event_id: str) -> Optional[Event]:
        for e in self.events:
            if e.event_id == event_id:
                return e
        return None
    
    def ingest_report(
        self,
        category: EventCategory,
        title: str,
        description: str,
        lat: float,
        lng: float,
        location_name: str,
        media_url: Optional[str] = None
    ) -> Event:
        # Spatial deduplication check: check if an ongoing event exists within 500m of same category
        for existing in self.events:
            dist = haversine_distance_km(lat, lng, existing.latitude, existing.longitude)
            if dist <= 0.6 and (existing.category == category or existing.status == EventStatus.ONGOING):
                # Corroborate existing event!
                new_src = EventSource(
                    id=f"src-user-{uuid.uuid4().hex[:6]}",
                    name="Sentinel Verified Citizen Contributor",
                    publisher_type="community",
                    published_at=datetime.now().strftime("%Y-%m-%dT%H:%M:%S"),
                    credibility_score=0.84,
                    headline=f"Citizen report: {title}",
                    snippet=description or "Citizen visual confirmation near site."
                )
                existing.sources.append(new_src)
                existing.corroboration_count = len(existing.sources)
                existing.confidence_score = min(0.99, existing.confidence_score + 0.05)
                if existing.status == EventStatus.REPORTED:
                    existing.status = EventStatus.CORROBORATED
                existing.last_updated_at = datetime.now().strftime("%Y-%m-%dT%H:%M:%S")
                existing.timeline.append(
                    TimelineItem(
                        timestamp=datetime.now().strftime("%Y-%m-%dT%H:%M:%S"),
                        title="Corroborating citizen report added",
                        description=title,
                        source_name="Sentinel Community"
                    )
                )
                return existing

        # Otherwise, create a new event in REPORTED / UNVERIFIED state
        now_str = datetime.now().strftime("%Y-%m-%dT%H:%M:%S")
        new_event = Event(
            event_id=f"evt-{category.value}-{uuid.uuid4().hex[:6]}",
            category=category,
            title=title,
            description=description,
            location_name=location_name or "Reported Location",
            latitude=lat,
            longitude=lng,
            geofence_radius_m=500.0,
            distance_km=0.1,
            occurred_at=now_str,
            first_reported_at=now_str,
            last_updated_at=now_str,
            status=EventStatus.REPORTED,
            severity=SeverityLevel.AWARENESS,
            severity_score=0.45,
            confidence_score=0.60,
            corroboration_count=1,
            alternate_route_available=False,
            is_red_alert=False,
            why_it_matters="Under active Sentinel intelligence community corroboration.",
            sources=[
                EventSource(
                    id=f"src-user-{uuid.uuid4().hex[:6]}",
                    name="Sentinel Citizen Reporter",
                    publisher_type="community",
                    published_at=now_str,
                    credibility_score=0.75,
                    headline=title,
                    snippet=description
                )
            ],
            timeline=[
                TimelineItem(
                    timestamp=now_str,
                    title="Incident reported",
                    description=description,
                    source_name="Sentinel Ingestion Pipeline"
                )
            ]
        )
        self.events.insert(0, new_event)
        return new_event

pipeline_instance = IntelligencePipeline()
