from datetime import datetime, timedelta
from app.models.schemas import (
    Event, EventCategory, EventStatus, SeverityLevel, EventSource, TimelineItem,
    VerifyRecord, SearchHistoryItem, SentinelMoment, UserProfile, SavedPlace, TrustedContact
)

# Reference Base Coordinates (KIIT Campus 6 / Patia, Bhubaneswar)
# Latitude: 20.3547, Longitude: 85.8155

NOW = datetime.now()

def time_offset_str(minutes_ago: int) -> str:
    dt = NOW - timedelta(minutes=minutes_ago)
    return dt.strftime("%Y-%m-%dT%H:%M:%S")

def time_display_str(minutes_ago: int) -> str:
    if minutes_ago < 60:
        return f"{minutes_ago} min ago"
    hours = minutes_ago // 60
    return f"{hours} hr ago"

INITIAL_EVENTS = [
    Event(
        event_id="evt-road-patia-01",
        category=EventCategory.ROAD,
        title="Road Closure",
        description="Drainage and culvert reconstruction work underway on Patia Mart Road. One lane blocked, traffic redirected via Infocity Avenue.",
        location_name="Patia Mart Road",
        latitude=20.3595,
        longitude=85.8190,
        geofence_radius_m=600.0,
        distance_km=1.2,
        occurred_at=time_offset_str(45),
        first_reported_at=time_offset_str(30),
        last_updated_at=time_offset_str(5),
        status=EventStatus.ONGOING,
        severity=SeverityLevel.ACTION,
        severity_score=0.68,
        confidence_score=0.92,
        corroboration_count=3,
        alternate_route_available=True,
        alternate_route_desc="Use Infocity Avenue or Nandankanan main road",
        delay_minutes=6,
        is_red_alert=False,
        why_it_matters="Primary route connecting KIIT Square to Big Bazaar is partially restricted.",
        sources=[
            EventSource(
                id="src-bmc-01",
                name="Bhubaneswar Municipal Corporation (BMC)",
                publisher_type="official",
                url="https://bmc.gov.in/notices/traffic-2026",
                published_at=time_offset_str(30),
                credibility_score=0.98,
                headline="Official Advisory: Drainage repair on Patia Mart link corridor",
                snippet="Civil works started at 9:00 AM. Commuters advised to take diversion."
            ),
            EventSource(
                id="src-comm-01",
                name="Commissioner of Police Traffic Cell",
                publisher_type="authority",
                url="https://trafficpolice.odisha.gov.in/updates",
                published_at=time_offset_str(25),
                credibility_score=0.95,
                headline="Traffic advisory: Slow vehicular movement near Patia Mart",
                snippet="Traffic police stationed to ease bottlenecks."
            ),
            EventSource(
                id="src-news-01",
                name="Sambad Local Desk",
                publisher_type="news",
                url="https://sambad.in/bhubaneswar/patia-road-work",
                published_at=time_offset_str(15),
                credibility_score=0.88,
                headline="Road repairs cause temporary snarl in northern Bhubaneswar",
                snippet="Alternative lane active for two-wheelers and emergency vehicles."
            )
        ],
        timeline=[
            TimelineItem(
                timestamp=time_offset_str(30),
                title="Work commenced",
                description="Heavy machinery deployed for culvert installation.",
                source_name="Bhubaneswar Municipal Corporation"
            ),
            TimelineItem(
                timestamp=time_offset_str(15),
                title="Traffic diversion established",
                description="Traffic marshals posted at KIIT Square intersection.",
                source_name="Commissioner of Police Traffic Cell"
            )
        ]
    ),
    Event(
        event_id="evt-traffic-kiit-02",
        category=EventCategory.TRAFFIC,
        title="Traffic Congestion",
        description="Minor vehicular congestion reported near KIIT Junction due to peak morning transit and university gate movement.",
        location_name="KIIT Junction",
        latitude=20.3540,
        longitude=85.8162,
        geofence_radius_m=400.0,
        distance_km=1.2,
        occurred_at=time_offset_str(20),
        first_reported_at=time_offset_str(15),
        last_updated_at=time_offset_str(3),
        status=EventStatus.CORROBORATED,
        severity=SeverityLevel.AWARENESS,
        severity_score=0.42,
        confidence_score=0.89,
        corroboration_count=2,
        alternate_route_available=True,
        alternate_route_desc="Use Campus 3 back road",
        delay_minutes=4,
        is_red_alert=False,
        why_it_matters="Slight delay expected if traveling towards Infocity.",
        sources=[
            EventSource(
                id="src-sensor-01",
                name="Odisha Smart City ITS Sensors",
                publisher_type="sensor",
                published_at=time_offset_str(15),
                credibility_score=0.94,
                headline="Sensor alert: Average speed down to 14 km/h at KIIT Junction",
                snippet="Queue length 320 meters."
            ),
            EventSource(
                id="src-user-01",
                name="Sentinel Verified Contributor",
                publisher_type="community",
                published_at=time_offset_str(10),
                credibility_score=0.82,
                headline="Slow moving traffic near Campus 6 crossing",
                snippet="Vehicles moving steadily despite short wait times."
            )
        ],
        timeline=[
            TimelineItem(
                timestamp=time_offset_str(15),
                title="Sensor anomaly detected",
                description="Speed dropped below baseline threshold.",
                source_name="Odisha Smart City ITS"
            )
        ]
    ),
    Event(
        event_id="evt-weather-patia-03",
        category=EventCategory.WEATHER,
        title="Weather Advisory",
        description="Rain expected after 6 PM across Patia and Chandrasekharpur. Mild thunder and 35 km/h gusts anticipated.",
        location_name="Patia / North Bhubaneswar",
        latitude=20.3620,
        longitude=85.8230,
        geofence_radius_m=3000.0,
        distance_km=2.4,
        occurred_at=time_offset_str(60),
        first_reported_at=time_offset_str(60),
        last_updated_at=time_offset_str(10),
        status=EventStatus.CONFIRMED,
        severity=SeverityLevel.INFO,
        severity_score=0.30,
        confidence_score=0.96,
        corroboration_count=2,
        alternate_route_available=False,
        is_red_alert=False,
        why_it_matters="Carrying an umbrella or raincoat recommended for evening commute.",
        sources=[
            EventSource(
                id="src-imd-01",
                name="India Meteorological Department (IMD Bhubaneswar)",
                publisher_type="official",
                url="https://mausam.imd.gov.in/bhubaneswar",
                published_at=time_offset_str(60),
                credibility_score=0.99,
                headline="Nowcast Bulletin: Light to moderate precipitation in Khordha district",
                snippet="Isolated evening showers likely between 18:00 and 21:00."
            )
        ],
        timeline=[]
    ),
    Event(
        event_id="evt-news-city-04",
        category=EventCategory.NEWS,
        title="Local News",
        description="New pedestrian skywalk and smart cycling track inauguration scheduled along Chandrasekharpur - Infocity corridor.",
        location_name="Chandrasekharpur Corridor",
        latitude=20.3410,
        longitude=85.8080,
        geofence_radius_m=1200.0,
        distance_km=3.1,
        occurred_at=time_offset_str(120),
        first_reported_at=time_offset_str(120),
        last_updated_at=time_offset_str(40),
        status=EventStatus.CONFIRMED,
        severity=SeverityLevel.INFO,
        severity_score=0.15,
        confidence_score=0.94,
        corroboration_count=2,
        alternate_route_available=False,
        is_red_alert=False,
        why_it_matters="New non-motorized transport corridor opens for public use.",
        sources=[
            EventSource(
                id="src-otv-01",
                name="OTV News",
                publisher_type="news",
                url="https://odishatv.in/news/city/smart-corridor",
                published_at=time_offset_str(120),
                credibility_score=0.91,
                headline="Bhubaneswar expands smart non-motorized transit corridors",
                snippet="Urban development minister reviews final inspection."
            )
        ],
        timeline=[]
    ),
    Event(
        event_id="evt-fire-kiit-05",
        category=EventCategory.FIRE,
        title="Fire Incident",
        description="Major commercial transformer blaze reported near KIIT Junction commercial complex. Fire brigade units actively controlling containment.",
        location_name="Near KIIT Junction",
        latitude=20.3530,
        longitude=85.8140,
        geofence_radius_m=800.0,
        distance_km=0.8,
        occurred_at=time_offset_str(8),
        first_reported_at=time_offset_str(3),
        last_updated_at=time_offset_str(1),
        status=EventStatus.CORROBORATED,
        severity=SeverityLevel.CRITICAL,
        severity_score=0.92,
        confidence_score=0.95,
        corroboration_count=4,
        alternate_route_available=True,
        alternate_route_desc="Divert through Campus 7 loop road",
        delay_minutes=12,
        is_red_alert=True,
        why_it_matters="Emergency services are actively operating. Avoid KIIT Junction underpass.",
        sources=[
            EventSource(
                id="src-fire-01",
                name="Odisha Fire and Disaster Services",
                publisher_type="official",
                published_at=time_offset_str(3),
                credibility_score=0.99,
                headline="Fire dispatch alert: 2 tenders en route to Patia transformer station",
                snippet="No casualties reported. Area cordoned off for fire suppression."
            ),
            EventSource(
                id="src-police-01",
                name="Chandrasekharpur Police Station Control",
                publisher_type="authority",
                published_at=time_offset_str(2),
                credibility_score=0.96,
                headline="Traffic advisory: Cordon placed around KIIT Junction South sector",
                snippet="General public requested to maintain safe clearance."
            )
        ],
        timeline=[
            TimelineItem(
                timestamp=time_offset_str(3),
                title="First report & dispatch",
                description="Transformer flare-up reported; Fire Unit 1 dispatched.",
                source_name="Odisha Fire Services"
            ),
            TimelineItem(
                timestamp=time_offset_str(1),
                title="Corroboration & Cordon",
                description="Perimeter secured by local traffic personnel.",
                source_name="Chandrasekharpur Police"
            )
        ]
    )
]

