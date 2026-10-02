import math
from typing import List, Tuple

def haversine_distance_km(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    """Calculate the great-circle distance between two points in kilometers."""
    R = 6371.0  # Earth's radius in kilometers
    
    phi1 = math.radians(lat1)
    phi2 = math.radians(lat2)
    delta_phi = math.radians(lat2 - lat1)
    delta_lambda = math.radians(lon2 - lon1)
    
    a = (math.sin(delta_phi / 2.0) ** 2 +
         math.cos(phi1) * math.cos(phi2) * math.sin(delta_lambda / 2.0) ** 2)
    c = 2.0 * math.atan2(math.sqrt(a), math.sqrt(1.0 - a))
    
    return round(R * c, 2)

def distance_to_segment_km(p_lat: float, p_lng: float, a_lat: float, a_lng: float, b_lat: float, b_lng: float) -> float:
    """Calculates perpendicular or minimum distance from a point to a line segment in km."""
    # Convert degrees to approximate meters (Mercator projection local approximation)
    lat_mid = (a_lat + b_lat) / 2.0
    m_per_deg_lat = 111132.954 - 559.822 * math.cos(2 * math.radians(lat_mid))
    m_per_deg_lng = 111412.84 * math.cos(math.radians(lat_mid))
    
    px = (p_lng - a_lng) * m_per_deg_lng
    py = (p_lat - a_lat) * m_per_deg_lat
    
    bx = (b_lng - a_lng) * m_per_deg_lng
    by = (b_lat - a_lat) * m_per_deg_lat
    
    seg_len_sq = bx * bx + by * by
    if seg_len_sq == 0:
        return math.sqrt(px * px + py * py) / 1000.0
    
    # Project point onto line segment
    t = max(0.0, min(1.0, (px * bx + py * by) / seg_len_sq))
    proj_x = t * bx
    proj_y = t * by
    
    dist_m = math.sqrt((px - proj_x) ** 2 + (py - proj_y) ** 2)
    return dist_m / 1000.0

def min_distance_to_route_km(lat: float, lng: float, polyline: List[List[float]]) -> float:
    """Calculates the minimum distance in km from a coordinate to any segment in a polyline."""
    if not polyline or len(polyline) < 2:
        return 999.0
    
    min_dist = float('inf')
    for i in range(len(polyline) - 1):
        d = distance_to_segment_km(
            lat, lng,
            polyline[i][0], polyline[i][1],
            polyline[i+1][0], polyline[i+1][1]
        )
        if d < min_dist:
            min_dist = d
    return round(min_dist, 2)

def cluster_points(points: List[Tuple[float, float, str]], max_distance_km: float = 0.5) -> List[List[str]]:
    """Groups points within max_distance_km into spatial clusters."""
    clusters = []
    visited = set()
    
    for i, (lat1, lon1, id1) in enumerate(points):
        if id1 in visited:
            continue
        cluster = [id1]
        visited.add(id1)
        for j, (lat2, lon2, id2) in enumerate(points):
            if id2 in visited:
                continue
            if haversine_distance_km(lat1, lon1, lat2, lon2) <= max_distance_km:
                cluster.append(id2)
                visited.add(id2)
        clusters.append(cluster)
        
    return clusters
