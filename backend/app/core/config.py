import os
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    APP_NAME: str = "Sentinel API"
    APP_VERSION: str = "1.0.0"
    API_V1_PREFIX: str = "/api/v1"
    ENV: str = "development"
    DEBUG: bool = True
    HOST: str = "127.0.0.1"
    PORT: int = 8000
    CORS_ORIGINS: list[str] = ["*"]
    
    # Coordinates default (Bhubaneswar KIIT & Area)
    DEFAULT_LAT: float = 20.3547
    DEFAULT_LNG: float = 85.8155
    DEFAULT_RADIUS_KM: float = 10.0
    
    # Confidence & Relevance thresholds
    MIN_CORROBORATION_SOURCES: int = 2
    RED_ALERT_SEVERITY_THRESHOLD: float = 0.85
    HIGH_CONFIDENCE_THRESHOLD: float = 0.75

settings = Settings()