PUBLIC_RECORDS = [
    VerifyRecord(
        record_id="rec-ecourts-1234",
        record_type="Person",
        source_system="eCourts Services",
        case_number="Case No. 1234/2023",
        title="eCourts",
        subtitle="Case No. 1234/2023",
        court_or_authority="District Court, Cuttack",
        status="Pending",
        party_role="Accused",
        filing_date="2023-08-14",
        record_url="https://services.ecourts.gov.in/ecourtindia_v6/?case_no=1234_2023_Cuttack",
        confidence_note="Verified official district judiciary database record.",
        is_disputed=False
    ),
    VerifyRecord(
        record_id="rec-ecourts-5678",
        record_type="Person",
        source_system="eCourts Services",
        case_number="Case No. 5678/2021",
        title="eCourts",
        subtitle="Case No. 5678/2021",
        court_or_authority="Sessions Court, Cuttack",
        status="Disposed",
        party_role="Respondent",
        filing_date="2021-03-22",
        disposal_date="2022-11-10",
        record_url="https://services.ecourts.gov.in/ecourtindia_v6/?case_no=5678_2021_Cuttack",
        confidence_note="Verified historical court disposal record.",
        is_disputed=False
    ),
    VerifyRecord(
        record_id="rec-mca-abc-sec",
        record_type="Organization",
        source_system="Ministry of Corporate Affairs (MCA)",
        case_number="CIN: U74999OR2018PTC028491",
        title="ABC Security Agency Pvt Ltd",
        subtitle="Active • PSARA License Verified",
        court_or_authority="Registrar of Companies, Cuttack",
        status="Active",
        party_role="Private Limited Entity",
        filing_date="2018-05-19",
        record_url="https://mca.gov.in/mcafoportal/companyDetails?cin=U74999OR2018PTC028491",
        confidence_note="Registered company status active; PSARA compliance valid till 2028.",
        is_disputed=False
    ),
    VerifyRecord(
        record_id="rec-claim-kiit-01",
        record_type="Claim",
        source_system="FactCheck Registry & UGC Portal",
        case_number="Claim Ref: FC-2025-091",
        title="KIIT University Accreditation & Campus Status",
        subtitle="NAAC A++ Certified • Category 1 University",
        court_or_authority="University Grants Commission / NAAC",
        status="Verified",
        party_role="Institution",
        filing_date="2025-01-10",
        record_url="https://ugc.ac.in/institutions/kiit",
        confidence_note="Official accreditation details verified directly from central regulatory register.",
        is_disputed=False
    )
]

