import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/services/location_service.dart';
import 'main_navigation_shell.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _badgeController;

  @override
  void initState() {
    super.initState();
    _badgeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _badgeController.dispose();
    super.dispose();
  }

  void _completeOnboarding() async {
    // Request location permission seamlessly
    await locationService.determinePosition();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainNavigationShell(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF071720),
                  Color(0xFF0D2530),
                  Color(0xFF143B4A),
                  Color(0xFF07141C),
                ],
                stops: [0.0, 0.4, 0.7, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Central Graphic Container with floating tags
          Positioned(
            top: MediaQuery.of(context).size.height * 0.12,
            left: 20,
            right: 20,
            height: MediaQuery.of(context).size.height * 0.45,
            child: AnimatedBuilder(
              animation: _badgeController,
              builder: (context, child) {
                final double floatOffset = _badgeController.value * 8;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Center city silhouette / silhouette portrait
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF0B2129),
                        border: Border.all(color: AppColors.borderGlow, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cyan.withValues(alpha: 0.25),
                            blurRadius: 30,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.radar_rounded,
                          size: 72,
                          color: AppColors.cyan,
                        ),
                      ),
                    ),

                    // Badge 1: Local News
                    Positioned(
                      top: 10 + floatOffset,
                      left: 30,
                      child: _buildPillBadge("Local News", Icons.article_outlined, AppColors.emerald),
                    ),

                    // Badge 2: Weather
                    Positioned(
                      top: 45 - floatOffset,
                      right: 20,
                      child: _buildPillBadge("Weather", Icons.wb_sunny_outlined, AppColors.gold),
                    ),

                    // Badge 3: Safety
                    Positioned(
                      bottom: 40 + floatOffset,
                      left: 20,
                      child: _buildPillBadge("Safety", Icons.shield_outlined, AppColors.cyan),
                    ),

                    // Badge 4: Traffic
                    Positioned(
                      bottom: 20 - floatOffset,
                      right: 35,
                      child: _buildPillBadge("Traffic", Icons.directions_car_outlined, AppColors.warningOrange),
                    ),
                  ],
                );
              },
            ),
          ),

          // Bottom Content
          Positioned(
            bottom: 30,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Real-Time\nLocal Intelligence",
                  style: AppTypography.displayLarge.copyWith(
                    fontSize: 30,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "From news to hazards, get the complete picture of what's happening around you.",
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 36),

                // Next Button
                Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFE8F7F8),
                        Color(0xFF9DECF9),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.cyan.withValues(alpha: 0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(28),
                      onTap: _completeOnboarding,
                      child: Center(
                        child: Text(
                          "Next",
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillBadge(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xEE0B2129),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.7), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
