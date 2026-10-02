import 'event_model.dart';

class JourneyPlanModel {
  final String journeyId;
  final String origin;
  final String destination;
  final double originLat;
  final double originLng;
  final double destLat;
  final double destLng;
  final double distanceKm;
  final int durationMinutes;
  final List<List<double>> polylinePoints;
  final List<EventModel> hazardsOnRoute;
  final List<String> safetyTips;
  final List<List<double>>? alternateRoutePolyline;
  final int alternateDelayMinutes;
  final bool isMonitored;

  JourneyPlanModel({
    required this.journeyId,
    required this.origin,
    required this.destination,
    required this.originLat,
    required this.originLng,
    required this.destLat,
    required this.destLng,
    required this.distanceKm,
    required this.durationMinutes,
    required this.polylinePoints,
    required this.hazardsOnRoute,
    required this.safetyTips,
    this.alternateRoutePolyline,
    required this.alternateDelayMinutes,
    required this.isMonitored,
  });

  factory JourneyPlanModel.fromJson(Map<String, dynamic> json) {
    return JourneyPlanModel(
      journeyId: json['journey_id'] ?? '',
      origin: json['origin'] ?? 'KIIT University',
      destination: json['destination'] ?? 'Home',
      originLat: (json['origin_lat'] as num?)?.toDouble() ?? 20.3547,
      originLng: (json['origin_lng'] as num?)?.toDouble() ?? 85.8155,
      destLat: (json['dest_lat'] as num?)?.toDouble() ?? 20.3680,
      destLng: (json['dest_lng'] as num?)?.toDouble() ?? 85.8270,
      distanceKm: (json['distance_km'] as num?)?.toDouble() ?? 12.4,
      durationMinutes: json['duration_minutes'] ?? 32,
      polylinePoints: (json['polyline_points'] as List<dynamic>?)
              ?.map((point) => (point as List<dynamic>)
                  .map((coord) => (coord as num).toDouble())
                  .toList())
              .toList() ??
          [],
      hazardsOnRoute: (json['hazards_on_route'] as List<dynamic>?)
              ?.map((e) => EventModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      safetyTips: (json['safety_tips'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      alternateRoutePolyline: (json['alternate_route_polyline'] as List<dynamic>?)
              ?.map((point) => (point as List<dynamic>)
                  .map((coord) => (coord as num).toDouble())
                  .toList())
              .toList(),
      alternateDelayMinutes: json['alternate_delay_minutes'] ?? 6,
      isMonitored: json['is_monitored'] ?? true,
    );
  }
}
