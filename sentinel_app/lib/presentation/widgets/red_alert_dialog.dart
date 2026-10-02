import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/event_model.dart';

class RedAlertDialog extends StatelessWidget {
  final EventModel event;
  final VoidCallback onViewDetails;

  const RedAlertDialog({
    super.key,
    required this.event,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.redAlertGradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.criticalRed, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: AppColors.criticalRed.withValues(alpha: 0.4),
              blurRadius: 30,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.criticalRed.withValues(alpha: 0.25),
                  ),
                  child: const Icon(
                    Icons.notifications_active_rounded,
                    color: AppColors.criticalRed,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Red Alert",
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.criticalRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close_rounded, color: AppColors.textMuted, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Alert Title
            Text(
              event.title,
              style: AppTypography.headlineLarge.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 6),

            // Metadata row
            Text(
              "${event.locationName} • ${event.distanceKm ?? 0.8} km • Corroborated",
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              event.description,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 18),

            // Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onViewDetails();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.criticalRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("View Details"),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: Color(0x66FF6262)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text("Dismiss"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
