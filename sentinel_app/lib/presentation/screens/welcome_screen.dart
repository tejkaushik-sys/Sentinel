import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'onboarding_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Sunset Vista & Mountain Mist
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF06151E),
                  Color(0xFF0F2D38),
                  Color(0xFF283B46),
                  Color(0xFF5A393E), // warm sunset alpine haze
                  Color(0xFF2B1D25),
                ],
                stops: [0.0, 0.35, 0.6, 0.85, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Mountain & Sunset Sun Graphic
          Positioned(
            top: MediaQuery.of(context).size.height * 0.32,
            right: 40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFCC80).withValues(alpha: 0.9),
                    const Color(0xFFFF8A65).withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Content Layer
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),

                  // Headline
                  Text(
                    "The world is\nalways changing.",
                    style: AppTypography.displayLarge.copyWith(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Paragraph
                  Text(
                    "You don't need to\nwatch everything.\n\nWe'll help you notice\nwhat matters.",
                    style: AppTypography.bodyLarge.copyWith(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),

                  const Spacer(),

                  // "Get Started" Pill Button
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFE8F7F8),
                            Color(0xFF9DECF9),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.cyan.withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(28),
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => const OnboardingScreen(),
                                transitionsBuilder: (_, animation, __, child) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero,
                                    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                                    child: child,
                                  );
                                },
                                transitionDuration: const Duration(milliseconds: 400),
                              ),
                            );
                          },
                          child: Center(
                            child: Text(
                              "Get Started",
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
                  ),
                  const SizedBox(height: 24),

                  // Dots carousel indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 18,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.cyan,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 6,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.textDisabled,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 6,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.textDisabled,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Brand name
                  Center(
                    child: Text(
                      "SENTINEL",
                      style: AppTypography.brandTagline.copyWith(
                        fontSize: 11,
                        letterSpacing: 4.0,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
