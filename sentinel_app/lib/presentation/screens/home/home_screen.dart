import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/location_service.dart';
import '../../../data/models/event_model.dart';
import '../../widgets/glass_container.dart';

class HomeScreen extends StatefulWidget {
  final Function(String?) onOpenAskSentinel;
  final VoidCallback onOpenMoments;
  final Function(EventModel) onOpenEventDetail;
  final Function(String) onOpenDestinationBriefing;
  final VoidCallback onNavigateToAround;

  const HomeScreen({
    super.key,
    required this.onOpenAskSentinel,
    required this.onOpenMoments,
    required this.onOpenEventDetail,
    required this.onOpenDestinationBriefing,
    required this.onNavigateToAround,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<EventModel> _nearbyEvents = [];
  bool _isLoading = true;
  String _currentCity = "Bhubaneswar";

  @override
  void initState() {
    super.initState();
    _fetchHomeData();
  }

  void _fetchHomeData() async {
    final pos = await locationService.determinePosition();
    final events = await apiClient.getEvents(lat: pos.latitude, lng: pos.longitude);

    if (mounted) {
      setState(() {
        _currentCity = pos.cityName;
        _nearbyEvents = events;
        _isLoading = false;
      });
    }
  }

  void _showCitySelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0C2730),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select Location", style: AppTypography.headlineMedium),
              const SizedBox(height: 16),
              _buildCityOption("Bhubaneswar (Current GPS)", 20.3547, 85.8155, true),
              _buildCityOption("Cuttack", 20.4625, 85.8828, false),
              _buildCityOption("Puri", 19.8135, 85.8312, false),
              _buildCityOption("Goa", 15.2993, 74.1240, false),
              _buildCityOption("Mumbai (Marine Drive)", 18.9438, 72.8234, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCityOption(String name, double lat, double lng, bool isDefault) {
    return ListTile(
      leading: Icon(
        isDefault ? Icons.my_location_rounded : Icons.location_city_rounded,
        color: AppColors.cyan,
      ),
      title: Text(name, style: AppTypography.titleMedium),
      onTap: () {
        Navigator.of(context).pop();
        locationService.setManualLocation(name.split(" ")[0], lat, lng);
        setState(() {
          _currentCity = name.split(" ")[0];
          _isLoading = true;
        });
        _fetchHomeData();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => _fetchHomeData(),
          color: AppColors.cyan,
          backgroundColor: AppColors.surface,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top App Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // City Dropdown
                    GestureDetector(
                      onTap: _showCitySelector,
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: AppColors.cyan, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            _currentCity,
                            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary, size: 20),
                        ],
                      ),
                    ),

                    // Weather Pill
                    GestureDetector(
                      onTap: () => widget.onOpenDestinationBriefing("$_currentCity Weather"),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xCC0C2730),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.wb_cloudy_rounded, color: AppColors.gold, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              "28°C",
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Partly Cloudy",
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Greeting
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good Morning, Mahi",
                          style: AppTypography.displayMedium.copyWith(fontSize: 24),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Stay informed. Stay safe.",
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    // Sentinel Moments notification bell
                    GestureDetector(
                      onTap: widget.onOpenMoments,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surfaceElevated,
                          border: Border.all(color: AppColors.borderLight, width: 1),
                        ),
                        child: Stack(
                          children: [
                            const Icon(Icons.notifications_none_rounded, color: AppColors.cyan, size: 20),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.gold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Search Bar: "Ask Sentinel..."
                GestureDetector(
                  onTap: () => widget.onOpenAskSentinel(null),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0C2730),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Ask Sentinel...",
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                          ),
                        ),
                        const Icon(Icons.mic_none_rounded, color: AppColors.cyan, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Hero Safety Card: "All quiet nearby"
                GestureDetector(
                  onTap: widget.onNavigateToAround,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0x3362D6A7), Color(0x1162D6A7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.emerald.withValues(alpha: 0.6), width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.emerald.withValues(alpha: 0.15),
                          blurRadius: 16,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.emerald.withValues(alpha: 0.2),
                          ),
                          child: const Icon(
                            Icons.eco_rounded,
                            color: AppColors.emerald,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "All quiet nearby",
                                style: AppTypography.titleLarge.copyWith(
                                  color: AppColors.emerald,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Nothing urgent in your area right now.",
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.emerald,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 26),

                // Nearby Updates Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Nearby Updates",
                      style: AppTypography.headlineMedium.copyWith(fontSize: 17),
                    ),
                    GestureDetector(
                      onTap: widget.onNavigateToAround,
                      child: Text(
                        "Explore Map →",
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.cyan,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(color: AppColors.cyan),
                    ),
                  )
                else ...[
                  ..._nearbyEvents.map((event) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildUpdateCard(event),
                      )),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateCard(EventModel event) {
    final Color categoryColor = _getEventColor(event.category);
    final IconData categoryIcon = _getEventIcon(event.category);

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      onTap: () => widget.onOpenEventDetail(event),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: categoryColor.withValues(alpha: 0.15),
              border: Border.all(color: categoryColor.withValues(alpha: 0.4), width: 1),
            ),
            child: Icon(categoryIcon, color: categoryColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  event.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${event.distanceKm ?? 1.2} km • ${_formatRecency(event.firstReportedAt)}",
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textMuted,
            size: 22,
          ),
        ],
      ),
    );
  }

  Color _getEventColor(String category) {
    switch (category.toLowerCase()) {
      case 'traffic':
        return const Color(0xFFFF6275);
      case 'weather':
        return const Color(0xFF38B2AC);
      case 'news':
        return AppColors.cyan;
      case 'fire':
      case 'accident':
        return AppColors.criticalRed;
      default:
        return AppColors.emerald;
    }
  }

  IconData _getEventIcon(String category) {
    switch (category.toLowerCase()) {
      case 'traffic':
        return Icons.directions_car_rounded;
      case 'weather':
        return Icons.cloud_outlined;
      case 'news':
        return Icons.article_outlined;
      case 'fire':
        return Icons.local_fire_department_rounded;
      default:
        return Icons.shield_outlined;
    }
  }

  String _formatRecency(String timestamp) {
    try {
      final dt = DateTime.parse(timestamp);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return "${diff.inMinutes.abs() + 5} min ago";
      return "${diff.inHours} hr ago";
    } catch (_) {
      return "15 min ago";
    }
  }
}
