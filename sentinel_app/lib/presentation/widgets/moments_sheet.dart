import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/moment_model.dart';
import 'glass_container.dart';

class MomentsSheet extends StatelessWidget {
  final List<SentinelMomentModel> moments;
  final Function(SentinelMomentModel)? onSelectMoment;

  const MomentsSheet({
    super.key,
    required this.moments,
    this.onSelectMoment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF07141C),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: AppColors.border, width: 1.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Sentinel Moments",
                    style: AppTypography.headlineLarge,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderLight, width: 0.8),
                    ),
                    child: Text(
                      "Personalized",
                      style: AppTypography.bodySmall.copyWith(color: AppColors.cyan),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              ...moments.map((moment) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GlassContainer(
                      padding: const EdgeInsets.all(16),
                      onTap: onSelectMoment != null ? () => onSelectMoment!(moment) : null,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getIconBackgroundColor(moment.iconType),
                            ),
                            child: Icon(
                              _getMomentIcon(moment.iconType),
                              size: 20,
                              color: _getIconColor(moment.iconType),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        moment.title,
                                        style: AppTypography.titleLarge.copyWith(fontSize: 14),
                                      ),
                                    ),
                                    Text(
                                      moment.timestampDisplay,
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.textMuted,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  moment.body,
                                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),

              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(44),
                ),
                child: const Text("Close Moments"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getMomentIcon(String iconType) {
    switch (iconType) {
      case 'sun':
        return Icons.wb_sunny_rounded;
      case 'umbrella':
        return Icons.umbrella_rounded;
      case 'food':
        return Icons.restaurant_rounded;
      case 'moon':
        return Icons.nightlight_round;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getIconColor(String iconType) {
    switch (iconType) {
      case 'sun':
        return AppColors.gold;
      case 'umbrella':
        return AppColors.cyan;
      case 'food':
        return AppColors.warningOrange;
      case 'moon':
        return AppColors.purple;
      default:
        return AppColors.cyan;
    }
  }

  Color _getIconBackgroundColor(String iconType) {
    return _getIconColor(iconType).withValues(alpha: 0.15);
  }
}
