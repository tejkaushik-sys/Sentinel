import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class InteractiveMascotWidget extends StatefulWidget {
  final VoidCallback? onTapRoute;

  const InteractiveMascotWidget({super.key, this.onTapRoute});

  @override
  State<InteractiveMascotWidget> createState() => _InteractiveMascotWidgetState();
}

class _InteractiveMascotWidgetState extends State<InteractiveMascotWidget> with SingleTickerProviderStateMixin {
  late AnimationController _bobController;

  @override
  void initState() {
    super.initState();
    _bobController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF09202A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.cyan,
                ),
                child: const Center(
                  child: Text(
                    "S",
                    style: TextStyle(
                      color: AppColors.background,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Sentinel",
                style: AppTypography.titleMedium.copyWith(color: AppColors.cyan),
              ),
              const Spacer(),
              Text("now", style: AppTypography.bodySmall),
            ],
          ),
          const SizedBox(height: 10),

          // Message
          Text(
            "Mai tenu samjhawan ki... 😴\nLooks like traffic is lighter now. You can leave in 10 minutes.",
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary, height: 1.4),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: widget.onTapRoute,
            child: Text(
              "Tap to view route →",
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.cyan,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Mascot Row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Speech bubble
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(16).copyWith(
                    bottomRight: const Radius.circular(2),
                  ),
                  border: Border.all(color: AppColors.borderLight, width: 1),
                ),
                child: Text(
                  "You're almost there! 🐾",
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Animated Mascot
              AnimatedBuilder(
                animation: _bobController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -(_bobController.value * 4)),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF143744),
                        border: Border.all(color: AppColors.cyan, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cyan.withValues(alpha: 0.3),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "🐱",
                          style: TextStyle(fontSize: 26),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
