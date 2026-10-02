import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/event_model.dart';
import '../../widgets/animated_radar_map.dart';
import '../../widgets/glass_container.dart';

class AroundScreen extends StatefulWidget {
  final Function(EventModel) onOpenEventDetail;
  final VoidCallback onOpenAreaSearch;

  const AroundScreen({
    super.key,
    required this.onOpenEventDetail,
    required this.onOpenAreaSearch,
  });

  @override
  State<AroundScreen> createState() => _AroundScreenState();
}

class _AroundScreenState extends State<AroundScreen> {
  List<EventModel> _allEvents = [];
  List<EventModel> _filteredEvents = [];
  EventModel? _selectedEvent;
  String _selectedCategory = "All";
  bool _isLoading = true;

  final List<String> _categories = ["All", "Safety", "Traffic", "News", "Weather"];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() async {
    final events = await apiClient.getEvents();
    if (mounted) {
      setState(() {
        _allEvents = events;
        _filterEvents(_selectedCategory);
        if (_allEvents.isNotEmpty) {
          _selectedEvent = _allEvents.first;
        }
        _isLoading = false;
      });
    }
  }

  void _filterEvents(String category) {
    setState(() {
      _selectedCategory = category;
      if (category == "All") {
        _filteredEvents = _allEvents;
      } else {
        _filteredEvents = _allEvents
            .where((e) => e.category.toLowerCase() == category.toLowerCase())
            .toList();
      }
      if (_filteredEvents.isNotEmpty) {
        _selectedEvent = _filteredEvents.first;
      } else {
        _selectedEvent = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
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
                      const Icon(Icons.radar_rounded, color: AppColors.cyan, size: 22),
                      const SizedBox(width: 8),
                      Text("Around Me", style: AppTypography.headlineLarge),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search_rounded, color: AppColors.cyan),
                        onPressed: widget.onOpenAreaSearch,
                        tooltip: "Area Safety Search",
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.borderLight, width: 1),
                        ),
                        child: const Icon(Icons.my_location_rounded, color: AppColors.cyan, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Filter Chips Row
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;
                    return GestureDetector(
                      onTap: () => _filterEvents(cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.cyan : AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppColors.cyan : AppColors.border,
                            width: 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.cyan.withValues(alpha: 0.35),
                                    blurRadius: 10,
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            cat,
                            style: AppTypography.bodySmall.copyWith(
                              color: isSelected ? const Color(0xFF07141C) : AppColors.textSecondary,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Interactive Live Radar Map
              Expanded(
                child: AnimatedRadarMap(
                  events: _filteredEvents,
                  selectedEvent: _selectedEvent,
                  onSelectEvent: (evt) {
                    setState(() {
                      _selectedEvent = evt;
                    });
                  },
                  onRecenter: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Recalibrating GPS to Bhubaneswar, Patia..."),
                        duration: Duration(seconds: 1),
                        backgroundColor: AppColors.cyanDark,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Bottom Highlight Card
              if (_selectedEvent != null)
                GlassContainer(
                  padding: const EdgeInsets.all(16),
                  onTap: () => widget.onOpenEventDetail(_selectedEvent!),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.warningOrange.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.warningOrange, width: 1),
                        ),
                        child: const Icon(
                          Icons.alt_route_rounded,
                          color: AppColors.warningOrange,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedEvent!.title,
                              style: AppTypography.titleMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _selectedEvent!.locationName,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  "${_selectedEvent!.distanceKm ?? 1.2} km • 30 min ago",
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textMuted,
                                    fontSize: 10,
                                  ),
                                ),
                                if (_selectedEvent!.alternateRouteAvailable) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0x335DE1E6),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "Alternate route available",
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.cyan,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.textMuted,
                        size: 24,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
