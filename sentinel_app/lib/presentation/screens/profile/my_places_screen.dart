import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/user_model.dart';
import '../../widgets/glass_container.dart';

class MyPlacesScreen extends StatelessWidget {
  const MyPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final places = [
      SavedPlaceModel(id: "1", name: "Home", label: "Home", address: "Sector 7, Patia, Bhubaneswar", latitude: 20.3601, longitude: 85.8210),
      SavedPlaceModel(id: "2", name: "KIIT University Campus 6", label: "College", address: "KIIT Road, Patia", latitude: 20.3547, longitude: 85.8155),
      SavedPlaceModel(id: "3", name: "Infocity DLF Cybercity", label: "Work", address: "Infocity Avenue, Chandrasekharpur", latitude: 20.3480, longitude: 85.8090),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
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
                  Text("My Places", style: AppTypography.headlineLarge),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "Sentinel continuously evaluates safety advisories around your saved places.",
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 20),

              ...places.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GlassContainer(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.cyan.withValues(alpha: 0.15),
                            ),
                            child: Icon(_getPlaceIcon(p.label), color: AppColors.cyan, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(p.name, style: AppTypography.titleMedium),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceHighlight,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        p.label,
                                        style: AppTypography.bodySmall.copyWith(
                                          fontSize: 9,
                                          color: AppColors.cyan,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(p.address, style: AppTypography.bodySmall),
                              ],
                            ),
                          ),
                          const Icon(Icons.edit_outlined, color: AppColors.textMuted, size: 18),
                        ],
                      ),
                    ),
                  )),

              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_location_alt_outlined),
                label: const Text("Add New Place"),
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPlaceIcon(String label) {
    switch (label.toLowerCase()) {
      case 'home':
        return Icons.home_rounded;
      case 'college':
        return Icons.school_rounded;
      case 'work':
        return Icons.business_rounded;
      default:
        return Icons.location_on_outlined;
    }
  }
}
