import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/destination_model.dart';
import '../../widgets/glass_container.dart';

class DestinationBriefingScreen extends StatefulWidget {
  final String destinationName;

  const DestinationBriefingScreen({
    super.key,
    this.destinationName = "Patia, Bhubaneswar",
  });

  @override
  State<DestinationBriefingScreen> createState() => _DestinationBriefingScreenState();
}

class _DestinationBriefingScreenState extends State<DestinationBriefingScreen> {
  late TextEditingController _searchController;
  DestinationBriefingModel? _briefing;
  String _selectedTimeSlot = "Now";
  bool _isLoading = true;
  bool _showFullDetails = false;

  final List<String> _timeSlots = ["Now", "6 PM", "9 PM", "12 AM"];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: "Is Patia safe at night?");
    _fetchBriefing(widget.destinationName);
  }

  void _fetchBriefing(String destination) async {
    setState(() {
      _isLoading = true;
    });
    final briefing = await apiClient.getDestinationBriefing(
      destination: destination,
      timeSlot: _selectedTimeSlot,
    );
    if (mounted) {
      setState(() {
        _briefing = briefing;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              // Search Header Row
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border, width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                              decoration: const InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onSubmitted: (val) {
                                if (val.isNotEmpty) _fetchBriefing(val);
                              },
                            ),
                          ),
                          const Icon(Icons.mic_none_rounded, color: AppColors.cyan, size: 18),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Destination Title
              Text(
                _briefing?.destinationName ?? widget.destinationName,
                style: AppTypography.headlineLarge.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 14),

              // Time Slot Filters (Now, 6 PM, 9 PM, 12 AM)
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _timeSlots.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final slot = _timeSlots[index];
                    final isSelected = _selectedTimeSlot == slot;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTimeSlot = slot;
                        });
                        _fetchBriefing(_briefing?.destinationName ?? widget.destinationName);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.cyan : AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isSelected ? AppColors.cyan : AppColors.border,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            slot,
                            style: AppTypography.bodySmall.copyWith(
                              color: isSelected ? const Color(0xFF07141C) : AppColors.textSecondary,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: AppColors.cyan),
                  ),
                )
              else if (_briefing != null) ...[
                // Status Pill Card ("Generally calm")
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0x3362D6A7), Color(0x1162D6A7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.emerald.withValues(alpha: 0.6), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.emerald.withValues(alpha: 0.15),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.emerald.withValues(alpha: 0.2),
                        ),
                        child: const Icon(Icons.verified_user_rounded, color: AppColors.emerald, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _briefing!.statusLabel,
                              style: AppTypography.titleLarge.copyWith(
                                color: AppColors.emerald,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _briefing!.statusDescription,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Recent Signals Section
                Text(
                  "Recent signals",
                  style: AppTypography.headlineMedium.copyWith(fontSize: 17),
                ),
                const SizedBox(height: 12),

                ..._briefing!.signalsSummary.map((sig) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GlassContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            _getSignalIcon(sig['type']),
                            color: _getSignalColor(sig['type']),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              sig['text'] ?? '',
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 12),

                // View Details Button / Expanded Details
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showFullDetails = !_showFullDetails;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        _showFullDetails ? "Hide details" : "View details",
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.cyan,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        _showFullDetails ? Icons.keyboard_arrow_up_rounded : Icons.chevron_right_rounded,
                        color: AppColors.cyan,
                        size: 18,
                      ),
                    ],
                  ),
                ),

                if (_showFullDetails) ...[
                  const SizedBox(height: 16),
                  GlassContainer(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Active Advisories", style: AppTypography.titleMedium),
                        const SizedBox(height: 6),
                        ..._briefing!.activeAdvisories.map((a) => Text("• $a", style: AppTypography.bodyMedium)),
                        const SizedBox(height: 12),
                        Text("Transport Disruptions", style: AppTypography.titleMedium),
                        const SizedBox(height: 6),
                        ..._briefing!.transportDisruptions.map((t) => Text("• $t", style: AppTypography.bodyMedium)),
                        const SizedBox(height: 12),
                        Text("Source Confidence", style: AppTypography.titleMedium),
                        const SizedBox(height: 4),
                        Text(_briefing!.confidenceSummary, style: AppTypography.bodySmall),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 28),

                // Disclaimer Footer
                Center(
                  child: Text(
                    _briefing!.disclaimer,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 10,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getSignalIcon(String? type) {
    switch (type) {
      case 'minor':
        return Icons.warning_amber_rounded;
      case 'traffic':
        return Icons.traffic_rounded;
      case 'shield':
        return Icons.shield_outlined;
      default:
        return Icons.info_outline_rounded;
    }
  }

  Color _getSignalColor(String? type) {
    switch (type) {
      case 'minor':
        return AppColors.warningOrange;
      case 'traffic':
        return AppColors.criticalRed;
      case 'shield':
        return AppColors.cyan;
      default:
        return AppColors.emerald;
    }
  }
}
