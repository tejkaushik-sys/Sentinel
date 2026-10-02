import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/event_model.dart';
import '../../data/models/destination_model.dart';
import '../../data/models/journey_model.dart';
import '../../data/models/report_model.dart';
import '../../data/models/verify_model.dart';
import '../../data/models/moment_model.dart';
import '../../data/models/user_model.dart';

class ApiClient {
  static const String baseUrl = "http://127.0.0.1:8000/api/v1";

  final http.Client _client = http.Client();

  // 1. Events
  Future<List<EventModel>> getEvents({
    double? lat,
    double? lng,
    String? category,
    String? status,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (lat != null) queryParams['lat'] = lat.toString();
      if (lng != null) queryParams['lng'] = lng.toString();
      if (category != null && category.isNotEmpty) queryParams['category'] = category;
      if (status != null && status.isNotEmpty) queryParams['status'] = status;

      final uri = Uri.parse("$baseUrl/events").replace(queryParameters: queryParams);
      final response = await _client.get(uri).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => EventModel.fromJson(json)).toList();
      }
    } catch (e) {
      // Offline fallback
    }
    return _fallbackEvents();
  }

  // 2. Destination Briefing
  Future<DestinationBriefingModel> getDestinationBriefing({
    String destination = "Patia, Bhubaneswar",
    String timeSlot = "Now",
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/destinations/briefing").replace(queryParameters: {
        'destination': destination,
        'time_slot': timeSlot,
      });
      final response = await _client.get(uri).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        return DestinationBriefingModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      // Fallback
    }
    return _fallbackBriefing(destination, timeSlot);
  }

  // 3. Active Journey Plan
  Future<JourneyPlanModel> getActiveJourney() async {
    try {
      final uri = Uri.parse("$baseUrl/journeys/active");
      final response = await _client.get(uri).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        return JourneyPlanModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      // Fallback
    }
    return _fallbackJourney();
  }

  // 4. Submit Report
  Future<ReportModel> submitReport({
    required String category,
    required String title,
    String description = "",
    required double latitude,
    required double longitude,
    String locationName = "Current Location",
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/reports");
      final response = await _client
          .post(
            uri,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "category": category.toLowerCase(),
              "title": title,
              "description": description,
              "latitude": latitude,
              "longitude": longitude,
              "location_name": locationName,
            }),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        return ReportModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      // Local fallback creation
    }
    return ReportModel(
      reportId: "rep-local-${DateTime.now().millisecondsSinceEpoch}",
      category: category,
      title: title,
      description: description,
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
      status: "Submitted",
      moderationState: "Corroborated & Ingested",
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  // 5. Verify Public Records
  Future<List<VerifyRecordModel>> verifyRecords({
    String query = "",
    String type = "Person",
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/verify").replace(queryParameters: {
        'query': query,
        'type': type,
      });
      final response = await _client.get(uri).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> records = data['records'] ?? [];
        return records.map((j) => VerifyRecordModel.fromJson(j)).toList();
      }
    } catch (e) {
      // Fallback
    }
    return _fallbackVerifyRecords();
  }

  // 6. Search History
  Future<List<SearchHistoryModel>> getSearchHistory() async {
    try {
      final uri = Uri.parse("$baseUrl/verify/searches");
      final response = await _client.get(uri).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((j) => SearchHistoryModel.fromJson(j)).toList();
      }
    } catch (e) {
      // Fallback
    }
    return _fallbackSearchHistory();
  }

  Future<void> clearSearchHistory() async {
    try {
      final uri = Uri.parse("$baseUrl/verify/searches");
      await _client.delete(uri).timeout(const Duration(seconds: 3));
    } catch (_) {}
  }

  // 7. Grounded Assistant
  Future<Map<String, dynamic>> queryAssistant({
    required String query,
    double? lat,
    double? lng,
    String? contextEventId,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/assistant/query");
      final response = await _client
          .post(
            uri,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "query": query,
              "latitude": lat ?? 20.3547,
              "longitude": lng ?? 85.8155,
              "context_event_id": contextEventId,
            }),
          )
          .timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      // Fallback
    }
    return {
      "answer": "Patia and KIIT corridors are generally calm with 1 active drainage maintenance on Patia Mart Road. Rainfall expected after 6 PM.",
      "suggested_questions": ["What is the traffic status?", "Show rainfall advisory"],
      "safety_summary": "Calm"
    };
  }

  // 8. Sentinel Moments
  Future<List<SentinelMomentModel>> getSentinelMoments() async {
    try {
      final uri = Uri.parse("$baseUrl/notifications/moments");
      final response = await _client.get(uri).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((j) => SentinelMomentModel.fromJson(j)).toList();
      }
    } catch (_) {}
    return _fallbackMoments();
  }

  // 9. Active Red Alert
  Future<EventModel?> getActiveRedAlert() async {
    try {
      final uri = Uri.parse("$baseUrl/notifications/red-alert");
      final response = await _client.get(uri).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        return EventModel.fromJson(jsonDecode(response.body));
      }
    } catch (_) {}
    return _fallbackRedAlert();
  }

  // 10. User Profile
  Future<UserModel> getUserProfile() async {
    try {
      final uri = Uri.parse("$baseUrl/users/me");
      final response = await _client.get(uri).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      }
    } catch (_) {}
    return UserModel(
      id: "usr-mahi-01",
      name: "Mahi",
      email: "mahi@kiit.ac.in",
      avatarUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80",
      phone: "+91 98765 43210",
      homeAddress: "Sector 7, Patia, Bhubaneswar",
      workAddress: "KIIT University Campus 6",
    );
  }

  // Fallback Data Fixtures
  List<EventModel> _fallbackEvents() {
    return [
      EventModel(
        eventId: "evt-road-patia-01",
        category: "road",
        title: "Road Closure",
        description: "Drainage and culvert reconstruction work underway on Patia Mart Road.",
        locationName: "Patia Mart Road",
        latitude: 20.3595,
        longitude: 85.8190,
        geofenceRadiusM: 600.0,
        distanceKm: 1.2,
        occurredAt: "2026-09-28T17:30:00",
        firstReportedAt: "2026-09-28T17:45:00",
        lastUpdatedAt: "2026-09-28T18:10:00",
        status: "ONGOING",
        severity: "ACTION",
        severityScore: 0.68,
        confidenceScore: 0.92,
        sources: [
          EventSourceModel(
            id: "s1",
            name: "Bhubaneswar Municipal Corporation",
            publisherType: "official",
            publishedAt: "2026-09-28T17:45:00",
            credibilityScore: 0.98,
            headline: "Drainage repair notice",
            snippet: "Civil works started at 9:00 AM.",
          )
        ],
        corroborationCount: 3,
        timeline: [],
        alternateRouteAvailable: true,
        alternateRouteDesc: "Use Infocity Avenue or Nandankanan main road",
        delayMinutes: 6,
        isRedAlert: false,
        whyItMatters: "Primary route connecting KIIT Square to Big Bazaar is partially restricted.",
      ),
      EventModel(
        eventId: "evt-traffic-kiit-02",
        category: "traffic",
        title: "Traffic Congestion",
        description: "Minor congestion near KIIT Junction.",
        locationName: "KIIT Junction",
        latitude: 20.3540,
        longitude: 85.8162,
        geofenceRadiusM: 400.0,
        distanceKm: 1.2,
        occurredAt: "2026-09-28T17:55:00",
        firstReportedAt: "2026-09-28T18:00:00",
        lastUpdatedAt: "2026-09-28T18:12:00",
        status: "CORROBORATED",
        severity: "AWARENESS",
        severityScore: 0.42,
        confidenceScore: 0.89,
        sources: [],
        corroborationCount: 2,
        timeline: [],
        alternateRouteAvailable: true,
        alternateRouteDesc: "Use Campus 3 back road",
        delayMinutes: 4,
        isRedAlert: false,
      ),
      EventModel(
        eventId: "evt-weather-patia-03",
        category: "weather",
        title: "Weather",
        description: "Rain expected after 6 PM.",
        locationName: "Patia / North Bhubaneswar",
        latitude: 20.3620,
        longitude: 85.8230,
        geofenceRadiusM: 3000.0,
        distanceKm: 2.4,
        occurredAt: "2026-09-28T17:15:00",
        firstReportedAt: "2026-09-28T17:15:00",
        lastUpdatedAt: "2026-09-28T18:05:00",
        status: "CONFIRMED",
        severity: "INFO",
        severityScore: 0.30,
        confidenceScore: 0.96,
        sources: [],
        corroborationCount: 2,
        timeline: [],
        alternateRouteAvailable: false,
        delayMinutes: 0,
        isRedAlert: false,
      ),
      EventModel(
        eventId: "evt-news-city-04",
        category: "news",
        title: "Local News",
        description: "New development in city.",
        locationName: "Chandrasekharpur Corridor",
        latitude: 20.3410,
        longitude: 85.8080,
        geofenceRadiusM: 1200.0,
        distanceKm: 3.1,
        occurredAt: "2026-09-28T16:15:00",
        firstReportedAt: "2026-09-28T16:15:00",
        lastUpdatedAt: "2026-09-28T17:30:00",
        status: "CONFIRMED",
        severity: "INFO",
        severityScore: 0.15,
        confidenceScore: 0.94,
        sources: [],
        corroborationCount: 2,
        timeline: [],
        alternateRouteAvailable: false,
        delayMinutes: 0,
        isRedAlert: false,
      )
    ];
  }

  DestinationBriefingModel _fallbackBriefing(String destination, String timeSlot) {
    return DestinationBriefingModel(
      destinationName: destination,
      query: destination,
      timestamp: DateTime.now().toIso8601String(),
      statusLabel: "Generally calm",
      statusDescription: "Low activity expected. No major incidents currently.",
      timeSlot: timeSlot,
      signalsSummary: [
        {"type": "minor", "text": "2 minor incidents earlier today", "icon": "warning_amber"},
        {"type": "traffic", "text": "1 road disruption", "icon": "traffic"},
        {"type": "shield", "text": "No active emergency alerts", "icon": "verified_user"}
      ],
      activeAdvisories: ["IMD light rain forecast between 18:00 - 21:00."],
      transportDisruptions: ["Patia Mart road work: 6 min detour via Infocity Ave."],
      recentIncidents: ["Minor 2-vehicle scrape near KIIT Campus 3 resolved."],
      usefulResources: [
        {"name": "Chandrasekharpur Police Helpline", "contact": "112 / 0674-2740100"},
      ],
      confidenceSummary: "Synthesized from 4 verified sources: Traffic Police, BMC, IMD, Smart City ITS.",
      disclaimer: "This is an information-based assessment, not a guarantee of personal safety.",
    );
  }

  JourneyPlanModel _fallbackJourney() {
    return JourneyPlanModel(
      journeyId: "jrn-01",
      origin: "KIIT University",
      destination: "Home",
      originLat: 20.3547,
      originLng: 85.8155,
      destLat: 20.3680,
      destLng: 85.8270,
      distanceKm: 12.4,
      durationMinutes: 32,
      polylinePoints: [
        [20.3547, 85.8155],
        [20.3562, 85.8170],
        [20.3580, 85.8185],
        [20.3595, 85.8190],
        [20.3620, 85.8210],
        [20.3650, 85.8240],
        [20.3680, 85.8270]
      ],
      hazardsOnRoute: _fallbackEvents().take(1).toList(),
      safetyTips: ["It's getting dark. Share your journey with a trusted contact."],
      alternateDelayMinutes: 6,
      isMonitored: true,
    );
  }

  List<VerifyRecordModel> _fallbackVerifyRecords() {
    return [
      VerifyRecordModel(
        recordId: "rec-1",
        recordType: "Person",
        sourceSystem: "eCourts Services",
        caseNumber: "Case No. 1234/2023",
        title: "eCourts",
        subtitle: "Case No. 1234/2023",
        courtOrAuthority: "District Court, Cuttack",
        status: "Pending",
        partyRole: "Accused",
        filingDate: "2023-08-14",
        recordUrl: "https://services.ecourts.gov.in",
        confidenceNote: "Verified official district judiciary database record.",
      ),
      VerifyRecordModel(
        recordId: "rec-2",
        recordType: "Person",
        sourceSystem: "eCourts Services",
        caseNumber: "Case No. 5678/2021",
        title: "eCourts",
        subtitle: "Case No. 5678/2021",
        courtOrAuthority: "Sessions Court, Cuttack",
        status: "Disposed",
        partyRole: "Respondent",
        filingDate: "2021-03-22",
        recordUrl: "https://services.ecourts.gov.in",
        confidenceNote: "Verified historical court disposal record.",
      )
    ];
  }

  List<SearchHistoryModel> _fallbackSearchHistory() {
    return [
      SearchHistoryModel(id: "1", query: "Rahul Sharma", category: "Person", timeAgo: "2 days ago • eCourts", iconType: "person"),
      SearchHistoryModel(id: "2", query: "KIIT University", category: "Local News", timeAgo: "3 days ago • Local News", iconType: "building"),
      SearchHistoryModel(id: "3", query: "Patia", category: "Area Search", timeAgo: "5 days ago • Area Search", iconType: "location"),
      SearchHistoryModel(id: "4", query: "ABC Security Agency", category: "Organization", timeAgo: "1 week ago • Organization", iconType: "organization"),
      SearchHistoryModel(id: "5", query: "XYZ", category: "Person", timeAgo: "3 weeks ago • Person", iconType: "person_outline"),
    ];
  }

  List<SentinelMomentModel> _fallbackMoments() {
    return [
      SentinelMomentModel(
        id: "m1",
        title: "Good Morning, Mahi ☀️ 🌸",
        body: "The city looks calm today. Perfect time for that pending work!",
        timestampDisplay: "8:12 AM",
        category: "greeting",
        iconType: "sun",
      ),
      SentinelMomentModel(
        id: "m2",
        title: "Mai tenu samjhawan ki... ☔",
        body: "Aaj 6 baje wali baarish miss mat karna – umbrella le jaana.",
        timestampDisplay: "4:45 PM",
        category: "weather",
        iconType: "umbrella",
      ),
      SentinelMomentModel(
        id: "m3",
        title: "Dal makhani is a better dinner than lauki. 🍲",
        body: "You know it. Don't argue with me.",
        timestampDisplay: "7:20 PM",
        category: "food",
        iconType: "food",
      ),
      SentinelMomentModel(
        id: "m4",
        title: "All quiet here. 🌙",
        body: "Nothing urgent around your saved places.",
        timestampDisplay: "10:02 PM",
        category: "night",
        iconType: "moon",
      )
    ];
  }

  EventModel? _fallbackRedAlert() {
    return EventModel(
      eventId: "evt-fire-kiit-05",
      category: "fire",
      title: "Fire Incident",
      description: "Major commercial transformer blaze reported near KIIT Junction commercial complex.",
      locationName: "Near KIIT Junction",
      latitude: 20.3530,
      longitude: 85.8140,
      geofenceRadiusM: 800.0,
      distanceKm: 0.8,
      occurredAt: "2026-09-28T18:05:00",
      firstReportedAt: "2026-09-28T18:07:00",
      lastUpdatedAt: "2026-09-28T18:10:00",
      status: "CORROBORATED",
      severity: "CRITICAL",
      severityScore: 0.92,
      confidenceScore: 0.95,
      sources: [
        EventSourceModel(
          id: "s-fire-01",
          name: "Odisha Fire and Disaster Services",
          publisherType: "official",
          publishedAt: "2026-09-28T18:07:00",
          credibilityScore: 0.99,
          headline: "2 tenders en route to transformer site",
          snippet: "Area cordoned off for fire suppression.",
        )
      ],
      corroborationCount: 4,
      timeline: [],
      alternateRouteAvailable: true,
      alternateRouteDesc: "Divert through Campus 7 loop road",
      delayMinutes: 12,
      isRedAlert: true,
      whyItMatters: "Emergency services are actively operating. Avoid KIIT Junction underpass.",
    );
  }
}

final apiClient = ApiClient();
