import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../data/models/event_model.dart';

class AnimatedRadarMap extends StatefulWidget {
  final List<EventModel> events;
  final EventModel? selectedEvent;
  final Function(EventModel) onSelectEvent;
  final VoidCallback? onRecenter;
  final double height;

  const AnimatedRadarMap({
    super.key,
    required this.events,
    this.selectedEvent,
    required this.onSelectEvent,
    this.onRecenter,
    this.height = 360,
  });

  @override
  State<AnimatedRadarMap> createState() => _AnimatedRadarMapState();
}

class _AnimatedRadarMapState extends State<AnimatedRadarMap> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
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
            // Custom Radar Grid & Concentric Waves
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _RadarMapPainter(
                    animationValue: _controller.value,
                  ),
                );
              },
            ),

            // Center "You" User Marker
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.cyan.withValues(alpha: 0.25),
                      border: Border.all(color: AppColors.cyan, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cyan.withValues(alpha: 0.6),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.cyan,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xCC07141C),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderLight, width: 0.8),
                    ),
                    child: Text(
                      "You",
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.cyan,
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Event Marker Pins mapped across the radar coordinates
            ...widget.events.asMap().entries.map((entry) {
              final idx = entry.key;
              final event = entry.value;

              // Compute coordinate relative offset
              final double angle = (idx * 1.3) + 0.4;
              final double radius = 55.0 + (idx * 38.0);

              final bool isSelected = widget.selectedEvent?.eventId == event.eventId;
              final Color markerColor = _getCategoryColor(event.category, event.isRedAlert);

              return Positioned(
                left: (MediaQuery.of(context).size.width / 2) + (math.cos(angle) * radius) - 18,
                top: (widget.height / 2) + (math.sin(angle) * (radius * 0.7)) - 18,
                child: GestureDetector(
                  onTap: () => widget.onSelectEvent(event),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.all(isSelected ? 6 : 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? markerColor : const Color(0xEE0B2129),
                      border: Border.all(
                        color: markerColor,
                        width: isSelected ? 2.5 : 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: markerColor.withValues(alpha: isSelected ? 0.8 : 0.4),
                          blurRadius: isSelected ? 16 : 8,
                          spreadRadius: isSelected ? 3 : 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      _getCategoryIcon(event.category),
                      size: isSelected ? 18 : 14,
                      color: isSelected ? Colors.white : markerColor,
                    ),
                  ),
                ),
              );
            }),

            // Top GPS Recenter Action
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: widget.onRecenter,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xCC0C2730),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderLight, width: 1),
                  ),
                  child: const Icon(
                    Icons.my_location_rounded,
                    size: 18,
                    color: AppColors.cyan,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category, bool isRedAlert) {
    if (isRedAlert) return AppColors.criticalRed;
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

class _RadarMapPainter extends CustomPainter {
  final double animationValue;

  _RadarMapPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 1. Draw subtle background city road grid
    final gridPaint = Paint()
      ..color = const Color(0xFF102D36).withValues(alpha: 0.35)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double j = 0; j < size.height; j += 40) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), gridPaint);
    }

    // 2. Draw curved road lines
    final roadPaint = Paint()
      ..color = const Color(0xFF163E4B).withValues(alpha: 0.5)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final path1 = Path()
      ..moveTo(0, size.height * 0.3)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.25, size.width, size.height * 0.6);
    canvas.drawPath(path1, roadPaint);

    final path2 = Path()
      ..moveTo(size.width * 0.2, 0)
      ..quadraticBezierTo(size.width * 0.6, size.height * 0.5, size.width * 0.8, size.height);
    canvas.drawPath(path2, roadPaint);

    // 3. Draw concentric radar range rings
    final ringPaint = Paint()
      ..color = AppColors.cyan.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const ringRadii = [45.0, 90.0, 135.0, 180.0];
    for (final r in ringRadii) {
      canvas.drawCircle(center, r, ringPaint);
    }

    // 4. Expanding pulse wave animation
    final double pulseRadius = (animationValue * 180.0);
    final double pulseAlpha = (1.0 - animationValue).clamp(0.0, 1.0) * 0.4;
    final pulsePaint = Paint()
      ..color = AppColors.cyan.withValues(alpha: pulseAlpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, pulseRadius, pulsePaint);

    // 5. Radar sweep beam
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: 0.0,
        endAngle: math.pi / 2,
        colors: [
          AppColors.cyan.withValues(alpha: 0.25),
          AppColors.cyan.withValues(alpha: 0.0),
        ],
        transform: GradientRotation(animationValue * 2 * math.pi),
      ).createShader(Rect.fromCircle(center: center, radius: 180));

    canvas.drawCircle(center, 180, sweepPaint);
  }

  @override
  bool shouldRepaint(covariant _RadarMapPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
