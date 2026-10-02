class DestinationBriefingModel {
  final String destinationName;
  final String query;
  final String timestamp;
  final String statusLabel;
  final String statusDescription;
  final String timeSlot;
  final List<Map<String, dynamic>> signalsSummary;
  final List<String> activeAdvisories;
  final List<String> transportDisruptions;
  final List<String> recentIncidents;
  final List<Map<String, String>> usefulResources;
  final String confidenceSummary;
  final String disclaimer;

  DestinationBriefingModel({
    required this.destinationName,
    required this.query,
    required this.timestamp,
    required this.statusLabel,
    required this.statusDescription,
    required this.timeSlot,
    required this.signalsSummary,
    required this.activeAdvisories,
    required this.transportDisruptions,
    required this.recentIncidents,
    required this.usefulResources,
    required this.confidenceSummary,
    required this.disclaimer,
  });

  factory DestinationBriefingModel.fromJson(Map<String, dynamic> json) {
    return DestinationBriefingModel(
      destinationName: json['destination_name'] ?? 'Patia, Bhubaneswar',
      query: json['query'] ?? '',
      timestamp: json['timestamp'] ?? '',
      statusLabel: json['status_label'] ?? 'Generally calm',
      statusDescription: json['status_description'] ?? 'Low activity expected.',
      timeSlot: json['time_slot'] ?? 'Now',
      signalsSummary: (json['signals_summary'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      activeAdvisories: (json['active_advisories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      transportDisruptions: (json['transport_disruptions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      recentIncidents: (json['recent_incidents'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      usefulResources: (json['useful_resources'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          [],
      confidenceSummary: json['confidence_summary'] ?? '',
      disclaimer: json['disclaimer'] ?? 'This is an information-based assessment, not a guarantee of personal safety.',
    );
  }
}
