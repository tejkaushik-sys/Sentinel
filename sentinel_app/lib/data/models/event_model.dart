class EventSourceModel {
  final String id;
  final String name;
  final String publisherType;
  final String? url;
  final String publishedAt;
  final double credibilityScore;
  final String headline;
  final String snippet;

  EventSourceModel({
    required this.id,
    required this.name,
    required this.publisherType,
    this.url,
    required this.publishedAt,
    required this.credibilityScore,
    required this.headline,
    required this.snippet,
  });

  factory EventSourceModel.fromJson(Map<String, dynamic> json) {
    return EventSourceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Source',
      publisherType: json['publisher_type'] ?? 'news',
      url: json['url'],
      publishedAt: json['published_at'] ?? '',
      credibilityScore: (json['credibility_score'] as num?)?.toDouble() ?? 0.8,
      headline: json['headline'] ?? '',
      snippet: json['snippet'] ?? '',
    );
  }
}

class TimelineItemModel {
  final String timestamp;
  final String title;
  final String description;
  final String sourceName;

  TimelineItemModel({
    required this.timestamp,
    required this.title,
    required this.description,
    required this.sourceName,
  });

  factory TimelineItemModel.fromJson(Map<String, dynamic> json) {
    return TimelineItemModel(
      timestamp: json['timestamp'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      sourceName: json['source_name'] ?? '',
    );
  }
}

class EventModel {
  final String eventId;
  final String category;
  final String title;
  final String description;
  final String locationName;
  final double latitude;
  final double longitude;
  final double geofenceRadiusM;
  final double? distanceKm;
  final String occurredAt;
  final String firstReportedAt;
  final String lastUpdatedAt;
  final String status;
  final String severity;
  final double severityScore;
  final double confidenceScore;
  final List<EventSourceModel> sources;
  final int corroborationCount;
  final List<TimelineItemModel> timeline;
  final bool alternateRouteAvailable;
  final String? alternateRouteDesc;
  final int delayMinutes;
  final bool isRedAlert;
  final String? whyItMatters;

  EventModel({
    required this.eventId,
    required this.category,
    required this.title,
    required this.description,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.geofenceRadiusM,
    this.distanceKm,
    required this.occurredAt,
    required this.firstReportedAt,
    required this.lastUpdatedAt,
    required this.status,
    required this.severity,
    required this.severityScore,
    required this.confidenceScore,
    required this.sources,
    required this.corroborationCount,
    required this.timeline,
    required this.alternateRouteAvailable,
    this.alternateRouteDesc,
    required this.delayMinutes,
    required this.isRedAlert,
    this.whyItMatters,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['event_id'] ?? '',
      category: json['category'] ?? 'safety',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      locationName: json['location_name'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 20.3547,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 85.8155,
      geofenceRadiusM: (json['geofence_radius_m'] as num?)?.toDouble() ?? 500.0,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      occurredAt: json['occurred_at'] ?? '',
      firstReportedAt: json['first_reported_at'] ?? '',
      lastUpdatedAt: json['last_updated_at'] ?? '',
      status: json['status'] ?? 'REPORTED',
      severity: json['severity'] ?? 'INFO',
      severityScore: (json['severity_score'] as num?)?.toDouble() ?? 0.5,
      confidenceScore: (json['confidence_score'] as num?)?.toDouble() ?? 0.8,
      sources: (json['sources'] as List<dynamic>?)
              ?.map((e) => EventSourceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      corroborationCount: json['corroboration_count'] ?? 1,
      timeline: (json['timeline'] as List<dynamic>?)
              ?.map((e) => TimelineItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      alternateRouteAvailable: json['alternate_route_available'] ?? false,
      alternateRouteDesc: json['alternate_route_desc'],
      delayMinutes: json['delay_minutes'] ?? 0,
      isRedAlert: json['is_red_alert'] ?? false,
      whyItMatters: json['why_it_matters'],
    );
  }
}
