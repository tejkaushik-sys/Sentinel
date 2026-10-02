import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/journey_model.dart';
import '../../../data/models/event_model.dart';
import '../../widgets/journey_route_map.dart';
import '../../widgets/glass_container.dart';

class JourneyScreen extends StatefulWidget {
  final Function(EventModel) onOpenEventDetail;
  final Function(String) onOpenDestinationBriefing;

  const JourneyScreen({
    super.key,
    required this.onOpenEventDetail,
    required this.onOpenDestinationBriefing,
  });

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  JourneyPlanModel? _journey;
  bool _isLoading = true;
  bool _isJourneyActive = false;
  bool _useAlternateRoute = false;
  bool _showDisruptionCard = true;

  @override
  void initState() {
    super.initState();
    _loadJourney();
  }

  void _loadJourney() async {
    final journey = await apiClient.getActiveJourney();
    if (mounted) {
      setState(() {
        _journey = journey;
        _isLoading = false;
      });
    }
  }

  void _toggleJourney() {
    setState(() {
      _isJourneyActive = !_isJourneyActive;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isJourneyActive
              ? "Journey Mode Active: Sentinel is continuously monitoring hazards along your route."
              : "Journey ended. Have a safe time!",
        ),
        backgroundColor: _isJourneyActive ? AppColors.cyanDark : AppColors.surfaceElevated,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.directions_outlined, color: AppColors.cyan, size: 22),
                      const SizedBox(width: 8),
                      Text("Journey", style: AppTypography.headlineLarge),
                    ],
                  ),
                  if (_isJourneyActive)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.emerald.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.emerald, width: 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.emerald,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "LIVE MONITORING",
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.emerald,
                              fontWeight: FontWeight.w700,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Origin & Destination Selector Card
              GlassContainer(
                padding: const EdgeInsets.all(16),
                onTap: () => widget.onOpenDestinationBriefing("Home (Sector 7, Patia)"),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.cyan.withValues(alpha: 0.15),
                      ),
                      child: const Icon(Icons.location_on_outlined, color: AppColors.cyan, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "KIIT University",
                                style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Icon(Icons.arrow_forward_rounded, color: AppColors.cyan, size: 14),
                              ),
                              Text(
                                "Home",
                                style: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _useAlternateRoute
                                ? "13.8 km • 38 min (Alternate Route via Infocity)"
                                : "12.4 km • 32 min (via Patia Road)",
                            style: AppTypography.bodySmall.copyWith(
                              color: _useAlternateRoute ? AppColors.emerald : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 22),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Route Map
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: AppColors.cyan),
                  ),
                )
              else if (_journey != null)
                JourneyRouteMap(
                  journey: _journey!,
                  isAlternative: _useAlternateRoute,
                  height: 280,
                ),
              const SizedBox(height: 16),

              // Disruption Alert Card on Route
              if (_showDisruptionCard && !_useAlternateRoute)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1710),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.warningOrange, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.warningOrange.withValues(alpha: 0.15),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.warningOrange.withValues(alpha: 0.2),
                            ),
                            child: const Icon(Icons.warning_amber_rounded, color: AppColors.warningOrange, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Traffic Disruption Ahead",
                                  style: AppTypography.titleMedium.copyWith(
                                    color: AppColors.warningOrange,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Patia Road, 1.4 km",
                                  style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Use alternate route (+6 min)",
                                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showDisruptionCard = false;
                              });
                            },
                            child: const Icon(Icons.close_rounded, color: AppColors.textMuted, size: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _useAlternateRoute = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Switched to Infocity Avenue alternate route!"),
                                    backgroundColor: AppColors.emerald,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.cyan,
                                foregroundColor: AppColors.background,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                              child: const Text("Use Alternate Route"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton(
                            onPressed: () {
                              if (_journey != null && _journey!.hazardsOnRoute.isNotEmpty) {
                                widget.onOpenEventDetail(_journey!.hazardsOnRoute.first);
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            ),
                            child: const Text("View on Map"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              if (_showDisruptionCard && !_useAlternateRoute) const SizedBox(height: 14),

              // Safety Tip Card
              GlassContainer(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.cyan.withValues(alpha: 0.15),
                      ),
                      child: const Icon(Icons.shield_outlined, color: AppColors.cyan, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Safety tip",
                            style: AppTypography.titleMedium.copyWith(color: AppColors.cyan, fontSize: 13),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "It's getting dark. Share your journey with a trusted contact.",
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // CTA Button: Start Journey / End Journey
              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: _isJourneyActive
                      ? const LinearGradient(colors: [Color(0xFFFF6262), Color(0xFFC53030)])
                      : const LinearGradient(colors: [Color(0xFFE8F7F8), Color(0xFF9DECF9)]),
                  boxShadow: [
                    BoxShadow(
                      color: _isJourneyActive
                          ? AppColors.criticalRed.withValues(alpha: 0.4)
                          : AppColors.cyan.withValues(alpha: 0.4),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(26),
                    onTap: _toggleJourney,
                    child: Center(
                      child: Text(
                        _isJourneyActive ? "End Journey" : "Start Journey",
                        style: AppTypography.labelLarge.copyWith(
                          color: _isJourneyActive ? Colors.white : const Color(0xFF07141C),
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
