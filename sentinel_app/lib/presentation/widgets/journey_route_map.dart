import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/journey_model.dart';

class JourneyRouteMap extends StatefulWidget {
  final JourneyPlanModel journey;
  final bool isAlternative;
  final double height;

  const JourneyRouteMap({
    super.key,
    required this.journey,
    this.isAlternative = false,
    this.height = 340,
  });

  @override
  State<JourneyRouteMap> createState() => _JourneyRouteMapState();
}

class _JourneyRouteMapState extends State<JourneyRouteMap> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF06151D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background Route Painter
            AnimatedBuilder(
              animation: _progressController,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _JourneyRoutePainter(
                    progress: _progressController.value,
                    isAlternative: widget.isAlternative,
                  ),
                );
              },
            ),

            // Origin Marker Pin (KIIT University)
            Positioned(
              left: 36,
              bottom: 60,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.cyan,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cyan.withValues(alpha: 0.8),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.navigation_rounded,
                      size: 14,
                      color: Color(0xFF07141C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xCC07141C),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderLight, width: 0.8),
                    ),
                    child: Text(
                      "KIIT Univ",
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.cyan,
                        fontWeight: FontWeight.w600,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Destination Marker Pin (Home)
            Positioned(
              right: 36,
              top: 50,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.criticalRed,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.criticalRed.withValues(alpha: 0.8),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xCC07141C),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderLight, width: 0.8),
                    ),
                    child: Text(
                      "Home",
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.criticalRed,
                        fontWeight: FontWeight.w600,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Waypoint Hazard Marker on Route (Patia Mart road work)
            if (!widget.isAlternative)
              Positioned(
                left: MediaQuery.of(context).size.width * 0.45,
                top: widget.height * 0.42,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.warningOrange,
                    border: Border.all(color: Colors.white, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.warningOrange.withValues(alpha: 0.8),
                        blurRadius: 14,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    size: 12,
                    color: Color(0xFF07141C),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _JourneyRoutePainter extends CustomPainter {
  final double progress;
  final bool isAlternative;

  _JourneyRoutePainter({
    required this.progress,
    required this.isAlternative,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw city road network grid
    final gridPaint = Paint()
      ..color = const Color(0xFF102D36).withValues(alpha: 0.35)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 35) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double j = 0; j < size.height; j += 35) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), gridPaint);
    }

    final start = Offset(45, size.height - 75);
    final end = Offset(size.width - 45, 65);

    // 2. Primary Route Path
    final routePath = Path();
    routePath.moveTo(start.dx, start.dy);

    if (isAlternative) {
      // Alternate detour route bypassing the disruption
      routePath.cubicTo(
        size.width * 0.15, size.height * 0.35,
        size.width * 0.55, size.height * 0.8,
        end.dx, end.dy,
      );
    } else {
      // Standard route with slight detour curve
      routePath.cubicTo(
        size.width * 0.3, size.height * 0.8,
        size.width * 0.45, size.height * 0.3,
        end.dx, end.dy,
      );
    }

    // Outer glow
    final glowPaint = Paint()
      ..color = (isAlternative ? AppColors.emerald : AppColors.cyan).withValues(alpha: 0.3)
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(routePath, glowPaint);

    // Inner line
    final routePaint = Paint()
      ..shader = LinearGradient(
        colors: isAlternative
            ? [AppColors.emerald, AppColors.cyan]
            : [AppColors.cyan, AppColors.gold],
      ).createShader(Rect.fromPoints(start, end))
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(routePath, routePaint);
  }

  @override
  bool shouldRepaint(covariant _JourneyRoutePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isAlternative != isAlternative;
  }
}
