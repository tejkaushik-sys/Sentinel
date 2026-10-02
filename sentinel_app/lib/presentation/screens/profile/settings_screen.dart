import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../widgets/glass_container.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback onOpenMoments;

  const SettingsScreen({super.key, required this.onOpenMoments});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _redAlertsEnabled = true;
  bool _sentinelMomentsEnabled = true;
  final bool _journeyMonitoring = true;
  bool _hapticsEnabled = true;
  bool _backgroundLocation = true;
  bool _anonymousReports = true;

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
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 4),
                  Text("Settings & Privacy", style: AppTypography.headlineLarge),
                ],
              ),
              const SizedBox(height: 20),

              _buildSectionTitle("NOTIFICATIONS & ALERTS"),
              const SizedBox(height: 8),
              GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSwitchTile(
                      "Critical Red Alerts",
                      "Controlled high-priority emergency notifications",
                      _redAlertsEnabled,
                      (v) => setState(() => _redAlertsEnabled = v),
                      activeColor: AppColors.criticalRed,
                    ),
                    const Divider(color: AppColors.border, height: 20),
                    _buildSwitchTile(
                      "Sentinel Moments",
                      "Personalized calm briefings and journey suggestions",
                      _sentinelMomentsEnabled,
                      (v) => setState(() => _sentinelMomentsEnabled = v),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: widget.onOpenMoments,
                      icon: const Icon(Icons.wb_sunny_outlined, size: 16),
                      label: const Text("Preview Sentinel Moments"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surfaceHighlight,
                        foregroundColor: AppColors.cyan,
                        minimumSize: const Size.fromHeight(40),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _buildSectionTitle("PRIVACY CENTER"),
              const SizedBox(height: 8),
              GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSwitchTile(
                      "Background Location for Journey",
                      "Only evaluates active route hazards when moving",
                      _backgroundLocation,
                      (v) => setState(() => _backgroundLocation = v),
                    ),
                    const Divider(color: AppColors.border, height: 20),
                    _buildSwitchTile(
                      "Anonymous Community Reporting",
                      "Hides reporter identity when submitting incidents",
                      _anonymousReports,
                      (v) => setState(() => _anonymousReports = v),
                    ),
                    const Divider(color: AppColors.border, height: 20),
                    _buildSwitchTile(
                      "Haptic Sensory Feedback",
                      "Subtle vibration feedback on alerts and markers",
                      _hapticsEnabled,
                      (v) => setState(() => _hapticsEnabled = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              _buildSectionTitle("DATA & CACHE"),
              const SizedBox(height: 8),
              GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Offline Intelligence Cache", style: AppTypography.titleMedium),
                            const SizedBox(height: 2),
                            Text("12 MB local geospatial buffer", style: AppTypography.bodySmall),
                          ],
                        ),
                        OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Offline cache refreshed successfully!"),
                                backgroundColor: AppColors.cyanDark,
                              ),
                            );
                          },
                          child: const Text("Clear Cache"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  "Sentinel v1.0.0 • Know. Verify. Decide.",
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.bodySmall.copyWith(
        letterSpacing: 1.2,
        fontWeight: FontWeight.w700,
        color: AppColors.textMuted,
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged, {Color? activeColor}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.titleMedium.copyWith(fontSize: 14)),
              const SizedBox(height: 2),
              Text(subtitle, style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeTrackColor: (activeColor ?? AppColors.cyan).withValues(alpha: 0.5),
          activeThumbColor: activeColor ?? AppColors.cyan,
        ),
      ],
    );
  }
}
