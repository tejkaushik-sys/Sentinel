import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/user_model.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/interactive_mascot.dart';
import '../verify/verify_screen.dart';
import 'my_searches_screen.dart';
import 'trusted_circle_screen.dart';
import 'my_places_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  final Function(String) onOpenDestinationBriefing;
  final VoidCallback onOpenMoments;

  const ProfileScreen({
    super.key,
    required this.onOpenDestinationBriefing,
    required this.onOpenMoments,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final user = await apiClient.getUserProfile();
    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
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
              Text("Profile", style: AppTypography.headlineLarge),
              const SizedBox(height: 20),

              // User Info Card
              GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceHighlight,
                        border: Border.all(color: AppColors.cyan, width: 1.5),
                      ),
                      child: const Center(
                        child: Icon(Icons.person_rounded, color: AppColors.cyan, size: 30),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _user?.name ?? "Mahi",
                            style: AppTypography.headlineMedium.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _user?.email ?? "mahi@kiit.ac.in",
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.cyan, size: 20),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Menu List
              _buildMenuItem(
                "My Places",
                "Home, Work, College...",
                Icons.location_on_outlined,
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MyPlacesScreen()),
                  );
                },
              ),
              _buildMenuItem(
                "Trusted Circle",
                "Family & Friends",
                Icons.group_outlined,
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TrustedCircleScreen()),
                  );
                },
              ),
              _buildMenuItem(
                "Journey History",
                "View past journeys",
                Icons.alt_route_rounded,
                () {
                  widget.onOpenDestinationBriefing("KIIT University -> Home");
                },
              ),
              _buildMenuItem(
                "Reports",
                "My submissions",
                Icons.assignment_turned_in_outlined,
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("You have 1 active verified community report near Patia."),
                      backgroundColor: AppColors.cyanDark,
                    ),
                  );
                },
              ),
              _buildMenuItem(
                "Verification History",
                "People / Cases / Claims",
                Icons.verified_user_outlined,
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const VerifyScreen()),
                  );
                },
              ),
              _buildMenuItem(
                "My Searches",
                "Your past searches, saved",
                Icons.history_rounded,
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MySearchesScreen(
                        onSelectSearch: (query) => widget.onOpenDestinationBriefing(query),
                      ),
                    ),
                  );
                },
              ),
              _buildMenuItem(
                "Settings",
                "Notifications, Privacy, Theme",
                Icons.settings_outlined,
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SettingsScreen(onOpenMoments: widget.onOpenMoments),
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),

              // Sentinel Pro Upgrade Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppColors.proGradient,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.purple.withValues(alpha: 0.6), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.purple.withValues(alpha: 0.2),
                      blurRadius: 18,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.purple.withValues(alpha: 0.2),
                      ),
                      child: const Icon(Icons.shield_rounded, color: AppColors.purple, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sentinel Pro",
                            style: AppTypography.titleLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "More features, more control",
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Sentinel Pro features unlocked for this session!"),
                            backgroundColor: AppColors.purple,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text("Upgrade"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Interactive Mascot Widget
              InteractiveMascotWidget(
                onTapRoute: () => widget.onOpenDestinationBriefing("Home (Sector 7, Patia)"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: AppColors.cyan, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleMedium.copyWith(fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 22),
          ],
        ),
      ),
    );
  }
}
