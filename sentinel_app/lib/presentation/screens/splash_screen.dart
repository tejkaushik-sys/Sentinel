import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeIn)),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic)),
    );

    _glowAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0, curve: Curves.easeInOut)),
    );

    _controller.forward();

    // Smooth transition to Welcome screen after 2.8 seconds
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const WelcomeScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 700),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Gradient with warm horizon glow at bottom
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF07141C),
                  Color(0xFF0A222B),
                  Color(0xFF132F3A),
                  Color(0xFF262024), // warm sunset city reflection
                ],
                stops: [0.0, 0.45, 0.75, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // City Horizon Silhouette at base
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 180,
            child: CustomPaint(
              painter: _CityHorizonPainter(),
            ),
          ),

          // Center Logo & Brand Identity
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Stylized "S" Emblem with outer cyan glow
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF0C2B36),
                            border: Border.all(
                              color: AppColors.cyan.withValues(alpha: 0.8),
                              width: 2.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.cyan.withValues(alpha: 0.5 * _glowAnimation.value),
                                blurRadius: 36,
                                spreadRadius: 6,
                              ),
                            ],
                          ),
                          child: Center(
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Colors.white, AppColors.cyan, Color(0xFF3AA8B0)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: const Text(
                                "S",
                                style: TextStyle(
                                  fontSize: 54,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  fontFamily: 'Outfit',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // SENTINEL Brand Name
                        Text(
                          "SENTINEL",
                          style: AppTypography.displayLarge.copyWith(
                            fontSize: 28,
                            letterSpacing: 6.0,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Tagline: Know. Verify. Decide.
                        Text(
                          "Know. Verify. Decide.",
                          style: AppTypography.brandTagline.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CityHorizonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF061016).withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.6);
    path.lineTo(size.width * 0.1, size.height * 0.45);
    path.lineTo(size.width * 0.15, size.height * 0.5);
    path.lineTo(size.width * 0.25, size.height * 0.35);
    path.lineTo(size.width * 0.3, size.height * 0.4);
    path.lineTo(size.width * 0.4, size.height * 0.25);
    path.lineTo(size.width * 0.5, size.height * 0.3);
    path.lineTo(size.width * 0.65, size.height * 0.2);
    path.lineTo(size.width * 0.75, size.height * 0.4);
    path.lineTo(size.width * 0.85, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.5);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Subtle warm golden light spots on horizon
    final lightPaint = Paint()
      ..color = const Color(0x33F4C96B)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.4), 25, lightPaint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.35), 30, lightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
