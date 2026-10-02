import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/event_model.dart';
import 'glass_container.dart';

class EventDetailSheet extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onUseAlternateRoute;

  const EventDetailSheet({
    super.key,
    required this.event,
    this.onUseAlternateRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF081923),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: AppColors.borderGlow, width: 1.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pull handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textDisabled,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category & Status row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(event.category).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _getCategoryColor(event.category), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getCategoryIcon(event.category),
                          size: 14,
                          color: _getCategoryColor(event.category),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          event.category.toUpperCase(),
                          style: AppTypography.bodySmall.copyWith(
                            color: _getCategoryColor(event.category),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: Text(
                      event.status,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Title & Location
              Text(
                event.title,
                style: AppTypography.headlineLarge,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: AppColors.cyan),
                  const SizedBox(width: 4),
                  Text(
                    event.locationName,
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.cyan, fontWeight: FontWeight.w600),
                  ),
                  if (event.distanceKm != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      "• ${event.distanceKm} km away",
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),

              // WHAT HAPPENED
              _buildSectionHeader("WHAT HAPPENED"),
              const SizedBox(height: 6),
              Text(
                event.description,
                style: AppTypography.bodyLarge,
              ),
              const SizedBox(height: 16),

              // WHY IT MATTERS
              if (event.whyItMatters != null) ...[
                _buildSectionHeader("WHY IT MATTERS"),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0x33F4C96B),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gold.withValues(alpha: 0.5), width: 1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.gold),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          event.whyItMatters!,
                          style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // CONFIDENCE / VERIFICATION
              _buildSectionHeader("CONFIDENCE & VERIFICATION"),
              const SizedBox(height: 8),
              GlassContainer(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Corroborated by ${event.corroborationCount} independent sources",
                          style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "${(event.confidenceScore * 100).toInt()}%",
                          style: AppTypography.titleMedium.copyWith(color: AppColors.emerald),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: event.confidenceScore,
                        backgroundColor: AppColors.surfaceElevated,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.emerald),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // SOURCES
              if (event.sources.isNotEmpty) ...[
                _buildSectionHeader("VERIFIED SOURCES (${event.sources.length})"),
                const SizedBox(height: 8),
                ...event.sources.map((src) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GlassContainer(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.verified_rounded, size: 16, color: AppColors.cyan),
                                    const SizedBox(width: 6),
                                    Text(
                                      src.name,
                                      style: AppTypography.titleMedium.copyWith(fontSize: 13),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceHighlight,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    src.publisherType.toUpperCase(),
                                    style: AppTypography.bodySmall.copyWith(
                                      fontSize: 9,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              src.headline,
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                            ),
                            if (src.snippet.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                src.snippet,
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ],
                        ),
                      ),
                    )),
                const SizedBox(height: 16),
              ],

              // Alternate Route Action if applicable
              if (event.alternateRouteAvailable) ...[
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onUseAlternateRoute != null) onUseAlternateRoute!();
                  },
                  icon: const Icon(Icons.alt_route_rounded),
                  label: Text("Use Alternate Route (+${event.delayMinutes} min)"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: AppColors.cyan,
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Close / Dismiss
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                ),
                child: const Text("Close"),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.bodySmall.copyWith(
        letterSpacing: 1.2,
        fontWeight: FontWeight.w700,
        color: AppColors.textMuted,
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'fire':
      case 'accident':
        return AppColors.criticalRed;
      case 'traffic':
        return AppColors.warningOrange;
      case 'road':
        return AppColors.cyan;
      case 'weather':
        return const Color(0xFF38B2AC);
      case 'news':
        return AppColors.emerald;
      default:
        return AppColors.gold;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fire':
        return Icons.local_fire_department_rounded;
      case 'accident':
        return Icons.car_crash_rounded;
      case 'traffic':
        return Icons.directions_car_rounded;
      case 'road':
        return Icons.alt_route_rounded;
      case 'weather':
        return Icons.cloud_outlined;
      case 'news':
        return Icons.newspaper_rounded;
      default:
        return Icons.shield_outlined;
    }
  }
}
