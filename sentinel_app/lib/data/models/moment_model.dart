class SentinelMomentModel {
  final String id;
  final String title;
  final String body;
  final String timestampDisplay;
  final String category;
  final String iconType;
  final String? actionUrl;
  final bool isRead;

  SentinelMomentModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestampDisplay,
    required this.category,
    required this.iconType,
    this.actionUrl,
    this.isRead = false,
  });

  factory SentinelMomentModel.fromJson(Map<String, dynamic> json) {
    return SentinelMomentModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      timestampDisplay: json['timestamp_display'] ?? '',
      category: json['category'] ?? 'general',
      iconType: json['icon_type'] ?? 'sun',
      actionUrl: json['action_url'],
      isRead: json['is_read'] ?? false,
    );
  }
}
