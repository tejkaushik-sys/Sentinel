class ReportModel {
  final String reportId;
  final String category;
  final String title;
  final String description;
  final String locationName;
  final double latitude;
  final double longitude;
  final String status;
  final String moderationState;
  final String createdAt;
  final String? mediaUrl;

  ReportModel({
    required this.reportId,
    required this.category,
    required this.title,
    required this.description,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.moderationState,
    required this.createdAt,
    this.mediaUrl,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      reportId: json['report_id'] ?? '',
      category: json['category'] ?? 'road',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      locationName: json['location_name'] ?? 'Current Location',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 20.3547,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 85.8155,
      status: json['status'] ?? 'Submitted',
      moderationState: json['moderation_state'] ?? 'Under Moderation',
      createdAt: json['created_at'] ?? '',
      mediaUrl: json['media_url'],
    );
  }
}