SEARCH_HISTORY = [
    SearchHistoryItem(
        id="sh-1",
        query="Rahul Sharma",
        category="Person",
        time_ago="2 days ago • eCourts",
        icon_type="person"
    ),
    SearchHistoryItem(
        id="sh-2",
        query="KIIT University",
        category="Local News",
        time_ago="3 days ago • Local News",
        icon_type="building"
    ),
    SearchHistoryItem(
        id="sh-3",
        query="Patia",
        category="Area Search",
        time_ago="5 days ago • Area Search",
        icon_type="location"
    ),
    SearchHistoryItem(
        id="sh-4",
        query="ABC Security Agency",
        category="Organization",
        time_ago="1 week ago • Organization",
        icon_type="organization"
    ),
    SearchHistoryItem(
        id="sh-5",
        query="XYZ",
        category="Person",
        time_ago="3 weeks ago • Person",
        icon_type="person_outline"
    )
]

SENTINEL_MOMENTS = [
    SentinelMoment(
        id="mom-1",
        title="Good Morning, Mahi ☀️ 🌸",
        body="The city looks calm today. Perfect time for that pending work!",
        timestamp_display="8:12 AM",
        category="greeting",
        icon_type="sun"
    ),
    SentinelMoment(
        id="mom-2",
        title="Mai tenu samjhawan ki... ☔",
        body="Aaj 6 baje wali baarish miss mat karna – umbrella le jaana.",
        timestamp_display="4:45 PM",
        category="weather",
        icon_type="umbrella"
    ),
    SentinelMoment(
        id="mom-3",
        title="Dal makhani is a better dinner than lauki. 🍲",
        body="You know it. Don't argue with me.",
        timestamp_display="7:20 PM",
        category="personality",
        icon_type="food"
    ),
    SentinelMoment(
        id="mom-4",
        title="All quiet here. 🌙",
        body="Nothing urgent around your saved places.",
        timestamp_display="10:02 PM",
        category="night_briefing",
        icon_type="moon"
    )
]

CURRENT_USER = UserProfile(
    id="usr-mahi-01",
    name="Mahi",
    email="mahi@kiit.ac.in",
    avatar_url="https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80",
    phone="+91 98765 43210",
    is_pro=False
)

SAVED_PLACES = [
    SavedPlace(id="sp-1", name="Home", label="Home", address="Sector 7, Patia, Bhubaneswar", latitude=20.3601, longitude=85.8210),
    SavedPlace(id="sp-2", name="KIIT Campus 6", label="College", address="KIIT Road, Patia", latitude=20.3547, longitude=85.8155),
    SavedPlace(id="sp-3", name="Infocity DLF", label="Work", address="Infocity Ave, Chandrasekharpur", latitude=20.3480, longitude=85.8090)
]

TRUSTED_CONTACTS = [
    TrustedContact(id="tc-1", name="Papa", phone="+91 98450 11223", relationship="Parent"),
    TrustedContact(id="tc-2", name="Ananya (Roommate)", phone="+91 97711 33445", relationship="Friend")
]
