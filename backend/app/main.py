from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api.v1 import events, destinations, journeys, reports, verify, assistant, notifications, users

app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION,
    description="Sentinel Intelligence & Geospatial Safety Engine API"
)

# Enable CORS for Flutter Web / Desktop client
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount API v1 routers
app.include_router(events.router, prefix=settings.API_V1_PREFIX)
app.include_router(destinations.router, prefix=settings.API_V1_PREFIX)
app.include_router(journeys.router, prefix=settings.API_V1_PREFIX)
app.include_router(reports.router, prefix=settings.API_V1_PREFIX)
app.include_router(verify.router, prefix=settings.API_V1_PREFIX)
app.include_router(assistant.router, prefix=settings.API_V1_PREFIX)
app.include_router(notifications.router, prefix=settings.API_V1_PREFIX)
app.include_router(users.router, prefix=settings.API_V1_PREFIX)

@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "app": settings.APP_NAME,
        "version": settings.APP_VERSION,
        "environment": settings.ENV
    }

@app.get("/")
def root():
    return {
        "tagline": "Sentinel — Know. Verify. Decide.",
        "docs": "/docs",
        "version": settings.APP_VERSION
    }
