class VerifyRecordModel {
  final String recordId;
  final String recordType;
  final String sourceSystem;
  final String? caseNumber;
  final String title;
  final String? subtitle;
  final String? courtOrAuthority;
  final String status;
  final String? partyRole;
  final String? filingDate;
  final String? disposalDate;
  final String? recordUrl;
  final String confidenceNote;
  final bool isDisputed;

  VerifyRecordModel({
    required this.recordId,
    required this.recordType,
    required this.sourceSystem,
    this.caseNumber,
    required this.title,
    this.subtitle,
    this.courtOrAuthority,
    required this.status,
    this.partyRole,
    this.filingDate,
    this.disposalDate,
    this.recordUrl,
    required this.confidenceNote,
    this.isDisputed = false,
  });

  factory VerifyRecordModel.fromJson(Map<String, dynamic> json) {
    return VerifyRecordModel(
      recordId: json['record_id'] ?? '',
      recordType: json['record_type'] ?? 'Person',
      sourceSystem: json['source_system'] ?? 'eCourts',
      caseNumber: json['case_number'],
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      courtOrAuthority: json['court_or_authority'],
      status: json['status'] ?? 'Pending',
      partyRole: json['party_role'],
      filingDate: json['filing_date'],
      disposalDate: json['disposal_date'],
      recordUrl: json['record_url'],
      confidenceNote: json['confidence_note'] ?? 'Verified official source record.',
      isDisputed: json['is_disputed'] ?? false,
    );
  }
}

class SearchHistoryModel {
  final String id;
  final String query;
  final String category;
  final String timeAgo;
  final String iconType;

  SearchHistoryModel({
    required this.id,
    required this.query,
    required this.category,
    required this.timeAgo,
    required this.iconType,
  });

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) {
    return SearchHistoryModel(
      id: json['id'] ?? '',
      query: json['query'] ?? '',
      category: json['category'] ?? 'Person',
      timeAgo: json['time_ago'] ?? '',
      iconType: json['icon_type'] ?? 'person',
    );
  }
}
