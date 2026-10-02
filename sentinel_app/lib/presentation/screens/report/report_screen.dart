import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/location_service.dart';
import '../../widgets/glass_container.dart';

class ReportScreen extends StatefulWidget {
  final VoidCallback? onReportSubmitted;

  const ReportScreen({super.key, this.onReportSubmitted});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String _selectedCategory = "Road";
  final TextEditingController _descController = TextEditingController();
  bool _hasPhotoAttached = false;
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _reportCategories = [
    {"name": "Road", "icon": Icons.alt_route_rounded, "color": AppColors.catRoad},
    {"name": "Accident", "icon": Icons.car_crash_rounded, "color": AppColors.catAccident},
    {"name": "Fire", "icon": Icons.local_fire_department_rounded, "color": AppColors.catFire},
    {"name": "Lighting", "icon": Icons.lightbulb_outline_rounded, "color": AppColors.catLighting},
    {"name": "Flood", "icon": Icons.water_damage_rounded, "color": AppColors.catFlood},
    {"name": "Hazard", "icon": Icons.warning_amber_rounded, "color": AppColors.catHazard},
    {"name": "News", "icon": Icons.article_outlined, "color": AppColors.catNews},
    {"name": "Other", "icon": Icons.more_horiz_rounded, "color": AppColors.catOther},
  ];

  void _submitReport() async {
    setState(() {
      _isSubmitting = true;
    });

    final pos = locationService.currentLocation;
    await apiClient.submitReport(
      category: _selectedCategory,
      title: "$_selectedCategory Incident at ${pos.cityName}",
      description: _descController.text.trim().isNotEmpty
          ? _descController.text.trim()
          : "$_selectedCategory reported by citizen near ${pos.cityName}",
      latitude: pos.latitude,
      longitude: pos.longitude,
      locationName: "Patia, ${pos.cityName}",
    );

    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _descController.clear();
        _hasPhotoAttached = false;
      });

      if (widget.onReportSubmitted != null) {
        widget.onReportSubmitted!();
      }
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
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
                children: [
                  const Icon(Icons.add_circle_outline_rounded, color: AppColors.cyan, size: 22),
                  const SizedBox(width: 8),
                  Text("Report", style: AppTypography.headlineLarge),
                ],
              ),
              const SizedBox(height: 20),

              // "What's happening?" Title
              Text(
                "What's happening?",
                style: AppTypography.headlineMedium.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 14),

              // 8 Category Tiles Grid (2 rows x 4 columns)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _reportCategories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final cat = _reportCategories[index];
                  final isSelected = _selectedCategory == cat["name"];
                  final Color catColor = cat["color"];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat["name"];
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? catColor.withValues(alpha: 0.2)
                            : AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? catColor : AppColors.border,
                          width: isSelected ? 1.8 : 1.0,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: catColor.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            cat["icon"],
                            color: isSelected ? catColor : AppColors.textSecondary,
                            size: 26,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat["name"],
                            style: AppTypography.bodySmall.copyWith(
                              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Photo/Video Attachment Card
              GestureDetector(
                onTap: () {
                  setState(() {
                    _hasPhotoAttached = !_hasPhotoAttached;
                  });
                },
                child: GlassContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceHighlight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _hasPhotoAttached ? Icons.check_circle_rounded : Icons.camera_alt_outlined,
                          color: _hasPhotoAttached ? AppColors.emerald : AppColors.cyan,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _hasPhotoAttached ? "Photo Attached (IMG_2026.jpg)" : "Add photo / video",
                              style: AppTypography.titleMedium.copyWith(fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _hasPhotoAttached ? "Tap to remove" : "Tap to add",
                              style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Description Field
              Text(
                "Describe the situation (optional)",
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                maxLines: 3,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: "E.g. details, people involved, road condition, etc.",
                  hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 20),

              // Location Picker
              GlassContainer(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: AppColors.cyan, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Location", style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
                          const SizedBox(height: 2),
                          Text(
                            "Use current location (Patia, Bhubaneswar)",
                            style: AppTypography.titleMedium.copyWith(color: AppColors.cyan, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Submit Button
              Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE8F7F8), Color(0xFF9DECF9)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cyan.withValues(alpha: 0.35),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(26),
                    onTap: _isSubmitting ? null : _submitReport,
                    child: Center(
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF07141C)),
                            )
                          : Text(
                              "Submit",
                              style: AppTypography.labelLarge.copyWith(
                                color: const Color(0xFF07141C),
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
