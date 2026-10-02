import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/user_model.dart';
import '../../widgets/glass_container.dart';

class TrustedCircleScreen extends StatelessWidget {
  const TrustedCircleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = [
      TrustedContactModel(id: "1", name: "Papa", phone: "+91 98450 11223", relationship: "Parent"),
      TrustedContactModel(id: "2", name: "Ananya (Roommate)", phone: "+91 97711 33445", relationship: "Friend"),
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
                  Text("Trusted Circle", style: AppTypography.headlineLarge),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "When you start a night journey or emergency status, your trusted contacts are automatically updated.",
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 20),

              ...contacts.map((c) => Padding(
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
                            child: const Icon(Icons.person_rounded, color: AppColors.cyan, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.name, style: AppTypography.titleMedium),
                                const SizedBox(height: 2),
                                Text("${c.relationship} • ${c.phone}", style: AppTypography.bodySmall),
                              ],
                            ),
                          ),
                          const Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 20),
                        ],
                      ),
                    ),
                  )),

              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Add Contact dialog opened!"), backgroundColor: AppColors.cyanDark),
                  );
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text("Add Trusted Contact"),
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
