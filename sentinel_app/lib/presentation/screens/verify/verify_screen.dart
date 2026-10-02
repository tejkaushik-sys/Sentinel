import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/verify_model.dart';
import '../../widgets/glass_container.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTab = "Person";
  List<VerifyRecordModel> _records = [];
  bool _isLoading = true;

  final List<String> _tabs = ["Person", "Case", "Claim", "Organization"];

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  void _fetchRecords() async {
    setState(() {
      _isLoading = true;
    });
    final records = await apiClient.verifyRecords(
      query: _searchController.text.trim(),
      type: _selectedTab,
    );
    if (mounted) {
      setState(() {
        _records = records;
        _isLoading = false;
      });
    }
  }

  void _showRecordDetails(VerifyRecordModel record) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF081822),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textDisabled,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(record.sourceSystem, style: AppTypography.headlineMedium),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: record.status == "Pending" ? AppColors.warningOrange.withValues(alpha: 0.2) : AppColors.emerald.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: record.status == "Pending" ? AppColors.warningOrange : AppColors.emerald,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      record.status,
                      style: AppTypography.bodySmall.copyWith(
                        color: record.status == "Pending" ? AppColors.warningOrange : AppColors.emerald,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (record.caseNumber != null)
                Text(record.caseNumber!, style: AppTypography.titleLarge),
              const SizedBox(height: 8),
              if (record.courtOrAuthority != null)
                Text("Court: ${record.courtOrAuthority}", style: AppTypography.bodyMedium),
              if (record.partyRole != null)
                Text("Party Role: ${record.partyRole}", style: AppTypography.bodyMedium),
              if (record.filingDate != null)
                Text("Filing Date: ${record.filingDate}", style: AppTypography.bodySmall),
              const SizedBox(height: 14),
              GlassContainer(
                padding: const EdgeInsets.all(12),
                child: Text(record.confidenceNote, style: AppTypography.bodySmall.copyWith(color: AppColors.cyan)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                child: const Text("Done"),
              ),
            ],
          ),
        ),
      ),
    );
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 4),
                      Text("Verify", style: AppTypography.headlineLarge),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceElevated,
                      border: Border.all(color: AppColors.borderLight, width: 1),
                    ),
                    child: const Icon(Icons.document_scanner_outlined, color: AppColors.cyan, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tabs Row: Person | Case | Claim | Organization
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _tabs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final tab = _tabs[index];
                    final isSelected = _selectedTab == tab;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTab = tab;
                        });
                        _fetchRecords();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.cyan : AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppColors.cyan : AppColors.border,
                            width: 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.cyan.withValues(alpha: 0.3),
                                    blurRadius: 10,
                                  ),
                                ]
                              : [],
                        ),
                        child: Center(
                          child: Text(
                            tab,
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
              const SizedBox(height: 16),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: "Enter name, case number, or keyword...",
                          hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onSubmitted: (_) => _fetchRecords(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.cyan, size: 20),
                      onPressed: _fetchRecords,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Section Title
              Text(
                "Public Records Found (${_records.length})",
                style: AppTypography.headlineMedium.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 12),

              // Records List
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
                    : ListView.builder(
                        itemCount: _records.length,
                        itemBuilder: (context, index) {
                          final rec = _records[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GlassContainer(
                              padding: const EdgeInsets.all(16),
                              onTap: () => _showRecordDetails(rec),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.cyan.withValues(alpha: 0.15),
                                        ),
                                        child: const Icon(
                                          Icons.account_balance_rounded,
                                          color: AppColors.cyan,
                                          size: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              rec.title,
                                              style: AppTypography.titleMedium.copyWith(fontSize: 15),
                                            ),
                                            if (rec.caseNumber != null) ...[
                                              const SizedBox(height: 2),
                                              Text(
                                                rec.caseNumber!,
                                                style: AppTypography.bodySmall.copyWith(
                                                  color: AppColors.cyan,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 22),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  const Divider(color: AppColors.border, height: 1),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        "Status: ",
                                        style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                                      ),
                                      Text(
                                        rec.status,
                                        style: AppTypography.bodySmall.copyWith(
                                          color: rec.status == "Pending" ? AppColors.warningOrange : AppColors.emerald,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (rec.courtOrAuthority != null) ...[
                                        Text(
                                          " | Court: ",
                                          style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                                        ),
                                        Expanded(
                                          child: Text(
                                            rec.courtOrAuthority!,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (rec.partyRole != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      "Party Role: ${rec.partyRole}",
                                      style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "View Record >",
                                      style: AppTypography.bodySmall.copyWith(
                                        color: AppColors.cyan,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              // Disclaimer Footer
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderLight, width: 0.8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.auto_awesome_rounded, color: AppColors.cyan, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "A name match is not proof of identity. Verify the original record and identity.",
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
